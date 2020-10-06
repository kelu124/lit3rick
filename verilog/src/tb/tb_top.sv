`timescale 1ns/1ps
`define FFT

module tb_top;

    localparam signal_mem_base = 16'h8000;
    localparam fft_mem_base = 16'h0000;
    localparam registers_base = 16'h0000;

    int err = 0;

    logic i2c_clk;
    logic i2s_clk;
    logic i2s_lrclk = 0;

    wire i2c_rpi_sda;
    wire i2c_rpi_scl;
    
    reg spi_strb = 0;
    reg [7:0] spi_data;

    i2c i2c_rpi();
    assign i2c_rpi.ref_clk = i2c_clk;

    mi_if mi();
    ad9629_if ad9629();
    mcp_spi_if mcp_if();

    assign (pull1,pull0) i2c_rpi.sda = 1'b1;
    assign (pull1,pull0) i2c_rpi.scl = 1'b1;
    assign i2c_rpi.axi_clk = ad9629.ADC_DCLK;
    // assign DUT.clk = ad9629.ADC_DCLK;
    assign DUT.m_axil_awaddr  = i2c_rpi.awaddr;
    assign DUT.m_axil_awvalid = i2c_rpi.awvalid;
    assign DUT.m_axil_wdata   = i2c_rpi.wdata;
    assign DUT.m_axil_wvalid  = i2c_rpi.wvalid;
    assign DUT.m_axil_araddr  = i2c_rpi.araddr;
    assign DUT.m_axil_arvalid = i2c_rpi.arvalid;
    assign DUT.m_axil_rready  = i2c_rpi.rready;
    assign DUT.spi_strb       = spi_strb;
    assign DUT.from_spi       = spi_data;
    assign i2c_rpi.awready  = DUT.m_axil_awready;
    assign i2c_rpi.wready   = DUT.m_axil_wready;
    assign i2c_rpi.arready  = DUT.m_axil_arready;
    assign i2c_rpi.rdata    = DUT.m_axil_rdata;
    assign i2c_rpi.rvalid   = DUT.m_axil_rvalid;

    top DUT(
        .clk   (mi.clk),

        // .top_turn2(mi.top_turn2),
        .BUT_USER(mi.BUT_USER),
        .BUT_TRIG(mi.BUT_TRIG),

        .ADC_REF_CLK(ad9629.ADC_REF_CLK),
        .ADC_DCLK   (ad9629.ADC_DCLK),
        .ADC_D      (ad9629.ADC_D),


        .i2c_sda (i2c_rpi.sda),
        .i2c_scl (i2c_rpi.scl),

        .i2s_clk    (i2s_clk),
        .i2s_lrclk  (i2s_lrclk),

        .CSn(mcp_if.cs),
        .SCK(mcp_if.sck),
        .SDI(mcp_if.sdi)
    );

    // initial
    // begin
    //     $dumpfile("./output/out.vcd");
    //     $dumpvars(0,tb_top);
    // end

    initial begin : test_stimulus
        mi.reset = 0;
        mi.clk = 0;
        i2c_clk = 0;
        i2s_clk = 0;
        ad9629.ADC_DCLK = 0;
        $display("Init");

        #10;
        @(posedge mi.clk);
        mi.reset = 1;
        @(posedge mi.clk);
        mi.reset = 0;
        $display("Finish reset");

        #5us;
        // test_registers();
        // test_dac();
        test_adc();
        // #1ms;
        test_i2s();
        // test_fft();
        // test_fft();
        // test_fft();
        // test_adc();

        if (err == 0) begin
            $display("Tests finished successfully!");
        end else begin
            $error("Tests failed!");
        end

        #100000000;
        $display("End testbench");
        $stop;
    end

    initial begin
        forever begin
            repeat(8) @(posedge i2s_clk);
            i2s_lrclk <= ~i2s_lrclk;
        end
    end

    initial begin : ADC_imit
        bit [11:0] data [];

        data = new[8192];
        for (int i = 0; i < data.size; i += 1) begin
            data[i] = i;
        end

        forever begin
            @(posedge DUT.top_turn2_filter);
            ad9629.send_data(data);
        end
    end

    always #7.692ns mi.clk = ~mi.clk;
    always #1000ns i2c_clk = ~i2c_clk;
    always #325.52ns i2s_clk = ~i2s_clk;
    // always #7.692ns ad9629.ADC_DCLK = ~ad9629.ADC_DCLK;
    always #5ns ad9629.ADC_DCLK = ~ad9629.ADC_DCLK;


    task test_fft();
        int i;
        bit [31:0] tmp;

        $display("%0tps >>>> Start FFT test!", $time);

        i2c_rpi.write(8, 2 << 8);

        for(i = 0; i < 8192; i += 1) begin
            i2c_rpi.write(i << 2 | 16'h8000, {i[7:0], i[15:8], 16'h0});
        end

        i2c_rpi.write(8, 4 << 16 | 4 << 8 | 1);
        #1000000;

        @(posedge ad9629.ADC_DCLK);
        // for(i = 0; i < 256; i += 1) begin
        //     repeat(16) @(posedge ad9629.ADC_DCLK);
        //     spi_strb = 1;
        //     spi_data = i[15:8];
        //     @(posedge ad9629.ADC_DCLK);
        //     spi_strb = 0;
        //     repeat(16) @(posedge ad9629.ADC_DCLK);
        //     spi_strb = 1;
        //     spi_data = i[7:0];
        //     @(posedge ad9629.ADC_DCLK);
        //     spi_strb = 0;
        // end
        // @(posedge DUT.fft_finish);
        @(posedge ad9629.ADC_DCLK);
        @(posedge ad9629.ADC_DCLK);

        tmp = 1;
        while (tmp & 1 != 0) begin
            repeat(1000) @(posedge ad9629.ADC_DCLK);
            i2c_rpi.read(12, tmp);
        end
        i2c_rpi.write(8, 2 << 16);
        // i2c_rpi.write(8, 2 << 8);
        for (i = 0; i < 256; i += 1) begin
            i2c_rpi.read(i << 2 | 16'h8000, tmp);
            $display("Readed value = %0h", tmp);
        end

        if (err == 0) begin
            $display(">>>> FFT test - [OK]");
        end

    endtask

    task test_registers();
        int i;
        bit [31 : 0] testdata [32];
        bit [31 : 0] readeddata [32];
        int num_checking_regs;

        num_checking_regs = 4;

        $display(">>>> Start Registers test!");

        for (i = 0; i < num_checking_regs; i += 1) begin
            testdata[i] = $random();
        end
        repeat(10) @(posedge i2c_clk);
        for (i = 3; i < num_checking_regs; i += 1) begin
            i2c_rpi.write(registers_base + i * 4, testdata[i]);
            repeat(5) @(posedge i2c_clk);
        end
        // repeat(100) @(posedge i2c_clk);
        for (i = 3; i < num_checking_regs; i += 1) begin
            i2c_rpi.read(registers_base + i * 4, readeddata[i]);
            i2c_rpi.write(registers_base + i * 4, readeddata[i]);
            repeat(5) @(posedge i2c_clk);
        end
        for (i = 3; i < num_checking_regs; i += 1) begin
            if (testdata[i] != readeddata[i]) begin
                $error("Incorrect value readed from register #%0d. Expected : %0h | readed : %0h", i, testdata[i], readeddata[i]);
                err = 1;
            end
        end

        if (err == 0) begin
            $display(">>>> Registers test - [OK]");
        end

    endtask

    task test_adc();
        int i;
        int test_adc_seq;
        bit [11 : 0] adc_data[];
        bit [11 : 0] readed_signal[];
        bit [31 : 0] tmp;

        test_adc_seq = 8192;

        // @(negedge mi.reset);
        #1000ns;

        adc_data = new[test_adc_seq];
        readed_signal = new[test_adc_seq];
        for (i = 0; i < test_adc_seq; i += 1) begin
            adc_data[i] = $random();
        end
        // mi.BUT_TRIG = 1;
        #1020ns
        // mi.BUT_TRIG = 0;
        i2c_rpi.write(8, 8);
        fork 
            ad9629.send_data(adc_data);
            begin
                #100ns;
                mi.top_turn2 = 0;
            end
        join

        #500us;
        mi.BUT_USER = 1;
        #10us
        mi.BUT_USER = 0;

        i2c_rpi.write(8, 0);

        // i2c_rpi.write_rpi(7'h25, signal_mem_base + i * 4, tmp);
        // for (i = 0; i < test_adc_seq; i += 1) begin
        //     i2c_rpi.read_rpi(7'h25, signal_mem_base + i * 4, tmp);
        //     i2c_rpi.write_rpi(7'h25, signal_mem_base + i * 4, tmp);
        //     readed_signal[i] = tmp[11:0];
        //     repeat(10) @(posedge i2c_clk);
        // end

        // for (i = 0; i < test_adc_seq; i += 1) begin
        //     // if (adc_data[i] != readed_signal[i] && err == 0) begin
        //     if (adc_data[i] != readed_signal[i]) begin
        //         $error("Readed incorrect signal point! Expected: %0h | readed: %0h", adc_data[i], readed_signal[i]);
        //         err = 1;
        //     end
        // end
    endtask
    
    task test_i2s();
        int i;
        int test_adc_seq;
        bit [11 : 0] adc_data[];
        bit [11 : 0] readed_signal[];
        bit [31 : 0] tmp;

        $display(">>>> Start I2S test!");

        test_adc_seq = 8192;

        // @(negedge mi.reset);
        #100000ns;

        // write data into the DAC ram
        for (int i = 0; i < 16; i += 1) begin
            i2c_rpi.write(6 << 2, i << 16 | i);
        end

        i2c_rpi.write(8 << 2, 15);  // pdelay
        i2c_rpi.write(9 << 2, 25);  // PHV_time
        i2c_rpi.write(10 << 2, 33); // PnHV_time
        i2c_rpi.write(11 << 2, 12); // PDamp_time

        // Enable access to signal ram through i2c
        // i2c_rpi.write(8, 0 << 8 | 1 << 4);
        i2c_rpi.write(8, 4 << 16 | 4 << 8 | 1);
        # 1us;
        i2c_rpi.write(8, 4 << 16 | 4 << 8 | 0);
        #10ms;
        i2c_rpi.read(12, tmp);
        $display("readed status: %0h", tmp);
        // $display("start i2s autorestart mode at time %0tps", $time);

        // for(i = 0; i < 8192; i += 1) begin
        //     i2c_rpi.write(i << 2 | 16'h8000, i);
        // end

        #4ms;

        // Enable access to signal ram through i2s
        i2c_rpi.write(8, 1 << 8);


        if (err == 0) begin
            $display(">>>> I2S test - [OK]");
        end
    endtask

    task test_dac();
        int i;
        int test_dac_seq;
        bit [31 : 0] data;
        bit [15 : 0] dac_data;

        $display(">>>> Start DAC test!");

        test_dac_seq = 5;

        for (i = 0; i < test_dac_seq; i+= 1) begin
            data = $random() & 16'hFFFF;
            fork
                i2c_rpi.write(registers_base + 16'h0010, data);
                // i2c_rpi.write(registers_base + 16'h0010, {data[7:0], data[15:8], data[23:16], data[31:24]});
                mcp_if.receive(dac_data);
            join
            if (dac_data != data[15 : 0]) begin
                $error("Incorrect mcp4812 value. Expected: %0h | received: %0h", data[15:0], dac_data);
                err = 1;
            end
            repeat(200) @(posedge mi.clk);
        end

        if (err == 0) begin
            $display(">>>> DAC test - [OK]");
        end
    endtask

endmodule