module adc_dac_pulser_top (
 input RCLK,
 input BT_USER,
 input BT_TRIG,
 input DCLK,
 input [9:0] ADC_DATA,
 input HILO,
 input HV_EN,
 input TOP_T1,
 input TOP_T2,
 input F_SCLK,
 input F_MOSI,
 input ICE_CS,
 output reg PHV,
 output reg PnHV,
 output reg Pdamp,
 output ADC_CLK,
 output DAC_SCLK,
 output DAC_CS,
 output DAC_MOSI,
 output F_MISO,
 output Lred,
 output Lgreen,
 output Lblue
);

 reg         bt_user_r;
 reg         bt_trig_r;
 reg  [7:0]  bt_user_count;
 reg  [7:0]  bt_trig_count;
 reg         bt_user_pulse;
 reg         bt_trig_pulse;
 wire        rst;
 wire        trig;

 reg         adc_trig;
 reg  [15:0] dac_data;
 reg         dac_valid;
 wire        dac_busy;

 reg  [12:0] adc_rd_addr;
 wire [15:0] adc_rd_data;
 reg         adc_wr_en;
 reg  [12:0] adc_wr_addr;
 wire [15:0] adc_wr_data;

 //Debounsing logic and pulse generation for both the active-low buttons
 always@(posedge DCLK)begin
  bt_user_r     <= BT_USER;
  bt_trig_r     <= BT_TRIG;
  bt_user_count <= (bt_user_r==0 && BT_USER==0 && bt_user_count!=8'hff) ? (bt_user_count+1) : 0;
  bt_trig_count <= (bt_trig_r==0 && BT_TRIG==0 && bt_trig_count!=8'hff) ? (bt_trig_count+1) : 0;
  bt_user_pulse <= (bt_user_count==8'hfe) ? 1'b1 : 1'b0;
  bt_trig_pulse <= (bt_trig_count==8'hfe) ? 1'b1 : 1'b0;
 end
 //Using BT_USER as Reset Button
 assign rst  = bt_user_pulse;
 assign trig = bt_trig_pulse | adc_trig;

 //PLL and clock divider by 3
 wire PLL_CLK;
 reg [1:0] pll_Pcnt;
 reg [1:0] pll_Ncnt;
 up5kPLL pll_uut(.PACKAGEPIN(RCLK),    //12MHz
                 .PLLOUTCORE(PLL_CLK), //192MHz
                 .PLLOUTGLOBAL(),
                 .RESET(!rst));        //activeLow
 always@(posedge PLL_CLK) pll_Pcnt = (pll_Pcnt==2)?0:pll_Pcnt+1;
 always@(negedge PLL_CLK) pll_Ncnt = (pll_Ncnt==2)?0:pll_Ncnt+1;
 assign ADC_CLK = (pll_Pcnt==2)|(pll_Ncnt==2); //64MHz

 //ADC Write address and Write Enable counter
 always@(posedge DCLK)begin //8192 Clocks = 128us
  if(rst) begin
   adc_wr_addr <= 13'h1fff;
   adc_wr_en   <= 0;
  end else if(trig) begin
   adc_wr_addr <= 0;
   adc_wr_en   <= 1;
  end else if(adc_wr_addr!=13'h1fff) begin
   adc_wr_addr <= adc_wr_addr + 1;
  end else if(adc_wr_addr==13'h1fff) begin
   adc_wr_en   <= 0;
  end
 end

 //Pulsar signals generation
 always@(posedge DCLK)begin//8 clocks = 125ns; 32 clocks = 500ns; 64 clocks = 1000ns;
  PHV   <= (adc_wr_addr>=32 && adc_wr_addr<40 ) ? 1'b1 : 1'b0;
  PnHV  <= (adc_wr_addr>=48 && adc_wr_addr<56 ) ? 1'b1 : 1'b0;
  Pdamp <= (adc_wr_addr>=64 && adc_wr_addr<128) ? 1'b1 : 1'b0;
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
 wire        spi_strb;
 wire [7:0]  to_spi;
 wire [7:0]  from_spi;
 reg  [15:0] spi_data;
 reg  [13:0] spi_data_active;
 reg         spi_strb_adc_clk;
 reg         spi_strb_adc_clk_z;
 reg         spi_strb_adc_clk_zz;
 reg         spi_strb_adc_clk_zzz;
 reg         spi_strb_adc_clk_zzzz;
 reg         spi_data_byte;
 reg  [1:0]  spi_mode;
 spi_slave spi_uut(
            .rstb(!rst),
            .ten(1'b1),
            .mlb(1'b1),
            .ss(ICE_CS),
            .sck(F_SCLK),
            .sdin(F_MISO),
            .sdout(F_MOSI),
            .tdata(to_spi),
            .done(spi_strb),
            .rdata(from_spi)
 );
 assign to_spi = (spi_data_byte == 0) ? adc_rd_data[7:0] : adc_rd_data[15:8];
 always @(posedge DCLK) begin
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
    dac_data       <= 0;
    dac_valid      <= 0;
	adc_rd_addr    <= 0;
   end else begin
    adc_trig       <= (spi_mode==2'b01);
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
            .RGB2     (Lblue),      // O
            .RGB1     (Lgreen),     // O
            .RGB0     (Lred)        // O
 );

endmodule

