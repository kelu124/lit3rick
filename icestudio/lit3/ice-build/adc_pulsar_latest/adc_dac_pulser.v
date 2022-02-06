module adc_dac_pulser (
 input RST,//PWM_CLK pin
 input DCLK,
 input [9:0] ADC_DATA,
 input TOP_T1,
 input TOP_T2,
 output EA_CLK,
 output reg PHV,
 output reg PnHV,
 output reg Pdamp,
 output reg HILO,
 output HV_EN,
 output ADC_CLK,
 output DAC_SCLK,
 output DAC_CS,
 output DAC_MOSI,
 input  spi_strb,
 output [7:0] to_spi,
 input  [7:0] from_spi,
 output [2:0] RGB
);
 
 wire        rst;
 assign rst = RST;
 reg         adc_trig;
 reg  [15:0] dac_data;
 reg         dac_valid;
 wire        dac_busy;

 reg  [12:0] adc_rd_addr;
 wire [15:0] adc_rd_data;
 reg         adc_wr_en;
 reg  [12:0] adc_wr_addr;
 wire [15:0] adc_wr_data;

 //48MHz internal Clock
 defparam OSCInst0.CLKHF_DIV = "0b00";
 SB_HFOSC OSCInst0 ( 
 .CLKHFEN(1'b1), 
 .CLKHFPU(1'b1),
 .CLKHF(ADC_CLK) 
 ) /* synthesis ROUTE_THROUGH_FABRIC= [0] */;

 //ADC Write address and Write Enable counter
 //@64MHz 8192 Clocks = 128us
 //@48MHz 8192 Clocks = 170.667us
 always@(posedge DCLK)begin 
  if(rst) begin
   adc_wr_addr <= 13'h1fff;
   adc_wr_en   <= 0;
  end else if(adc_trig) begin
   adc_wr_addr <= 0;
   adc_wr_en   <= 1;
  end else if(adc_wr_addr!=13'h1fff) begin
   adc_wr_addr <= adc_wr_addr + 1;
  end else if(adc_wr_addr==13'h1fff) begin
   adc_wr_en   <= 0;
  end
 end

 //Pulsar signals generation
 //@64MHz 8 clocks = 125ns; 32 clocks = 500ns; 64 clocks = 1000ns;
 //@48MHz 6 clocks = 125ns; 24 clocks = 500ns; 48 clocks = 1000ns;
 always@(posedge DCLK)begin
//  PHV   <= (adc_wr_addr>=32 && adc_wr_addr<40 ) ? 1'b1 : 1'b0;
//  PnHV  <= (adc_wr_addr>=48 && adc_wr_addr<56 ) ? 1'b1 : 1'b0;
//  Pdamp <= (adc_wr_addr>=64 && adc_wr_addr<128) ? 1'b1 : 1'b0;
  PHV   <= (adc_wr_addr>=24 && adc_wr_addr<30 ) ? 1'b1 : 1'b0;
  PnHV  <= (adc_wr_addr>=36 && adc_wr_addr<42 ) ? 1'b1 : 1'b0;
  Pdamp <= (adc_wr_addr>=48 && adc_wr_addr<96 ) ? 1'b1 : 1'b0;
 end

 //SRAM for ADC DATA Writing and Reading
 assign adc_wr_data = {TOP_T2,TOP_T1,HV_EN,HILO,ADC_DATA,2'd0};
 wire [13:0] ADDRESS;
 assign ADDRESS = {1'b0,(adc_wr_en)?adc_wr_addr:adc_rd_addr};
 SB_SPRAM256KA ram(
		.DATAOUT(adc_rd_data),
		.ADDRESS(ADDRESS),
		.DATAIN(adc_wr_data),
		.MASKWREN(4'b1111),
		.WREN(adc_wr_en),
		.CHIPSELECT(1'b1),
		.CLOCK(DCLK),
		.STANDBY(1'b0),
		.SLEEP(1'b0),
		.POWEROFF(1'b1)
 );
	
 //F_SPI Logic
 reg  [15:0] spi_data;
 reg  [13:0] spi_data_active;
 reg         spi_strb_adc_clk;
 reg         spi_strb_adc_clk_z;
 reg         spi_strb_adc_clk_zz;
 reg         spi_strb_adc_clk_zzz;
 reg         spi_strb_adc_clk_zzzz;
 reg         spi_data_byte;
 reg  [1:0]  spi_mode;
 assign to_spi = (spi_data_byte == 0) ? adc_rd_data[7:0] : adc_rd_data[15:8];
 always @(posedge DCLK or posedge rst) begin
	if (rst) begin
		spi_data <= 0;
		spi_strb_adc_clk <= 0;
		spi_strb_adc_clk_z <= 0;
		spi_strb_adc_clk_zz <= 0;
		spi_strb_adc_clk_zzz <= 0;
		spi_strb_adc_clk_zzzz <= 0;
		spi_data_byte <= 0;
	end else begin
		spi_strb_adc_clk_zzzz <= spi_strb_adc_clk_zzz;
		spi_strb_adc_clk_zzz <= spi_strb_adc_clk_zz;
		spi_strb_adc_clk_zz <= spi_strb_adc_clk_z;
		spi_strb_adc_clk_z <= spi_strb_adc_clk;
		spi_strb_adc_clk <= spi_strb;
		if (spi_strb_adc_clk_zzzz == 0 && spi_strb_adc_clk_zzz == 1 && spi_data_byte == 0) begin
			{spi_mode,spi_data_active} <= spi_data;
		end else spi_mode <= 0;
		if (spi_strb_adc_clk_zzz == 0 && spi_strb_adc_clk_zz == 1) begin
			spi_data <= {spi_data[7:0], from_spi};
			spi_data_byte <= ~spi_data_byte;
		end
	end
 end
 always@(posedge DCLK)begin
   if(rst)begin
    adc_trig       <= 0;
    HILO           <= 0;
    dac_data       <= 0;
    dac_valid      <= 0;
	adc_rd_addr    <= 0;
   end else begin
    adc_trig       <= (spi_mode==2'b01);
    HILO           <= (spi_mode==2'b01) ? spi_data_active[0] : HILO;
    dac_data[7:0]  <= (spi_mode==2'b10)?spi_data_active[7:0]:dac_data[7:0];
    dac_data[15:8] <= (spi_mode==2'b11)?spi_data_active[7:0]:dac_data[15:8];
    dac_valid      <= (spi_mode==2'b11);
	adc_rd_addr    <= spi_data_active[12:0];
   end
 end

 //DAC-SPI Logic
 mcp4812 mcp4812_inst(
        .clk(DCLK), //64MHz
        .reset(rst),
        .data(dac_data),
        .data_valid(dac_valid),
        .busy(dac_busy),
        .CSn(DAC_CS),
        .SCK(DAC_SCLK), //6.4MHz
        .SDI(DAC_MOSI),
        .LDACn()
 );

 //Driving output LED for status monitering
 //Red  -> Capturing Data or Busy for SPI_Read
 //Green-> READY for Capture or Read
 //Blue -> Blinks during DAC Configuration
 SB_RGBA_DRV #(
            .CURRENT_MODE ("0b0"),
            .RGB0_CURRENT ("0b111111"),
            .RGB1_CURRENT ("0b111111"),
            .RGB2_CURRENT ("0b111111")
 ) RGB_driver (
            .CURREN   (1'b1),       // I
            .RGBLEDEN (1'b1),       // I
            .RGB0PWM  (~adc_wr_en), // I
            .RGB1PWM  (adc_wr_en|dac_valid),  // I
            .RGB2PWM  (~dac_valid),  // I
            .RGB2     (RGB[2]),      // O
            .RGB1     (RGB[1]),     // O
            .RGB0     (RGB[0])        // O
 );

 assign EA_CLK = adc_wr_en;
 
 assign HV_EN = adc_wr_en;

endmodule

