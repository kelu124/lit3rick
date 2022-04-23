//==============================================================================
// DFT Adder-Subtractor wrapper
//
// result = addsub? data_a + data_b : data_a - data_b
//
//=============================================================================
module dft_addsub
#(
    parameter DATA_W          = 32,
    parameter DATA_SIGNED     = "off",  // "on" / "off"
    parameter OUTPUT_REG      = "on",   // "on" / "off"
    parameter PIPELINE_STAGES = 0
)
(
    // System
    input  wire              clk,  // System clock
    input  wire              rst,  // System reset
    // Control
    input  wire              addsub, // Addition(1) / Subtraction(0) select
    // Input data
    input  wire [DATA_W-1:0] data_a, // Data A
    input  wire [DATA_W-1:0] data_b, // Data B
    // Output data
    output wire [DATA_W-1:0] result  // Result
);

lscc_add_sub
#(
    .D_WIDTH   (DATA_W),
    .SIGNED    (DATA_SIGNED),
    .USE_CNUM  (0),
    .USE_CIN   (0),
    .USE_COUT  (0),
    .USE_OREG  (OUTPUT_REG),
    .PIPELINES (PIPELINE_STAGES),
    .PIPE_4BIT (1'b0)
) lscc_add_sub (
    .clk_i          (clk),
    .clk_en_i       (1'b1),
    .rst_i          (rst),
    .add_sub_i      (addsub),
    .data_a_re_i    (data_a),
    .data_a_im_i    (0),
    .data_b_re_i    (data_b),
    .data_b_im_i    (0),
    .cin_re_i       (0),
    .cin_im_i       (0),

    .result_re_o    (result),
    .result_im_o    (),
    .cout_re_o      (),
    .cout_im_o      ()
);

endmodule