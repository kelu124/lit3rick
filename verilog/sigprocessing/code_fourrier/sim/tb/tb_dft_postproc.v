//-------------------------------------------------------------------
// Testbench for dft_postroc module
//-------------------------------------------------------------------
module tb_dft_postproc();

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

reg  signed [DUT_DATA_W-1:0] data_re_in = 0;
reg  signed [DUT_DATA_W-1:0] data_im_in = 0;
reg                          valid_in = 0;
wire        [DUT_DATA_W-2:0] data_out;
wire                         valid_out;

dft_postproc
#(
    .DATA_W (DUT_DATA_W) // Data width
)
dut
(
    // System
    .clk        (tb_clk),
    .rst        (tb_rst),
    // Input data
    .data_re_in (data_re_in),  // Data real part
    .data_im_in (data_im_in),  // Data imaginary part
    .valid_in   (valid_in),    // Data input valid
    // Output data
    .data_out   (data_out),    // Data output
    .valid_out  (valid_out)    // Data output is valid
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
reg [DUT_DATA_W-2:0] test_mem_out   [DATA_N-1:0];
reg [DUT_DATA_W-2:0] golden_mem_out [DATA_N-1:0];

initial
begin
    $readmemh("../tb/tb_dft_postproc_in_re.mem", test_mem_re_in);
    $readmemh("../tb/tb_dft_postproc_in_im.mem", test_mem_im_in);
    $readmemh("../tb/tb_dft_postproc_out.mem",   golden_mem_out);
end


task send_data;
begin : task_send_data
    integer i, j;
    for (i=0; i<DATA_N/BATCH_N; i=i+1) begin
        for (j=0; j<BATCH_N; j=j+1) begin
            @(posedge tb_clk);
            data_re_in    = test_mem_re_in[i*BATCH_N + j];
            data_im_in    = test_mem_im_in[i*BATCH_N + j];
            valid_in      = 1'b1;
        end
        @(posedge tb_clk);
        valid_in      = 1'b0;
        repeat(109) @(posedge tb_clk);
    end
end
endtask

task get_result();
begin : task_get_result
    integer i;
    for (i=0; i<DATA_N/BATCH_N; i=i+1) begin
        @(posedge valid_out);
        @(posedge tb_clk);
        test_mem_out[i] = data_out;
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