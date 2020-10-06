//==============================================================================
// DFT Complex Multiplier
//
// result.re = ((data_a.re * data_b.re) - (data_a.im * data_b.im)) / 32768
// result.im = ((data_a.re * data_b.im) + (data_a.im * data_b.re)) / 32768
// width(result.re) = width(data_a.re+data_b.re+1)
// delay = MUL_IN_REG(=1) + MUL_OUT_REG(=1) + PIPELINE_STAGES + OUT_REG(=2)
//
//=============================================================================
module dft_complex_mul
#(
    parameter DATA_A_W = 16, // Data A width
    parameter DATA_B_W = 16, // Data B width
    parameter PIPELINE_STAGES = 2
)
(
    // System
    input wire                        clk,       // System clock
    input wire                        rst,       // System reset
    // Input data
    input  wire signed [DATA_A_W-1:0] data_a_re, // Data A real part
    input  wire signed [DATA_A_W-1:0] data_a_im, // Data A imaginary part
    input  wire signed [DATA_B_W-1:0] data_b_re, // Data B real part
    input  wire signed [DATA_B_W-1:0] data_b_im, // Data B imaginary part
    // Output data
    output reg signed [DATA_B_W-1:0] result_re,  // Result real part
    output reg signed [DATA_B_W-1:0] result_im   // Result imaginary part
);

//-----------------------------------------------------------------------------
// Local variables
//-----------------------------------------------------------------------------
wire signed [DATA_A_W+DATA_B_W-1:0] mul_re0_res;
wire signed [DATA_A_W+DATA_B_W-1:0] mul_re1_res;
wire signed [DATA_A_W+DATA_B_W-1:0] mul_im0_res;
wire signed [DATA_A_W+DATA_B_W-1:0] mul_im1_res;
wire signed [DATA_A_W+DATA_B_W:0] add_result;
wire signed [DATA_A_W+DATA_B_W:0] sub_result;
//-----------------------------------------------------------------------------
// Real part of the result
//-----------------------------------------------------------------------------
dft_mul
#(
    .DATA_A_W      (DATA_A_W),
    .DATA_B_W      (DATA_B_W),
    .DATA_A_SIGNED ("on"),     // "on" / "off"
    .DATA_B_SIGNED ("on"),     // "on" / "off"
    .INPUT_REG     ("on"),    // "on" / "off"
    .OUTPUT_REG    ("on")      // "on" / "off"
) mul_re0 (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a (data_a_re),  // Data A
    .data_b (data_b_re),  // Data B
    // Output data
    .result (mul_re0_res)    // Result
);

dft_mul
#(
    .DATA_A_W      (DATA_A_W),
    .DATA_B_W      (DATA_B_W),
    .DATA_A_SIGNED ("on"),     // "on" / "off"
    .DATA_B_SIGNED ("on"),     // "on" / "off"
    .INPUT_REG     ("on"),    // "on" / "off"
    .OUTPUT_REG    ("on")      // "on" / "off"
) mul_re1 (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a (data_a_im),  // Data A
    .data_b (data_b_im),  // Data B
    // Output data
    .result (mul_re1_res)    // Result
);

dft_sub
#(
    .DATA_W          (DATA_A_W+DATA_B_W+1),
    .DATA_SIGNED     ("on"),  // "on" / "off"
    .INPUT_REG       ("off"),  // "on" / "off"
    .OUTPUT_REG      ("on"),   // "on" / "off"
    .PIPELINE_STAGES (PIPELINE_STAGES),
    .PIPE_4BIT       (1'b1)
) sub_im (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a ({mul_re0_res[DATA_A_W+DATA_B_W-1], mul_re0_res}),   // Data A
    .data_b ({mul_re1_res[DATA_A_W+DATA_B_W-1], mul_re1_res}),   // Data B
    // Output data
    .result (sub_result)    // Result
);

//-----------------------------------------------------------------------------
// Imaginary part of the result
//-----------------------------------------------------------------------------
dft_mul
#(
    .DATA_A_W      (DATA_A_W),
    .DATA_B_W      (DATA_B_W),
    .DATA_A_SIGNED ("on"),     // "on" / "off"
    .DATA_B_SIGNED ("on"),     // "on" / "off"
    .INPUT_REG     ("on"),    // "on" / "off"
    .OUTPUT_REG    ("on")      // "on" / "off"
) mul_im0 (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a (data_a_re),  // Data A
    .data_b (data_b_im),  // Data B
    // Output data
    .result (mul_im0_res)    // Result
);

dft_mul
#(
    .DATA_A_W      (DATA_A_W),
    .DATA_B_W      (DATA_B_W),
    .DATA_A_SIGNED ("on"),     // "on" / "off"
    .DATA_B_SIGNED ("on"),     // "on" / "off"
    .INPUT_REG     ("on"),    // "on" / "off"
    .OUTPUT_REG    ("on")      // "on" / "off"
) mul_im1 (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a (data_a_im),  // Data A
    .data_b (data_b_re),  // Data B
    // Output data
    .result (mul_im1_res)    // Result
);

dft_add
#(
    .DATA_W          (DATA_A_W+DATA_B_W+1),
    .DATA_SIGNED     ("on"),  // "on" / "off"
    .INPUT_REG       ("off"),  // "on" / "off"
    .OUTPUT_REG      ("on"),   // "on" / "off"
    .PIPELINE_STAGES (PIPELINE_STAGES)
) add_im (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a ({mul_im0_res[DATA_A_W+DATA_B_W-1], mul_im0_res}),   // Data A
    .data_b ({mul_im1_res[DATA_A_W+DATA_B_W-1], mul_im1_res}),   // Data B
    // Output data
    .result (add_result)    // Result
);

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        result_re <= 0;
        result_im <= 0;
    end
    else begin
        result_re <= sub_result[DATA_A_W+DATA_B_W-2:DATA_B_W-1];
        result_im <= add_result[DATA_A_W+DATA_B_W-2:DATA_B_W-1];
    end
end

endmodule