//  Module: signal_filter
//
module signal_filter (
        input clk,
        input reset,

        input       start,
        output reg  work,
        output      finish,

        output [13 : 0] signal_addr,
        input  [15 : 0] signal_data,

        output [15 : 0] debug,
        output          debug_we,
        output reg [13:0] debug_addr = 0,

        output [7 : 0] fft_addr,
        output [15 : 0] fft_data,
        output          fft_we
    );

    localparam input_signal_length  = 8192;
    localparam output_signal_length = 256;

    wire         rden;
    reg          rden_z;
    reg          rden_zz;
    reg          rden_zzz;
    reg          start_z;
    reg          start_zz;
    reg          start_zzz;
    reg          start_zzzz;
    reg          start_zzzzz;
    reg          work_z;
    reg [13 : 0] in_data_cnt;
    reg [7 : 0] out_data_cnt;

    wire            fft_ready;
    wire            fifo_rd;
    reg             fifo_rd_z;
    wire            fifo_wr;
    wire            fifo_empty;
    wire            fifo_almfull;
    wire [15 : 0]   from_fifo;
    wire            to_fft_valid;

    wire [14 : 0]   from_fft;
    wire            from_fft_valid;
    
    reg [7:0] data_in_cnt;

    // assign finish = (out_data_cnt >= (output_signal_length - 1) && 
    assign finish = (out_data_cnt >= (output_signal_length - 1) && fft_we == 1 && 
                     in_data_cnt >= (input_signal_length - 1) && 
                     work == 1) ? 1 : 0;

    always @(posedge clk or posedge reset) begin
        if (reset == 1) begin
            work    <= 0;
            work_z  <= 0;
        end else begin
            work_z <= work;
            if (finish == 1) begin
                work <= 0;
            end else if (start == 1) begin
                work <= 1;
            end
        end
    end


    assign rden         = ~fifo_almfull && (in_data_cnt < input_signal_length) && work;
    assign signal_addr  = in_data_cnt;

    always @(posedge clk or posedge reset) begin
        if (reset == 1) begin
            rden_z      <= 0;
            rden_zz     <= 0;
            rden_zzz    <= 0;
            in_data_cnt <= 0;
            fifo_rd_z   <= 0;
        end else begin
            rden_zzz    <= rden_zz;
            rden_zz     <= rden_z;
            rden_z      <= rden;
            fifo_rd_z   <= fifo_rd;

            if (start == 1 && work == 0) begin
                in_data_cnt <= 0;
            end else if (rden == 1) begin
                in_data_cnt <= in_data_cnt + 1;
            end
        end
    end


    reg [7:0]  fft_addr_d;
    reg        fft_wr_d;
    reg [15:0] fft_data_d;


    assign fft_addr = out_data_cnt;
    // assign fft_data = from_fft;
    // assign fft_we   = from_fft_valid;
    // assign fft_addr = fft_addr_d;
    // assign fft_data = fft_data_d;
    // assign fft_we   = fft_wr_d;

    always @(posedge clk) begin
        fft_addr_d <= out_data_cnt;
        fft_wr_d   <= from_fft_valid;
        fft_data_d <= from_fft;
    end

    // fft_data <= from_fft;
    // fft_we <= from_fft_valid;
    always @(posedge clk) begin
        if (start == 1 && work == 0) begin
            out_data_cnt <= 0;
            // fft_we <= 0;
        end else begin
            if (fft_we == 1) begin
                out_data_cnt <= out_data_cnt + 1;
            end
        end
    end

    always @(posedge clk) begin
        start_zzzz <= start_zzz;
        start_zzz <= start_zz;
        start_zz <= start_z;
        start_z <= start;
    end

    wire dataval;

    assign dataval = (data_in_cnt < 63) ? 1'b1 : 1'b0;
    // assign fifo_rd = ~fifo_empty && fft_ready;
    // assign fifo_rd = ~fifo_empty && fft_ready && dataval && in_data_cnt > 10;
    assign fifo_rd = ~fifo_empty && fft_ready && dataval && ~start_zzzz;
    // assign fifo_wr = rden_zzz;
    assign fifo_wr = rden_zz;
    // assign fifo_wr = rden;

    always @(posedge clk) begin
        if (work == 0) begin
            data_in_cnt <= 0;
        end else if (to_fft_valid == 1 && fft_ready == 1 && from_fft_valid == 0) begin
            data_in_cnt <= data_in_cnt + 1;
        end else if (to_fft_valid == 1 && fft_ready == 1 && from_fft_valid == 1) begin
            data_in_cnt <= data_in_cnt - 31;
        end else if (from_fft_valid == 1) begin
            data_in_cnt <= data_in_cnt - 32;
        end
    end

    sc_fifo sc_fifo_inst (
        .clk_i         (clk), 
        .rst_i         (reset), 
        .wr_en_i       (fifo_wr), 
        .rd_en_i       (fifo_rd), 
        .wr_data_i     (signal_data), 
        .full_o        (), 
        .empty_o       (fifo_empty), 
        .almost_full_o (fifo_almfull), 
        .rd_data_o     (from_fifo)
    );

    assign to_fft_valid = fifo_rd_z;
    // assign to_fft_valid = fifo_rd;
    `define FFT
    `ifdef FFT
        dft #(
            .DATA_W(12) // Data input width
        ) dft_inst (
            // System
            .clk (clk),        // System clock
            .rst (reset),           // System reset
            // Input data from ADC
            .data_in     (from_fifo),      // Data input
            .valid_in    (to_fft_valid),   // Data input is valid
            .frame_start (start && !work),
            .ready       (fft_ready),      // DFT is ready to receive more data
            // Output data
            .data_out    (from_fft),   // Data output
            .valid_out   (from_fft_valid)   // Output data is valid
        );
    `endif
    
    alaw_coder #(
        .DATA_IN_W  (15), // Data input width
        .DATA_OUT_W (8)   // Data output width
    ) alaw_coder (
        // System
        .clk    (clk),        // System clock
        .rst    (reset),      // System reset
        // Input data
        .data_in    (from_fft),         // Data input
        .valid_in   (from_fft_valid),   // Data input is valid
        // Output data
        .data_out   (fft_data),   // Data output
        .valid_out  (fft_we)      // Output data is valid
    );
    
endmodule
