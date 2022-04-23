//-------------------------------------------------------------------
// Testbench for dft_fifo module
//-------------------------------------------------------------------
module tb_dft_fifo();

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
localparam DUT_ADDR_W = 8;
localparam DUT_DATA_W = 12;

reg  [DUT_DATA_W-1:0] wdata = 0;
reg                   wr = 0;
wire                  full;
wire [DUT_DATA_W-1:0] rdata;
reg                   rd = 0;
wire                  empty;

dft_fifo
#(
    .ADDR_W (DUT_ADDR_W),  // Memory depth
    .DATA_W (DUT_DATA_W)   // Data width
)
dut
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

//-------------------------------------------------------------------
// Testbench body
//------------------------------------------------------------------
integer err_cnt = 0;
// Test memory array
reg [DUT_DATA_W-1:0] test_mem_in  [2**DUT_ADDR_W-1:0];
reg [DUT_DATA_W-1:0] test_mem_out [2**DUT_ADDR_W-1:0];

initial
begin : test_mem_init
    integer i;
    for (i = 0; i < 2**DUT_ADDR_W; i = i + 1) begin
        test_mem_in[i] = $random();
    end
end

task fifo_write();
begin : task_fifo_write
    integer i;
    for (i = 0; i < 2**DUT_ADDR_W; i = i + 1) begin
        @(posedge tb_clk);
        wdata = test_mem_in[i];
        wr = 1'b1;
        @(posedge tb_clk);
        wr = 1'b0;
    end
end
endtask

task fifo_read();
begin : task_fifo_read
    integer i;
    wait(!empty);
    @(posedge tb_clk);
    for (i = 0; i < 2**DUT_ADDR_W; i = i + 1) begin
        @(posedge tb_clk);
        rd = 1'b1;
        @(posedge tb_clk);
        rd = 1'b0;
        @(posedge tb_clk);
        @(posedge tb_clk);
        @(posedge tb_clk);
        test_mem_out[i] = rdata;
    end
end
endtask

task check();
begin : task_check
    integer i;
    for (i = 0; i < 2**DUT_ADDR_W; i = i + 1) begin
        if (test_mem_out[i] != test_mem_in[i]) begin
                err_cnt = err_cnt + 1;
                $display("Error! Memory: Addr=%d, expected 0x%04x, got 0x%04x!", i, test_mem_in[i], test_mem_out[i]);
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
        fifo_read();
    join

    check();

    if (err_cnt)
        $error("Test failed with %d errors!", err_cnt);
    else
        $display("Test passed!");
    #20;
    $stop;
end

endmodule