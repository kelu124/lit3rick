//-------------------------------------------------------------------
// Testbench for dft_sqrsum module
//-------------------------------------------------------------------
module tb_dft_sqrsum();

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
localparam DUT_DATA_IN_W  = 16;
localparam DUT_SUM_PIPELINE_STAGES = 2;
localparam DUT_DATA_OUT_W = DUT_DATA_IN_W * 2;

reg signed [DUT_DATA_IN_W-1:0] data_re = 0;
reg signed [DUT_DATA_IN_W-1:0] data_im = 0;

wire [DUT_DATA_OUT_W-1:0] result;

dft_sqrsum
#(
    .DATA_W              (DUT_DATA_IN_W),
    .SUM_PIPELINE_STAGES (DUT_SUM_PIPELINE_STAGES)
) dut (
    // System
    .clk (tb_clk),     // System clock
    .rst (tb_rst),   // MAC clear
    // Input data
    .data_re (data_re),    // Data real part
    .data_im (data_im),    // Data imaginary part
    // Output data
    .result (result) // Result
);


reg  valid_in = 0;
wire valid_out;

dft_dline
#(
    .STAGES_N (DUT_SUM_PIPELINE_STAGES + 2)
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
reg [DUT_DATA_IN_W-1:0] test_mem_re_in [DATA_N-1:0];
reg [DUT_DATA_IN_W-1:0] test_mem_im_in [DATA_N-1:0];
reg [DUT_DATA_OUT_W-1:0] test_mem_out   [DATA_N-1:0];
reg [DUT_DATA_OUT_W-1:0] golden_mem_out [DATA_N-1:0];

initial
begin : test_mem_init
    integer i;
    reg [DUT_DATA_OUT_W-1:0] temp1;
    reg [DUT_DATA_OUT_W-1:0] temp2;
    for (i=0; i<DATA_N; i=i+1) begin
        test_mem_re_in[i] = $random();
        test_mem_im_in[i] = $random();
    end
    for (i=0; i<DATA_N; i=i+1) begin
        temp1 = $signed(test_mem_re_in[i])*$signed(test_mem_re_in[i]);
        temp2 = $signed(test_mem_im_in[i])*$signed(test_mem_im_in[i]);
        golden_mem_out[i] = temp1 + temp2;
    end
end

task send_data;
begin : task_send_data
    integer i;
    for (i=0; i<DATA_N; i=i+1) begin
        @(posedge tb_clk);
        data_re    = test_mem_re_in[i];
        data_im    = test_mem_im_in[i];
        valid_in   = 1'b1;
        @(posedge tb_clk);
        valid_in   = 1'b0;
    end
end
endtask

task recv_data();
begin : task_recv_data
    integer i;

    for (i=0; i<DATA_N; i=i+1) begin
        @(posedge valid_out);
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