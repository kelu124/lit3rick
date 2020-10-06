//==============================================================================
// DFT Square Sum module
//
// result = data.re^2 + data.im^2
// width(result) = width(data.re) * 2
// delay = MUL_OUT_REG(=1) + SUM_PIPELINE_STAGES + SUM_OUT_REG(=1)
//
//=============================================================================
module dft_sqrsum
#(
    parameter DATA_W              = 16,
    parameter SUM_PIPELINE_STAGES = 2
)
(
    // System
    input wire                  clk,  // System clock
    input wire                  rst,  // System reset
    // Input data
    input  wire signed [DATA_W-1:0]    data_re, // Data real part
    input  wire signed [DATA_W-1:0]    data_im, // Data imaginary part
    // Output data
    output wire [DATA_W*2-1:0]  result  // Result
);

wire [DATA_W*2-1:0] sqr_re;
wire [DATA_W*2-1:0] sqr_im;

dft_mul
#(
    .DATA_A_W      (DATA_W),
    .DATA_B_W      (DATA_W),
    .DATA_A_SIGNED ("on"),     // "on" / "off"
    .DATA_B_SIGNED ("on"),     // "on" / "off"
    .INPUT_REG     ("on"),    // "on" / "off"
    .OUTPUT_REG    ("on")      // "on" / "off"
) mul_re (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a (data_re),  // Data A
    .data_b (data_re),  // Data B
    // Output data
    .result (sqr_re)    // Result
);

dft_mul
#(
    .DATA_A_W      (DATA_W),
    .DATA_B_W      (DATA_W),
    .DATA_A_SIGNED ("on"),     // "on" / "off"
    .DATA_B_SIGNED ("on"),     // "on" / "off"
    .INPUT_REG     ("on"),    // "on" / "off"
    .OUTPUT_REG    ("on")      // "on" / "off"
) mul_im (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a (data_im),  // Data A
    .data_b (data_im),  // Data B
    // Output data
    .result (sqr_im)    // Result
);


dft_add
#(
    .DATA_W          (DATA_W*2),
    .DATA_SIGNED     ("off"),  // "on" / "off"
    .INPUT_REG       ("off"),  // "on" / "off"
    .OUTPUT_REG      ("on"),   // "on" / "off"
    .PIPELINE_STAGES (SUM_PIPELINE_STAGES)
) add (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a (sqr_re),   // Data A
    .data_b (sqr_im),   // Data B
    // Output data
    .result (result)    // Result
);

endmodule