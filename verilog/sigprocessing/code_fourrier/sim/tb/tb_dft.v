//-------------------------------------------------------------------
// Testbench for dft module
//-------------------------------------------------------------------
module tb_dft();

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
localparam DUT_DATA_IN_W = 12;
localparam DUT_DATA_OUT_W = 15;

reg signed [DUT_DATA_IN_W-1:0]  data_in = 0;
reg                             valid_in = 0;
wire                            ready;
wire       [DUT_DATA_OUT_W-1:0] data_out;
wire                            valid_out;

dft
#(
    .DATA_W (DUT_DATA_IN_W) // Data input width
)
dut
(
    // System
    .clk       (tb_clk),        // System clock
    .rst       (tb_rst),        // System reset
    // Input data from ADC
    .data_in   (data_in),    // Data input
    .valid_in  (valid_in),   // Data input is valid
    .ready     (ready),      // DFT is ready to receive more data
    // Output data
    .data_out  (data_out),   // Data output
    .valid_out (valid_out)   // Output data is valid
);

//-------------------------------------------------------------------
// Testbench body
//------------------------------------------------------------------
localparam DATA_CHUNKS_N = 256;
localparam DATA_IN_N  = 32*DATA_CHUNKS_N;
localparam DATA_OUT_N = DATA_CHUNKS_N;
integer err_cnt = 0;
// Test memory array
reg [DUT_DATA_IN_W-1:0] test_mem_in  [DATA_IN_N-1:0];
reg [DUT_DATA_OUT_W-1:0] test_mem_out [DATA_CHUNKS_N-1:0];
reg [DUT_DATA_OUT_W-1:0] golden_mem_out [DATA_CHUNKS_N-1:0];

initial
begin
    $readmemh("../tb/tb_dft_in.mem", test_mem_in);
    $readmemh("../tb/tb_dft_out.mem", golden_mem_out);
end

task send_data();
begin : task_send_data
    integer i;
    for (i = 0; i < DATA_IN_N; i = i + 1) begin
        @(posedge tb_clk);
        if (!ready) begin
            //valid_in = 1'b0;
            wait(ready);
            @(posedge tb_clk);
        end
        #0;
        data_in = test_mem_in[i];
        valid_in = 1'b1;
    end
    @(posedge tb_clk);
    #0;
    valid_in = 1'b0;
end
endtask

task result_read();
begin : task_result_read
    integer i;
    for (i = 0; i < DATA_OUT_N; i = i + 1) begin
        @(posedge valid_out);
        @(posedge tb_clk);
        test_mem_out[i] = data_out;
    end
end
endtask

task check();
begin : task_check
    integer i;
    for (i = 0; i < DATA_OUT_N; i = i + 1) begin
        if (test_mem_out[i] != golden_mem_out[i]) begin
                err_cnt = err_cnt + 1;
                $display("Error! Addr=%d, expected 0x%04x, got 0x%04x!", i, golden_mem_out[i], test_mem_out[i]);
        end
    end
end
endtask

// Main test
initial begin : tb_main
    wait(!tb_rst);
    #20;

    fork
        send_data();
        result_read();
    join
    check();

    #1000;

    if (err_cnt)
        $error("Test failed with %d errors!", err_cnt);
    else
        $display("Test passed!");
    #20;
    `ifdef __ICARUS__
        $finish;
    `else
        $stop;
    `endif
end

`ifdef __ICARUS__
initial begin
    $dumpfile("work.vcd");
    $dumpvars(0, tb_dft);
end
`endif

endmodule