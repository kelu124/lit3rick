//-------------------------------------------------------------------
// Testbench for dft_preproc module
//-------------------------------------------------------------------
module tb_dft_preproc();

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
localparam DUT_DATA_W = 12;

reg  signed [DUT_DATA_W-1:0] data_in;
reg                          valid_in;
wire signed [DUT_DATA_W-1:0] data_out;
wire                         valid_out;

dft_preproc
#(
    .DATA_W     (DUT_DATA_W)
)
dut
(
    // System
    .clk        (tb_clk),
    .rst        (tb_rst),
    // Input data
    .data_in    (data_in),
    .valid_in   (valid_in),
    // Output data
    .data_out   (data_out),
    .valid_out  (valid_out),
    .ready_out  (1'b1)
);

//-------------------------------------------------------------------
// Testbench body
//-------------------------------------------------------------------
integer err_cnt = 0;
reg signed [DUT_DATA_W:0] golden_result;

task set_rand_data_var1;
begin
    @(posedge tb_clk);
    data_in    = $random();
    golden_result = data_in;
    valid_in   = 1'b1;
    @(posedge tb_clk);
    valid_in   = 1'b0;
    @(posedge tb_clk);
    data_in    = $random();
    golden_result = golden_result + data_in;
    valid_in   = 1'b1;
    @(posedge tb_clk);
    valid_in   = 1'b0;
    golden_result = golden_result/2;
end
endtask

task set_rand_data_var2;
begin
    data_in    = $random();
    golden_result = data_in;
    valid_in   = 1'b1;
    @(posedge tb_clk);
    data_in    = $random();
    golden_result = golden_result + data_in;
    golden_result = golden_result/2;
end
endtask

task check_result;
begin
    if (golden_result != data_out) begin
        err_cnt = err_cnt + 1;
        $display("Error! expected %0d, got %0d!", golden_result, data_out);
    end
end
endtask

// Main test
initial begin : tb_main
    integer i;
    wait(!tb_rst);
    #20;

    set_rand_data_var1();
    wait(valid_out);
    check_result();
    set_rand_data_var1();
    wait(valid_out);
    check_result();

    @(posedge tb_clk);
    set_rand_data_var2();
    @(posedge tb_clk); #1;
    check_result();
    set_rand_data_var2();
    @(posedge tb_clk); #1;
    check_result();
    set_rand_data_var2();
    @(posedge tb_clk); #1;
    check_result();
    valid_in   = 1'b0;

    if (err_cnt)
        $error("Test failed with %d errors!", err_cnt);
    else
        $display("Test passed!");
    #20;
    $stop;
end

endmodule