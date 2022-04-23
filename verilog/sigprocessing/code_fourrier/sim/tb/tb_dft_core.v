//-------------------------------------------------------------------
// Testbench for dft_core module
//-------------------------------------------------------------------
module tb_dft_core();

//-------------------------------------------------------------------
// Clock and reset
//-------------------------------------------------------------------
reg tb_clk = 0;
always
begin
    #7.692;
    tb_clk <= ~tb_clk; // 65 MHz
end
reg tb_rst = 1;
initial
begin
    #15;
    tb_rst = 0;
end

//-------------------------------------------------------------------
// DUT
//-------------------------------------------------------------------
localparam DUT_DFT_N  = 16;
localparam DUT_DATA_IN_W = 12;
localparam DUT_DATA_OUT_W = 16;

localparam FIFO_ADDR_W = 8;
localparam FIFO_DATA_W = DUT_DATA_IN_W;

reg  [FIFO_DATA_W-1:0] wdata = 0;
reg                    wr = 0;
wire                   full;
wire [FIFO_DATA_W-1:0] rdata;
wire                   rd;
wire                   empty;

wire signed [DUT_DATA_OUT_W-1:0] data_re_out;
wire signed [DUT_DATA_OUT_W-1:0] data_im_out;
wire                             data_valid;

dft_fifo
#(
    .ADDR_W (FIFO_ADDR_W),  // Memory depth
    .DATA_W (FIFO_DATA_W)   // Data width
)
fifo
(
    // System
    .clk    (tb_clk),   // System clock
    .rst    (tb_rst),   // System reset
    // Write interface
    .wdata  (wdata),    // Write data
    .wr     (wr),       // Write operation
    .full   (full),     // FIFO is full
    // Read interface
    .rdata  (rdata),    // Read data
    .rd     (rd),       // Read operation
    .empty  (empty)     // FIFO is empty
);

dft_core
#(
    .DATA_IN_W  (DUT_DATA_IN_W),    // Data input width
    .DATA_OUT_W (DUT_DATA_OUT_W),   // Data output width
    .DFT_N      (DUT_DFT_N)         // Number of points in DFT window
)
dut
(
    // System
    .clk            (tb_clk),   // System clock
    .rst            (tb_rst),   // System reset
    // Input data from FIFO
    .fifo_rdata     (rdata),    // FIFO data
    .fifo_rd        (rd),       // FIFO data read
    .fifo_empty     (empty),    // FIFO is empty
    // Output data
    .data_re_out    (data_re_out),  // Data real part output
    .data_im_out    (data_im_out),  // Data imaginary part output
    .valid_out      (valid_out)     // Output data is valid
);

//-------------------------------------------------------------------
// Testbench body
//------------------------------------------------------------------
localparam DATA_CHUNKS_N = 256;
localparam DATA_IN_N  = 16*DATA_CHUNKS_N;
localparam DATA_OUT_N = 3*DATA_CHUNKS_N;
integer err_cnt = 0;
// Test memory array
reg [DUT_DATA_IN_W-1:0] test_mem_in  [DATA_IN_N-1:0];
reg [DUT_DATA_OUT_W-1:0] test_mem_re_out [DATA_OUT_N-1:0];
reg [DUT_DATA_OUT_W-1:0] test_mem_im_out [DATA_OUT_N-1:0];
reg [DUT_DATA_OUT_W-1:0] golden_mem_re_out [DATA_OUT_N-1:0];
reg [DUT_DATA_OUT_W-1:0] golden_mem_im_out [DATA_OUT_N-1:0];

initial
begin
    $readmemh("../tb/tb_dft_core_in.mem", test_mem_in);
    $readmemh("../tb/tb_dft_core_out_re.mem", golden_mem_re_out);
    $readmemh("../tb/tb_dft_core_out_im.mem", golden_mem_im_out);
end

task fifo_write();
begin : task_fifo_write
    integer i;
    for (i = 0; i < DATA_IN_N; i = i + 1) begin
        @(posedge tb_clk);
        if (full) begin
            wait(!full);
            @(posedge tb_clk);
        end
        wdata = test_mem_in[i];
        wr = 1'b1;
        @(posedge tb_clk);
        wr = 1'b0;
    end
end
endtask

task result_read();
begin : task_result_read
    integer i;
    for (i = 0; i < DATA_OUT_N/3; i = i + 1) begin
        wait(valid_out);
        #10;
        @(posedge tb_clk);
        test_mem_re_out[i*3 + 0] = data_re_out;
        test_mem_im_out[i*3 + 0] = data_im_out;
        @(posedge tb_clk);
        test_mem_re_out[i*3 + 1] = data_re_out;
        test_mem_im_out[i*3 + 1] = data_im_out;
        @(posedge tb_clk);
        test_mem_re_out[i*3 + 2] = data_re_out;
        test_mem_im_out[i*3 + 2] = data_im_out;
        @(posedge tb_clk);
    end
end
endtask

task check();
begin : task_check
    integer i;
    for (i = 0; i < DATA_OUT_N; i = i + 1) begin
        if (test_mem_re_out[i] != golden_mem_re_out[i]) begin
                err_cnt = err_cnt + 1;
                $display("Error! Memory RE: Addr=%d, expected 0x%04x, got 0x%04x!", i, golden_mem_re_out[i], test_mem_re_out[i]);
        end
        if (test_mem_im_out[i] != golden_mem_im_out[i]) begin
                err_cnt = err_cnt + 1;
                $display("Error! Memory IM: Addr=%d, expected 0x%04x, got 0x%04x!", i, golden_mem_im_out[i], test_mem_im_out[i]);
        end
    end
end
endtask

// Main test
initial begin : tb_main
    wait(!tb_rst);
    #20;

    fork
        fifo_write();
        result_read();
    join
    check();

    #1000;

    if (err_cnt)
        $error("Test failed with %d errors!", err_cnt);
    else
        $display("Test passed!");
    #20;
    $stop;
end

endmodule