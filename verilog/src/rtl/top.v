`timescale 1ns/1ps

module top(
        `ifdef SIMULATION
            input clk,
            // input reset,
        `endif

        // CPU i2c connection
        inout i2c_sda,
        inout i2c_scl,

        // buttons
        input BUT_USER,
        input BUT_TRIG,

        // input top_turn2,

        output PHV,
        output PnHV,
        output PDamp,
        output HILO,
        output HV_EN,

        // AD9629 ADC connections
        output ADC_REF_CLK,
        input ADC_DCLK,
        input [11:0] ADC_D,

        // RGB connection
        output LED_R,
        output LED_G,
        output LED_B,

        // SPI connection to RPI
        inout RPI_MOSI,
        inout RPI_MISO,
        inout RPI_SCLK,
        input RPI_CSn,

        // I2S connection
        // output i2s_clk,
        input i2s_clk,
        output i2s_lrclk,
        output i2s_data,

        // mcp4812 DAC connection
        output CSn,
        output SCK,
        output SDI
    );

    parameter p_device_address = 7'h25;
    parameter p_axilite_data_width = 32;
    parameter p_axilite_addr_width = 16;

    localparam p_signal_mem_base = 16'h2000;
    localparam p_fft_mem_base = 16'h4000;
    localparam p_registers_base = 16'h0000;
    localparam p_page_size = 16'h2000;

    localparam p_dac_addr = p_registers_base + 16'h0010;
    localparam p_rgb_addr = p_registers_base + 16'h0001;
    // control_reg[0] - enable access to signal ram through i2c
    // control_reg[1] - enable rgb control through i2c
    // control_reg[2] - enable access to FFT ram through spi
    // control_reg[3] - enable access to FFT ram I2S
    // control_reg[4] - enable start trigger source from i2c
    localparam p_control_addr = p_registers_base + 16'h0002;
    localparam p_hilo_addr = p_registers_base + 16'h0005;
    localparam p_dac_mem_addr = p_registers_base + 16'h0006;
    localparam p_waveform_addr = p_registers_base + 16'h0007;
    localparam p_pdelay = p_registers_base + 16'h0008;
    localparam p_PHV_time = p_registers_base + 16'h0009;
    localparam p_PnHV_time = p_registers_base + 16'h000A;
    localparam p_PDamp_time = p_registers_base + 16'h000B;

    localparam STATE_WAIT_FFT   = 0;
    localparam STATE_WAIT_FINISH = 1;
    localparam STATE_PROCESS    = 2;
    localparam START_ITER       = 3;
    localparam SEND_I2S         = 4;
    localparam FFT_READ_CYCLES = 32;

    `ifndef SIMULATION
        localparam DEBOUNCE_CNT = 1000;
    `else
        localparam DEBOUNCE_CNT = 100;
    `endif

    wire i2c_scl_i;
    wire i2c_scl_o;
    wire i2c_scl_t;
    wire i2c_sda_i;
    wire i2c_sda_o;
    wire i2c_sda_t;

    reg  [7:0]  dac_mem_addr_wr;
    reg         dac_mem_wr;
    reg  [15:0] dac_mem_data_wr;

    wire [p_axilite_addr_width-1:0]  m_axil_awaddr;
    wire [2:0]             m_axil_awprot;
    wire                   m_axil_awvalid;
    wire                   m_axil_awready;
    wire [p_axilite_data_width-1:0]  m_axil_wdata;
    wire [p_axilite_data_width / 8-1:0]  m_axil_wstrb;
    wire                   m_axil_wvalid;
    wire                   m_axil_wready;
    wire [1:0]             m_axil_bresp;
    wire                   m_axil_bvalid;
    wire                   m_axil_bready;
    wire [p_axilite_addr_width-1:0]  m_axil_araddr;
    wire [p_axilite_addr_width-1:0]  m_axil_araddr_word;
    wire [2:0]             m_axil_arprot;
    wire                   m_axil_arvalid;
    reg                    m_axil_arvalid_z;
    reg                    m_axil_arvalid_zz;
    reg                    m_axil_arvalid_zzz;
    wire                   m_axil_arready;
    reg [p_axilite_data_width-1:0]  m_axil_rdata;
    wire [1:0]             m_axil_rresp;
    reg                    m_axil_rvalid;
    wire                   m_axil_rready;

    wire rpi_miso_int;
    wire rpi_mosi_int;
    wire rpi_sclk_int;

    reg reset;
    reg [7:0] reset_cnt = 0;
    // `ifndef SIMULATION
    //     wire ADC_DCLK;
    // `endif

    wire [2:0] rgb_val;

    reg  [31:0] regs [5:0];
    wire        control_reg_wr;
    reg         control_reg_wr_z;

    reg  [15:0] dac_data;
    reg         dac_data_val;
    wire        dac_busy;

    wire [13:0] signal_ram_addr;
    wire [15:0] signal_ram_data;
    wire [15:0] from_signal_ram;
    wire [11:0] from_ADC;
    wire from_ADC_vld;
    wire [13:0] adc_ram_addr;
    wire finish_adc_receiving;
    wire we_signal;
    wire top_turn2_filter;

    reg [3:0] state = STATE_WAIT_FFT;
    reg [3:0] state_z = STATE_WAIT_FFT;
    reg [3:0] state_zz = STATE_WAIT_FFT;
    reg [13:0] fft_in_cnt = 0; // when this wraps we update the frequency bins
    reg [13:0] fft_out_cnt = 0; // when this wraps we update the frequency bins
    reg [13:0] read_cycles = 0; // keep track of fft reads -> bram
    wire fft_start;
    wire fft_work;
    wire fft_finish;
    reg fft_start_iter = 0;
    reg fft_start_iter_z = 0;
    reg fft_start_iter_zz = 0;

    wire [15:0] to_fft_memory;
    wire [15:0] from_fft_memory;
    wire [13:0] fft_memory_addr;
    wire        fft_memory_wr;
    wire [13:0] fft_addr_rd;
    wire [15:0] from_signal_ram_to_fft;
    wire [13:0] from_fft_to_mem_addr;
    wire [15:0] from_fft_to_mem_data;
    wire        from_fft_to_mem_wr;
    
    wire BUT_USER_deb;
    wire BUT_TRIG_deb;

    wire        spi_strb;
    wire [7:0]  from_spi;
    wire [7:0]  to_spi;
    wire [15:0] from_signal_ram_to_spi;
    wire [15:0] from_fft_ram_to_spi;

    wire i2c_rgb_control;
    wire rgb_b;
    wire rgb_g;
    wire rgb_r;

    wire spi_access_to_fft;
    reg [15:0] spi_addr;
    reg [15:0] spi_addr_active;
    reg spi_strb_adc_clk;
    reg spi_strb_adc_clk_z;
    reg spi_strb_adc_clk_zz;
    reg spi_strb_adc_clk_zzz;
    reg spi_strb_adc_clk_zzzz;
    reg spi_data_byte;

    wire [31:0] to_i2s_left;
    wire [31:0] to_i2s_right;
    wire [15:0] to_i2s;
    wire [63:0] i2s_tmp_data;
    wire [15:0] i2s_mem_addr;
    wire [15:0] from_signal_ram_to_i2s;
    wire [15:0] from_fft_ram_to_i2s;
    wire fifo_i2s_rd;
    wire full_i2s_fifo;
    wire empty_i2s_fifo;

    wire [13:0] i2c_signal_ram_addr;
    wire        i2c_signal_ram_addr_we;
    wire [15:0] from_signal_ram_to_i2c;
    wire [15:0] from_fft_ram_to_i2c;

    wire [2:0] sel_signal_ram;
    wire [2:0] sel_fft_ram;

    wire [9:0] state_main;

    wire [11:0] ADC_D_int;

    wire        wren_fifo_i2s;
    wire [7:0]  from_i2s_fifo;

    reg [15:0] pdelay;
    reg [15:0] PHV_time;
    reg [15:0] PnHV_time;
    reg [15:0] PDamp_time;

    `ifndef SIMULATION
        // genvar i;
        // for (i = 0; i < 12; i = i + 1) begin
        //     IOL_B
        //     #(
        //         .LATCHIN ("LATCH_REG"),
        //         .DDROUT  ("NO")
        //     ) IOL_B_inst (
        //         .PADDI  (ADC_D[i]),  // I
        //         .DO1    (1'b0),  // I
        //         .DO0    (1'b0),  // I
        //         .CE     (1'b1),  // I
        //         .IOLTO  (1'b0),  // I
        //         .HOLD   (1'b0),  // I
        //         .INCLK  (ADC_DCLK),  // I
        //         .OUTCLK (ADC_DCLK),  // I
        //         .PADDO  (),  // O
        //         .PADDT  (),  // O
        //         .DI1    (ADC_D_int[i]),  // O
        //         .DI0    ()   // O
        //     );
        // end
        assign ADC_D_int = ADC_D;
    `else
        assign ADC_D_int = ADC_D;
    `endif

    reg [5:0] clk_divider_cnt = 5'd0;

    // Emulate reset
    always @(posedge clk) begin
        reset = (reset_cnt == 50) ? 0 : 1;
    end

    always@(posedge clk) begin
        if (reset_cnt < 50) begin
            reset_cnt <= reset_cnt + 1;
        end
    end

    `ifndef SIMULATION

        // High frequency oscillator
        HSOSC /*#(
            .CLKHF_DIV (2'b00)
        )*/ hi_clock_gen_inst (
            .CLKHFPU (1'b1),  // I
            .CLKHFEN (1'b1),  // I
            .CLKHF   (clk)   // O
        );

        // RGB driver
        RGB #(
            .CURRENT_MODE (0),
            .RGB0_CURRENT (6'd63),
            .RGB1_CURRENT (6'd63),
            .RGB2_CURRENT (6'd63)
            // .RGB0_CURRENT (63),
            // .RGB1_CURRENT (63),
            // .RGB2_CURRENT (63)
        ) RGB_driver (
            .CURREN   (1'b1),  // I
            .RGBLEDEN (1'b1),  // I
            .RGB0PWM  (rgb_val[2]),  // I
            .RGB1PWM  (rgb_val[1]),  // I
            .RGB2PWM  (rgb_val[0]),  // I
            // .RGB0PWM  (1'b1),  // I
            // .RGB1PWM  (1'b0),  // I
            // .RGB2PWM  (1'b0),  // I
            .RGB2     (LED_B),  // O
            .RGB1     (LED_G),  // O
            .RGB0     (LED_R)   // O
        );

        pll_adc pll_adc_inst(
            .ref_clk_i(clk),
            .rst_n_i(~reset),
            .lock_o( ),
            .outcore_o( ADC_REF_CLK ),
            .outglobal_o()
        );

    `endif

    assign to_spi = (sel_fft_ram == 3 && spi_data_byte == 0) ? from_fft_ram_to_spi[7:0] :
                    (sel_fft_ram == 3 && spi_data_byte == 1) ? from_fft_ram_to_spi[15:8] :
                    (spi_data_byte == 0) ? from_signal_ram_to_spi[7:0] : from_signal_ram_to_spi[15:8];
    
    spi_slave spi_slave_inst (
        .rstb  (!reset),
        .ten   (1'b1),
        .tdata (to_spi),
        .mlb   (1'b1),
        .ss    (RPI_CSn),
        .sck   (rpi_sclk_int),
        .sdin  (rpi_mosi_int),
        .sdout (rpi_miso_int),
        .done  (spi_strb),
        .rdata (from_spi)
    );

    always @(posedge ADC_DCLK or posedge reset) begin
        if (reset == 1) begin
            spi_addr <= 0;
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
                spi_addr_active <= spi_addr;
            end
            if (spi_strb_adc_clk_zzz == 0 && spi_strb_adc_clk_zz == 1) begin
                spi_addr <= {spi_addr, from_spi};
                spi_data_byte <= ~spi_data_byte;
            end
        end
    end

    // i2c buffers
    assign i2c_scl_i = i2c_scl;
    assign i2c_scl = i2c_scl_t ? 1'bz : i2c_scl_o;
    assign i2c_sda_i = i2c_sda;
    assign i2c_sda = i2c_sda_t ? 1'bz : i2c_sda_o;

    // RPI SPI buffer
    assign RPI_MISO = (RPI_CSn == 1) ? 1'bz : rpi_miso_int;
    assign rpi_mosi_int = (RPI_CSn == 1) ? 1'bz : RPI_MOSI;
    assign RPI_MOSI = 1'bz;
    assign rpi_sclk_int = (RPI_CSn == 1) ? 1'bz : RPI_SCLK;
    assign RPI_SCLK = 1'bz;

    // assign PnHV = 1'b0;

    // AXI registers

    /* control regster bit fields:
        [0] - Select source of the data acquisition
            0 - From ADC and through trig button
            1 - From RPI and through i2c command
        [1] - Select source of the RGB leds control
            0 - From main FSM
            1 - From i2c
        [2] - Enable SPI access to signal ram or fft ram
            0 - Access to signal ram
            1 - Access to FFT ram
        [3] - Start ADC capture
        [4] - Autorestart ADC capture and signal filtration
        [10:8] - select source for access to the signal ram
            0 - ADC access
            1 - i2s access
            2 - i2c access
            3 - spi access
            4 - fft core access
            5 - Auto from main fsm
        [18:16] - select source for access to the FFT ram
            0 - ADC access
            1 - i2s access
            2 - i2c access
            3 - spi access
            4 - fft core access
            5 - Auto from main fsm
    */


    assign rgb_val = (i2c_rgb_control == 1) ? regs[p_rgb_addr] : {rgb_b, rgb_g, rgb_r};
    assign i2c_rgb_control = regs[p_control_addr][1];
    assign spi_access_to_fft = regs[p_control_addr][2];
    assign control_reg_wr = ((m_axil_awaddr >> 2) == p_control_addr) ? 1'b1 : 1'b0;
    assign HILO = regs[p_hilo_addr][0];

    assign sel_signal_ram = (fft_work == 0) ? regs[p_control_addr][10:8] : 4;
    assign sel_fft_ram = (fft_work == 0) ? regs[p_control_addr][18:16] : 4;

    assign m_axil_awready = 1;
    assign m_axil_wready = 1;
    assign m_axil_arready = ~m_axil_arvalid_z;
    assign m_axil_bvalid = m_axil_bready;
    assign m_axil_araddr_word = m_axil_araddr[15:2];

    reg [15:0] i2s_cnt;
    reg i2s_lrclk_z;

    always @(posedge ADC_DCLK)
        i2s_lrclk_z <= i2s_lrclk;

    always @(posedge i2s_clk) begin
    // always @(posedge rpi_sclk_int) begin
        i2s_cnt <= i2s_cnt + 1;
    end
    
    // registers block
    always @(posedge ADC_DCLK or posedge reset) begin : registers_block
        integer i;
        if (reset == 1) begin
            for (i = 0; i < 4; i = i + 1) begin
                regs[i] <= 0;
            end
            m_axil_rvalid <= 0;
            m_axil_rdata <= 0;
            m_axil_arvalid_z <= 0;
            m_axil_arvalid_zz <= 0;
            m_axil_arvalid_zzz <= 0;
            control_reg_wr_z <= 0;
        end else begin
            m_axil_arvalid_zzz <= m_axil_arvalid_zz;
            m_axil_arvalid_zz <= m_axil_arvalid_z;
            m_axil_arvalid_z <= m_axil_arvalid;
            control_reg_wr_z <= control_reg_wr;

            regs[3][0] <= fft_work;
            
            
            // regs[3][15:8] <= state_main;
            // if (top_turn2_filter == 1) begin
            //     regs[3][23:16] <= regs[3][23:16] + 1;
            // end
            // if (wren_fifo_i2s == 1 && full_i2s_fifo == 1) begin
            //     regs[3][24] <= 1;
            // end
            // if (fifo_i2s_rd == 1 && empty_i2s_fifo == 1) begin
            //     regs[3][25] <= 1;
            // end

            if (finish_adc_receiving == 1) begin
                regs[p_control_addr][3] <= 1'b0;
            end
            
            dac_mem_wr <= 0;
            if (m_axil_awvalid == 1 && m_axil_awaddr >> 2 == p_dac_mem_addr) begin
                dac_mem_addr_wr <= m_axil_wdata[23:16];
                dac_mem_wr <= 1;
                dac_mem_data_wr <= m_axil_wdata[15 : 0];
            end else if (m_axil_awvalid == 1 && m_axil_awaddr >> 2 == p_pdelay) begin
                pdelay <= m_axil_wdata;
            end else if (m_axil_awvalid == 1 && m_axil_awaddr >> 2 == p_PHV_time) begin
                PHV_time <= m_axil_wdata;
            end else if (m_axil_awvalid == 1 && m_axil_awaddr >> 2 == p_PnHV_time) begin
                PnHV_time <= m_axil_wdata;
            end else if (m_axil_awvalid == 1 && m_axil_awaddr >> 2 == p_PDamp_time) begin
                PDamp_time <= m_axil_wdata;
            end else if (m_axil_awvalid == 1 && m_axil_wvalid == 1 && m_axil_awaddr[15] == 0) begin
                regs[m_axil_awaddr >> 2] <= m_axil_wdata;
            end

            if (m_axil_arvalid_zzz == 1 && m_axil_arvalid_zz == 0) begin
                if (m_axil_araddr[15] == 0) begin
                    m_axil_rdata <= regs[m_axil_araddr_word[7:0]];
                end else if (m_axil_araddr[15] == 1 && sel_fft_ram == 2) begin
                    m_axil_rdata <= from_fft_ram_to_i2c;
                end else if (m_axil_araddr[15] == 1) begin
                    // $display(">>> %8tps | readed data thorugh i2c from signal ram = %8h", $time(), from_signal_ram_to_i2c);
                    m_axil_rdata <= from_signal_ram_to_i2c;
                end
                m_axil_rvalid <= 1;
            end else if (m_axil_rready == 1) begin
                m_axil_rvalid <= 0;
            end
        end
    end

    `ifndef SIMULATION
    i2c_slave_axil_master #(
        .FILTER_LEN(4),
        .DATA_WIDTH(p_axilite_data_width),  // width of data bus in bits
        .ADDR_WIDTH(p_axilite_addr_width),  // width of address bus in bits
        .STRB_WIDTH(p_axilite_data_width/8)
    ) i2c_slave_axil_master_inst (
        // .ADC_DCLK (ADC_DCLK),
        .clk (ADC_DCLK),
        .rst (reset),

        /*
        * I2C interface
        */
        .i2c_scl_i (i2c_scl_i),
        // .i2c_scl_i (scl_z),
        .i2c_scl_o (i2c_scl_o),
        .i2c_scl_t (i2c_scl_t),
        .i2c_sda_i (i2c_sda_i),
        // .i2c_sda_i (sda_z),
        .i2c_sda_o (i2c_sda_o),
        .i2c_sda_t (i2c_sda_t),

        /*
        * AXI lite master interface
        */
        .m_axil_awaddr  (m_axil_awaddr),
        .m_axil_awprot  (m_axil_awprot),
        .m_axil_awvalid (m_axil_awvalid),
        .m_axil_awready (m_axil_awready),
        .m_axil_wdata   (m_axil_wdata),
        .m_axil_wstrb   (m_axil_wstrb),
        .m_axil_wvalid  (m_axil_wvalid),
        .m_axil_wready  (m_axil_wready),
        .m_axil_bresp   (m_axil_bresp),
        .m_axil_bvalid  (m_axil_bvalid),
        .m_axil_bready  (m_axil_bready),
        .m_axil_araddr  (m_axil_araddr),
        .m_axil_arprot  (m_axil_arprot),
        .m_axil_arvalid (m_axil_arvalid),
        .m_axil_arready (m_axil_arready),
        .m_axil_rdata   (m_axil_rdata),
        .m_axil_rresp   (m_axil_rresp),
        .m_axil_rvalid  (m_axil_rvalid),
        .m_axil_rready  (m_axil_rready),

        /*
        * Status
        */
        .busy           (),
        .bus_addressed  (),
        .bus_active     (),

        /*
        * Configuration
        */
        .enable         (1'b1),
        .device_address (p_device_address)
    );
    `endif

    wire [7:0]  dac_addr_rd;
    wire [15:0] dac_data_rd;
    reg  [15:0] dac_cnt;
    reg  [15:0] dac_cnt_z;
    reg  [15:0] dac_cnt_zz;
    reg  [15:0] dac_cnt_zzz;
    reg  [15:0] dac_data_int;
    wire        start_dac_count;

    assign dac_addr_rd = dac_cnt[15:9];

    always @(posedge ADC_DCLK or posedge reset) begin
        if (reset == 1) begin
            dac_data_val <= 1'b0;
            dac_cnt <= 0;
            dac_cnt_z <= 0;
            dac_cnt_zz <= 0;
            dac_cnt_zzz <= 0;
        end else begin
            dac_cnt_zzz <= dac_cnt_zz;
            dac_cnt_zz <= dac_cnt_z;
            dac_cnt_z <= dac_cnt;
            if (start_dac_count == 1) begin
                dac_cnt <= 0;
            end else if (dac_cnt < 8192) begin
                dac_cnt <= dac_cnt + 1;
            end

            if (dac_busy == 1) begin
                dac_data_val <= 1'b0;
            end else if ((m_axil_awaddr == p_dac_addr) && (m_axil_wvalid == 1)) begin
                dac_data_int <= m_axil_wdata;
                dac_data     <= m_axil_wdata;
                dac_data_val <= 1'b1;
            end else if (dac_cnt_zzz[15:9] != dac_cnt_zz[15:9]) begin
                if (dac_cnt == 8192) begin
                    dac_data <= dac_data_int;
                end else begin
                    dac_data     <= dac_data_rd;
                end
                dac_data_val <= 1'b1;
            end
        end
    end
    
    ebr_dp dac_memory (
        .wr_clk_i    (ADC_DCLK), 
        .rd_clk_i    (ADC_DCLK), 
        .rst_i       (reset), 
        .wr_clk_en_i (1'b1), 
        .rd_en_i     (1'b1), 
        .rd_clk_en_i (1'b1), 
        .wr_en_i     (dac_mem_wr), 
        .wr_data_i   (dac_mem_data_wr), 
        .wr_addr_i   (dac_mem_addr_wr), 
        .rd_addr_i   (dac_addr_rd), 
        .rd_data_o   (dac_data_rd)
    );

    mcp4812 mcp4812_inst(
        .clk(ADC_DCLK), 
        .reset(reset),

        .data(dac_data),
        .data_valid(dac_data_val),
        .busy(dac_busy),

        .CSn(CSn),
        .SCK(SCK),
        .SDI(SDI),
        .LDACn()
    );


    debounce 
        #(.NDELAY(DEBOUNCE_CNT))
    debounce_btn_user(
        .clk      (ADC_DCLK), 		
        .reset_n  (~reset), 
        .idebounce(BUT_USER),
        .odebounce(BUT_USER_deb)  
    );

    debounce
        #(.NDELAY(DEBOUNCE_CNT))
    debounce_btn_trig(
        .clk      (ADC_DCLK), 		
        .reset_n  (~reset), 
        .idebounce(BUT_TRIG),
        .odebounce(BUT_TRIG_deb)  
    );

    main_fsm main_fsm_inst(
        .clk              (ADC_DCLK),
        .reset            (reset),
        // .start         (BUT_TRIG_deb),
        .start            (1'b0),
        // .end_fft       (1'b1), // for debug
        .end_fft          (fft_finish),
        .fft_working      (fft_work),
        .control_reg_wr   (control_reg_wr_z),
        .control_reg      (regs[p_control_addr]),
        .pdelay           (pdelay),
        .PHV_time         (PHV_time),
        .PnHV_time        (PnHV_time),
        .PDamp_time       (PDamp_time),
        // .end_working   (BUT_USER_deb),
        .end_working      (1'b0),
        .almost_empty_i2s (almost_empty_i2s),
        .start_fft        (fft_start),
        .start_sampling   (top_turn2_filter),
        .start_dac_count  (start_dac_count),
        .rgb_r            (rgb_r),
        .rgb_g            (rgb_g),
        .rgb_b            (rgb_b),
        .PHV              (PHV),
        .PnHV             (PnHV),
        .PDamp            (PDamp),
        .autorestart_mode (autorestart_mode),
        .state_o          (state_main)
    );

    // assign top_turn2_filter = 0; // temporary asign for i2s debugging
    
    assign HV_EN = from_ADC_vld;

    adc_receiver adc_receiver_inst (
        .clk        (ADC_DCLK),
        .reset      (reset),
        .start      (top_turn2_filter),
        .ADC_D      (ADC_D_int),
        .DOUT       (from_ADC),
        .DOUT_vld   (from_ADC_vld),
        .sample_num (adc_ram_addr),
        .finish     (finish_adc_receiving)
    );

    i2s_tx #(
        .AUDIO_DW(8)
    ) i2s_tx_inst (
        .sclk(i2s_clk),
        .rst(0),

        // Prescaler for lrclk generation from sclk should hold the number of
        // sclk cycles per channel (left and right).
        .prescaler(8),

        .lrclk(i2s_lrclk),
        .sdata(i2s_data),

        // Parallel datastreams
        .left_chan(to_i2s_left),
        .right_chan(to_i2s_right)
    );

    assign to_i2s_left = i2s_tmp_data[7:0];
    assign to_i2s_right = i2s_tmp_data[15:8];
    assign to_i2s = (autorestart_mode == 1) ? from_i2s_fifo : from_fft_ram_to_i2s;

    i2s_control  #(
        .AUDIO_DW(8)
    ) i2s_control_inst (
        .clk(ADC_DCLK),
        .reset(reset || (control_reg_wr_z && regs[p_control_addr][4])),

        .i2s_clk(i2s_clk),
        .i2s_tx_reset(),
        
        // .start(fft_start),
        .start(0),
        // .start(end_fft),
        .i2s_channel(i2s_lrclk),
        .data_out(i2s_tmp_data),

        .mem_addr(i2s_mem_addr),
        // .from_mem(from_signal_ram_to_i2s[11:4])
        .fifo_rd(fifo_i2s_rd),
        .from_mem(to_i2s)
    );

    assign wren_fifo_i2s = from_fft_to_mem_wr && autorestart_mode;
    
    sc_fifo fifo_i2s (
        .clk_i         (ADC_DCLK), 
        .rst_i         (reset || (control_reg_wr_z && regs[p_control_addr][4])), 
        .wr_en_i       (wren_fifo_i2s && !full_i2s_fifo), 
        .rd_en_i       (fifo_i2s_rd && !empty_i2s_fifo), 
        .wr_data_i     (from_fft_to_mem_data), 
        .full_o        (full_i2s_fifo), 
        .empty_o       (empty_i2s_fifo), 
        .almost_full_o (), 
        .almost_empty_o(almost_empty_i2s),
        .rd_data_o     (from_i2s_fifo)
    );

    assign i2c_signal_ram_addr = (m_axil_arvalid == 1 || m_axil_arvalid_z == 1 || m_axil_arvalid_zz == 1) ? m_axil_araddr[14:2] : m_axil_awaddr[14:2];
    assign i2c_signal_ram_addr_we = m_axil_wvalid && m_axil_awaddr[15];

    memory_mux memory_mux_signal_ram(
        .addr_i_0   (adc_ram_addr),
        .we_i_0     (from_ADC_vld),
        // .we_i_0     (0),
        .data_i_0   ({{4{from_ADC[11]}}, from_ADC}),
        .data_o_0   (),

        .addr_i_1   (i2s_mem_addr),
        .we_i_1     (1'b0),
        .data_i_1   (0),
        .data_o_1   (from_signal_ram_to_i2s),

        .addr_i_2   (i2c_signal_ram_addr),
        .we_i_2     (i2c_signal_ram_addr_we),
        .data_i_2   ({m_axil_wdata[23:16], m_axil_wdata[31:24]}),
        .data_o_2   (from_signal_ram_to_i2c),

        .addr_i_3   (spi_addr_active),
        .we_i_3     (1'b0),
        .data_i_3   (0),
        .data_o_3   (from_signal_ram_to_spi),

        .addr_i_4   (fft_addr_rd),
        .we_i_4     (0),
        .data_i_4   (0),
        .data_o_4   (from_signal_ram_to_fft),


        .addr_mem   (signal_ram_addr),
        .we_mem     (we_signal),
        .data_i_mem (signal_ram_data),
        .data_o_mem (from_signal_ram),

        .sel        (sel_signal_ram)
    );

    ram_256k signal_memory (
        .AD(signal_ram_addr),
        .DI(signal_ram_data),
        .WE(we_signal),
        .MASKWE(4'b1111),
        .CS(1'b1),
        .CK(ADC_DCLK),
        .DO(from_signal_ram)
    );

    memory_mux memory_mux_fft_ram(
        .addr_i_1   (i2s_mem_addr),
        .we_i_1     (1'b0),
        .data_i_1   (0),
        .data_o_1   (from_fft_ram_to_i2s),

        .addr_i_2   (i2c_signal_ram_addr),
        .we_i_2     (0),
        .data_i_2   (0),
        .data_o_2   (from_fft_ram_to_i2c),

        .addr_i_3   (spi_addr_active),
        .we_i_3     (1'b0),
        .data_i_3   (0),
        .data_o_3   (from_fft_ram_to_spi),

        .addr_i_4   (from_fft_to_mem_addr),
        .we_i_4     (from_fft_to_mem_wr),
        .data_i_4   (from_fft_to_mem_data),
        // .data_i_4   ({8'h00, from_fft_to_mem_data[7:0]}),
        .data_o_4   (),


        .addr_mem   (fft_memory_addr),
        .we_mem     (fft_memory_wr),
        .data_i_mem (to_fft_memory),
        .data_o_mem (from_fft_memory),

        .sel        (sel_fft_ram)
    );

    reg [7:0]   fft_mem_addr_wr_z;
    reg         fft_mem_wr_z;
    reg [15:0]  fft_mem_data_wr_z;

    always @(posedge ADC_DCLK) begin
        fft_mem_addr_wr_z <= fft_memory_addr;
        fft_mem_wr_z      <= fft_memory_wr;
        fft_mem_data_wr_z <= to_fft_memory;
    end

    ebr_dp fft_memory (
        .wr_clk_i    (ADC_DCLK), 
        .rd_clk_i    (ADC_DCLK), 
        .rst_i       (reset), 
        .wr_clk_en_i (1'b1), 
        .rd_en_i     (1'b1), 
        .rd_clk_en_i (1'b1), 
        .wr_en_i     (fft_mem_wr_z), 
        .wr_data_i   (fft_mem_data_wr_z), 
        .wr_addr_i   (fft_mem_addr_wr_z), 
        .rd_addr_i   (fft_memory_addr), 
        .rd_data_o   (from_fft_memory)
    );


    signal_filter signal_filter_int (
        .clk    (ADC_DCLK),
        .reset  (reset),

        .start  (fft_start),
        .work   (fft_work),
        .finish (fft_finish),

        .signal_addr    (fft_addr_rd),
        .signal_data    (from_signal_ram_to_fft),
        // .signal_data    (fft_addr_rd),

        .debug          (),
        .debug_we       (),
        .debug_addr     (),

        .fft_addr       (from_fft_to_mem_addr),
        .fft_data       (from_fft_to_mem_data),
        .fft_we         (from_fft_to_mem_wr)
    );

endmodule