//-------------------------------------------------------------------
// Testbench for dft_twiddle_rom module
//-------------------------------------------------------------------
module tb_dft_twiddle_rom();

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
localparam DUT_ADDR_W = 2;
localparam DUT_DATA_W = 16;
localparam DUT_MEM_FILE_RE = "../rtl/mem_files/dft_twiddle_re_16.mem";
localparam DUT_MEM_FILE_IM = "../rtl/mem_files/dft_twiddle_im_16.mem";

wire [DUT_DATA_W-1:0] rdata_re;
wire [DUT_DATA_W-1:0] rdata_im;
reg  [DUT_ADDR_W-1:0] raddr;
reg                   rd;

dft_twiddle_rom
#(
    .ADDR_W      (DUT_ADDR_W),
    .DATA_W      (DUT_DATA_W)
) dut (
    // System
    .clk (tb_clk),
    .rst (tb_rst),
    // Read interface
    .rdata_re (rdata_re),
    .rdata_im (rdata_im),
    .raddr    (raddr),
    .rd       (rd)
);

//-------------------------------------------------------------------
// Testbench body
//------------------------------------------------------------------
// Test memory array
reg [DUT_DATA_W-1:0] test_mem_re [2**DUT_ADDR_W-1:0];
reg [DUT_DATA_W-1:0] test_mem_im [2**DUT_ADDR_W-1:0];

// ROM init
initial begin
    $readmemh(DUT_MEM_FILE_RE, test_mem_re);
    $readmemh(DUT_MEM_FILE_IM, test_mem_im);
end

// Main test
integer err_cnt = 0;
initial begin : tb_main
    integer i;
    wait(!tb_rst);
    #20;

    @(posedge tb_clk);
    for (i = 0; i <= 2**DUT_ADDR_W; i=i+1) begin
        @(posedge tb_clk);
        raddr = i;
        rd = 1'b1;
        #1;
        if (i>0) begin
            if (rdata_re != test_mem_re[i-1]) begin
                err_cnt = err_cnt + 1;
                $display("Error! Memory RE: Addr=%d, expected 0x%04x, got 0x%04x!", i, test_mem_re[i-1], rdata_re);
            end
            if (rdata_im != test_mem_im[i-1]) begin
                err_cnt = err_cnt + 1;
                $display("Error! Memory IM: Addr=%d, expected 0x%04x, got 0x%04x!", i, test_mem_im[i-1], rdata_im);
            end
        end
    end
    rd = 1'b0;

    if (err_cnt)
        $error("Test failed with %d errors!", err_cnt);
    else
        $display("Test passed!");
    #20;
    $stop;
end

endmodule