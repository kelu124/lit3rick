//==============================================================================
// DFT Multiplier wrapper
//
// result = data_a * data_b
//
//=============================================================================
module dft_mul
#(
    parameter DATA_A_W      = 16,
    parameter DATA_B_W      = 16,
    parameter DATA_A_SIGNED = "on",     // "on" / "off"
    parameter DATA_B_SIGNED = "on",     // "on" / "off"
    parameter INPUT_REG     = "off",    // "on" / "off"
    parameter OUTPUT_REG    = "on"      // "on" / "off"
)
(
    // System
    input wire                 clk,  // System clock
    input wire                 rst,  // System reset
    // Input data
    input  wire [DATA_A_W-1:0] data_a, // Data A
    input  wire [DATA_B_W-1:0] data_b, // Data B
    // Output data
    output wire [DATA_A_W+DATA_B_W-1:0] result  // Result
);

lscc_multiplier
#(
    .USE_COEFF (0),
    .A_WIDTH   (DATA_A_W),
    .B_WIDTH   (DATA_B_W),
    .A_SIGNED  (DATA_A_SIGNED),
    .B_SIGNED  (DATA_B_SIGNED),
    .USE_IREG  (INPUT_REG),
    .USE_OREG  (OUTPUT_REG),
    .PIPELINES (0),
    .IMPL      ("DSP")
) lscc_multiplier (
    .clk_i      (clk),
    .clk_en_i   (1'b1),
    .rst_i      (rst),
    .data_a_i   (data_a),
    .data_b_i   (data_b),
    .result_o   (result)
);

endmodule