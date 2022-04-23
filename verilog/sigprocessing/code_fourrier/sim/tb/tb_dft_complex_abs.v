//-------------------------------------------------------------------
// Testbench for dft_complex_abs module
//-------------------------------------------------------------------
module tb_dft_complex_abs();

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
localparam DUT_DATA_W = 16;

reg signed [DUT_DATA_W-1:0] data_re = 0;
reg signed [DUT_DATA_W-1:0] data_im = 0;
reg                         valid = 0;

wire [DUT_DATA_W-1:0] result;
wire              done;

dft_complex_abs
#(
    .DATA_W (DUT_DATA_W)
)
dut
(
    // System
    .clk        (tb_clk),   // System clock
    .rst        (tb_rst),   // System reset
    // Input data
    .data_re    (data_re),  // Data real part
    .data_im    (data_im),  // Data imaginary part
    .valid      (valid),    // Data valid
    // Output data
    .result     (result),   // Result
    .done       (done)      // Calculations were done
);

//-------------------------------------------------------------------
// Testbench body
//-------------------------------------------------------------------
integer err_cnt = 0;
localparam BATCH_N = 3;
localparam DATA_N = 256*BATCH_N;
// Test memory array
reg [DUT_DATA_W-1:0] test_mem_re_in [DATA_N-1:0];
reg [DUT_DATA_W-1:0] test_mem_im_in [DATA_N-1:0];
reg [DUT_DATA_W-1:0] test_mem_out   [DATA_N-1:0];
reg [DUT_DATA_W-1:0] golden_mem_out [DATA_N-1:0];

initial
begin
    $readmemh("../tb/tb_dft_complex_abs_in_re.mem", test_mem_re_in);
    $readmemh("../tb/tb_dft_complex_abs_in_im.mem", test_mem_im_in);
    $readmemh("../tb/tb_dft_complex_abs_out.mem", golden_mem_out);
end


task send_data;
begin : task_send_data
    integer i, j;
    for (i=0; i<DATA_N/BATCH_N; i=i+1) begin
        for (j=0; j<BATCH_N; j=j+1) begin
            @(posedge tb_clk);
            data_re    = test_mem_re_in[i*BATCH_N + j];
            data_im    = test_mem_im_in[i*BATCH_N + j];
            valid      = 1'b1;
        end
        @(posedge tb_clk);
        valid      = 1'b0;
        repeat(109) @(posedge tb_clk);
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