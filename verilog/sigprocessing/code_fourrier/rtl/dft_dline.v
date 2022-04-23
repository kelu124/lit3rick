//==============================================================================
// DFT Delay Line
//
// DIN -> FF -> FF -> FF -> DOUT
//       |______________|
//           STAGES_N
//
//=============================================================================
module dft_dline
#(
    parameter STAGES_N = 1,  // 0 ... inf
    parameter DATA_W   = 1
)
(
    input  wire clk, // System clock
    input  wire rst, // System reset
    input  wire [DATA_W-1:0] din, // Delay line input
    output wire [DATA_W-1:0] dout // Delay line output
);

generate
begin: dline_genblk
    if (STAGES_N == 0) begin : dline_0_genblk

        assign dout = din;

    end else if (STAGES_N == 1) begin : dline_1_genblk

        reg [STAGES_N*DATA_W-1:0] dline;

        always @(posedge clk or posedge rst)
        begin
            if (rst)
                dline <= 0;
            else
                dline <= din;
        end

        assign dout = dline;

    end else begin : dline_n_genblk

        reg [STAGES_N*DATA_W-1:0] dline;

        always @(posedge clk or posedge rst)
        begin
            if (rst)
                dline <= 0;
            else
                dline <= {dline[(STAGES_N-1)*DATA_W-1:0], din};
        end

        assign dout = dline[STAGES_N*DATA_W-1:(STAGES_N-1)*DATA_W];
    end
end
endgenerate

endmodule
