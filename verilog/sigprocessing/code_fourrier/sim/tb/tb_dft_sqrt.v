//-------------------------------------------------------------------
// Testbench for dft_sqrt module
//-------------------------------------------------------------------
module tb_dft_sqrt();

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
localparam DUT_DATA_IN_W  = 32;
localparam DUT_DATA_OUT_W = DUT_DATA_IN_W/2;

reg  [DUT_DATA_IN_W-1:0] data;
reg                      valid;

wire [DUT_DATA_OUT_W-1:0] result;
wire                      done;

dft_sqrt
#(
    .DATA_W     (DUT_DATA_IN_W)
)
dut
(
    // System
    .clk    (tb_clk),   // System clock
    .rst    (tb_rst),   // System reset
    // Input data
    .data   (data),     // Data input
    .valid  (valid),    // Data valid
    // Output data
    .result (result),   // Result
    .done   (done)      // Calculations were done
);

//-------------------------------------------------------------------
// Testbench body
//-------------------------------------------------------------------
integer err_cnt = 0;
localparam DATA_N = 256;
// Test memory array
reg [DUT_DATA_IN_W-1:0]  test_mem_in    [DATA_N-1:0];
reg [DUT_DATA_OUT_W-1:0] test_mem_out   [DATA_N-1:0];
reg [DUT_DATA_OUT_W-1:0] golden_mem_out [DATA_N-1:0];

initial
begin
    $readmemh("../tb/tb_dft_sqrt_in.mem",  test_mem_in);
    $readmemh("../tb/tb_dft_sqrt_out.mem", golden_mem_out);
end

task send_data;
begin : task_send_data
    integer i;
    for (i=0; i<DATA_N; i=i+1) begin
        @(posedge tb_clk);
        data    = test_mem_in[i];
        valid   = 1'b1;
        @(posedge tb_clk);
        valid   = 1'b0;
        wait(done);
    end
end
endtask

task get_result();
begin : task_get_result
    integer i;
    for (i=0; i<DATA_N; i=i+1) begin
        @(posedge done);
        @(posedge tb_clk);
        test_mem_out[i] = result;
    end
end
endtask

task check();
begin : task_check
    integer i;
    for (i = 0; i < DATA_N; i = i + 1) begin
        if (test_mem_out[i] != golden_mem_out[i]) begin
                err_cnt = err_cnt + 1;
                $display("Error! Addr=%d, expected 0x%04x, got 0x%04x!", i, golden_mem_out[i], test_mem_out[i]);
        end
    end
end
endtask

// Main test
initial begin : tb_main
    integer i;

    wait(!tb_rst);
    #20;

    fork
        send_data();
        get_result();
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