//-------------------------------------------------------------------
// Testbench for dft_complex_mul module
//-------------------------------------------------------------------
module tb_dft_complex_mul();

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
localparam DUT_DATA_IN_W = 16;
localparam DUT_DATA_OUT_W = DUT_DATA_IN_W;
localparam DUT_PIPELINE_STAGES = 2;

reg signed [DUT_DATA_IN_W-1:0] data_a_re = 0;
reg signed [DUT_DATA_IN_W-1:0] data_a_im = 0;
reg signed [DUT_DATA_IN_W-1:0] data_b_re = 0;
reg signed [DUT_DATA_IN_W-1:0] data_b_im = 0;

wire signed [DUT_DATA_OUT_W-1:0] result_re;
wire signed [DUT_DATA_OUT_W-1:0] result_im;

dft_complex_mul
#(
    .DATA_A_W        (DUT_DATA_IN_W), // Data A width
    .DATA_B_W        (DUT_DATA_IN_W), // Data B width
    .PIPELINE_STAGES (DUT_PIPELINE_STAGES)
) dut (
    // System
    .clk (tb_clk),       // System clock
    .rst (tb_rst),       // System reset
    // Input data
    .data_a_re (data_a_re), // Data A real part
    .data_a_im (data_a_im), // Data A imaginary part
    .data_b_re (data_b_re), // Data B real part
    .data_b_im (data_b_im), // Data B imaginary part
    // Output data
    .result_re (result_re),  // Result real part
    .result_im (result_im)   // Result imaginary part
);

reg  valid_in = 0;
wire valid_out;

dft_dline
#(
    .STAGES_N (DUT_PIPELINE_STAGES + 3)
) dline (
    .clk    (tb_clk),
    .rst    (tb_rst),
    .din    (valid_in),
    .dout   (valid_out)
);

//-------------------------------------------------------------------
// Testbench body
//-------------------------------------------------------------------
integer err_cnt = 0;
localparam DATA_N = 64;
// Test memory array
reg [DUT_DATA_IN_W-1:0] test_mem_a_re_in [DATA_N-1:0];
reg [DUT_DATA_IN_W-1:0] test_mem_a_im_in [DATA_N-1:0];
reg [DUT_DATA_IN_W-1:0] test_mem_b_re_in [DATA_N-1:0];
reg [DUT_DATA_IN_W-1:0] test_mem_b_im_in [DATA_N-1:0];
reg [DUT_DATA_OUT_W-1:0] test_mem_re_out   [DATA_N-1:0];
reg [DUT_DATA_OUT_W-1:0] test_mem_im_out   [DATA_N-1:0];
reg [DUT_DATA_OUT_W-1:0] golden_mem_re_out [DATA_N-1:0];
reg [DUT_DATA_OUT_W-1:0] golden_mem_im_out [DATA_N-1:0];

initial
begin : test_mem_init
    integer i;
    reg signed [DUT_DATA_OUT_W*2-1:0] temp1;
    reg signed [DUT_DATA_OUT_W*2-1:0] temp2;
    reg signed [DUT_DATA_OUT_W*2-1:0] temp3;
    reg signed [DUT_DATA_OUT_W*2-1:0] temp4;
    for (i=0; i<DATA_N; i=i+1) begin
        test_mem_a_re_in[i] = $random();
        test_mem_a_im_in[i] = $random();
        test_mem_b_re_in[i] = $random();
        test_mem_b_im_in[i] = $random();
    end
    for (i=0; i<DATA_N; i=i+1) begin
        temp1 = $signed(test_mem_a_re_in[i])*$signed(test_mem_b_re_in[i]);
        temp2 = $signed(test_mem_a_im_in[i])*$signed(test_mem_b_im_in[i]);
        golden_mem_re_out[i] = (temp1 - temp2) >> 15;

        temp3 = $signed(test_mem_a_re_in[i])*$signed(test_mem_b_im_in[i]);
        temp4 = $signed(test_mem_a_im_in[i])*$signed(test_mem_b_re_in[i]);
        golden_mem_im_out[i] = (temp3 + temp4) >> 15;
    end
end
task send_data;
begin : task_send_data
    integer i;
    for (i=0; i<DATA_N; i=i+1) begin
        @(posedge tb_clk);
        data_a_re    = test_mem_a_re_in[i];
        data_a_im    = test_mem_a_im_in[i];
        data_b_re    = test_mem_b_re_in[i];
        data_b_im    = test_mem_b_im_in[i];
        valid_in   = 1'b1;
    end
end
endtask

task recv_data();
begin : task_recv_data
    integer i;

    @(posedge valid_out);
    for (i=0; i<DATA_N; i=i+1) begin
        @(posedge tb_clk);
        test_mem_re_out[i] = result_re;
        test_mem_im_out[i] = result_im;
    end
end
endtask

task check();
begin : task_check
    integer i;
    for (i = 0; i < DATA_N; i = i + 1) begin
        if (test_mem_re_out[i] != golden_mem_re_out[i]) begin
                err_cnt = err_cnt + 1;
                $display("Error! Addr=%d, expected 0x%04x, got 0x%04x!", i, golden_mem_re_out[i], test_mem_re_out[i]);
        end
        if (test_mem_im_out[i] != golden_mem_im_out[i]) begin
                err_cnt = err_cnt + 1;
                $display("Error! Addr=%d, expected 0x%04x, got 0x%04x!", i, golden_mem_im_out[i], test_mem_im_out[i]);
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
        recv_data();
    join

    check();

    #100;
    if (err_cnt)
        $error("Test failed with %d errors!", err_cnt);
    else
        $display("Test passed!");
    #20;
    $stop;
end

endmodule