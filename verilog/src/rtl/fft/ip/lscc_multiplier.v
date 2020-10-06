// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2017 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
// -----------------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS
// Project               :
// File                  : lscc_multiplier.v
// Title                 :
// Dependencies          :
// Description           : A two-input multiplier that performs signed/unsigned
//                       : multiplication of the data from inputs data_a_i and
//                       : data_b_i with an optional constant multiplier. The
//                       : output result_o carries the Product of the
//                       : multiplication operation.
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.1.0.
// Author(s)             :
// Mod. Date             :
// Changes Made          : Updated pipeline value range: implementation-dependent
// =============================================================================

`ifndef LSCC_MULTIPLIER
`define LSCC_MULTIPLIER

module lscc_multiplier #
// -----------------------------------------------------------------------------
// Module Parameters
// -----------------------------------------------------------------------------
(
parameter                    USE_COEFF = 0,
parameter [31:0]             COEFF     = 32'd2,
parameter integer            A_WIDTH   = 9,
parameter integer            B_WIDTH   = 9,
parameter                    A_SIGNED  = "on",
parameter                    B_SIGNED  = "on",
parameter                    USE_IREG  = "on",
parameter                    USE_OREG  = "on",
parameter integer            PIPELINES = 1,
parameter                    IMPL      = "LUT",
parameter                    FAMILY    = "LIFCL"
)
// -----------------------------------------------------------------------------
// Input/Output Ports
// -----------------------------------------------------------------------------
(
                             clk_i,
                             clk_en_i,
                             rst_i,
                             data_a_i,
                             data_b_i,
                             result_o
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
localparam                   C_SIGN         = COEFF[31];
localparam                   COEFF_EN       = (USE_COEFF == 0) ? 1'b0 : 1'b1;
localparam [31:0]            COEFF_ABS      = {(COEFF ^ {32{C_SIGN}}) + C_SIGN};
localparam integer           C_WDT          = clog2(COEFF_ABS);
localparam integer           X_WDT          = COEFF_EN ? C_WDT : B_WIDTH;
localparam integer           M_WDT          = (A_WIDTH + X_WDT);

// -----------------------------------------------------------------------------
// Input/Output Declarations
// -----------------------------------------------------------------------------
input                        clk_i;
input                        clk_en_i;
input                        rst_i;
input [A_WIDTH-1:0]          data_a_i;
input [B_WIDTH-1:0]          data_b_i;
output wire [M_WDT-1:0]      result_o;

// -----------------------------------------------------------------------------
// Generate Module Instantiations
// -----------------------------------------------------------------------------
generate
  if (IMPL == "LUT") begin
    lscc_multiplier_lut #(
      .USE_COEFF             (USE_COEFF),
      .COEFF                 (COEFF),
      .A_WIDTH               (A_WIDTH),
      .B_WIDTH               (B_WIDTH),
      .A_SIGNED              (A_SIGNED),
      .B_SIGNED              (B_SIGNED),
      .USE_IREG              (USE_IREG),
      .USE_OREG              (USE_OREG),
      .PIPELINES             (PIPELINES)
    )
    u_lscc_multiplier_lut (
      .clk_i                 (clk_i),
      .clk_en_i              (clk_en_i),
      .rst_i                 (rst_i),
      .data_a_i              (data_a_i[A_WIDTH-1:0]),
      .data_b_i              (data_b_i[B_WIDTH-1:0]),
      .result_o              (result_o[M_WDT-1:0])
    );
  end
  else begin
    lscc_multiplier_dsp #(
      .USE_COEFF             (USE_COEFF),
      .COEFF                 (COEFF),
      .A_WIDTH               (A_WIDTH),
      .B_WIDTH               (B_WIDTH),
      .A_SIGNED              (A_SIGNED),
      .B_SIGNED              (B_SIGNED),
      .USE_IREG              (USE_IREG),
      .USE_OREG              (USE_OREG),
      .PIPELINES             (PIPELINES)
    )
    u_lscc_multiplier_dsp (
      .clk_i                 (clk_i),
      .clk_en_i              (clk_en_i),
      .rst_i                 (rst_i),
      .data_a_i              (data_a_i[A_WIDTH-1:0]),
      .data_b_i              (data_b_i[B_WIDTH-1:0]),
      .result_o              (result_o[M_WDT-1:0])
    );
  end
endgenerate

// -----------------------------------------------------------------------------
// Function Definition
// -----------------------------------------------------------------------------
function integer clog2;
  input integer value;
  integer       val;
  begin
    val = (value < 1) ? 1 : value;
    for (clog2 = 0 ; val > 0 ; clog2 = clog2 + 1)
      val = (val >> 1);
  end
endfunction

endmodule

// =============================================================================
// Submodule             : lscc_multiplier_lut.v
// =============================================================================
module lscc_multiplier_lut #
// -----------------------------------------------------------------------------
// Module Parameters
// -----------------------------------------------------------------------------
(
parameter                    USE_COEFF = 0,
parameter [31:0]             COEFF     = 32'd2,
parameter integer            A_WIDTH   = 9,
parameter integer            B_WIDTH   = 9,
parameter                    A_SIGNED  = "on",
parameter                    B_SIGNED  = "on",
parameter                    USE_IREG  = "on",
parameter                    USE_OREG  = "on",
parameter integer            PIPELINES = 1
)
// -----------------------------------------------------------------------------
// Input/Output Ports
// -----------------------------------------------------------------------------
(
                             clk_i,
                             clk_en_i,
                             rst_i,
                             data_a_i,
                             data_b_i,
                             result_o
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
localparam                   A_SIGN         = (A_SIGNED == "on") ? 1'b1 : 1'b0;
localparam                   B_SIGN         = (B_SIGNED == "on") ? 1'b1 : 1'b0;
localparam                   C_SIGN         = COEFF[31];
localparam                   COEFF_EN       = (USE_COEFF == 0) ? 1'b0 : 1'b1;
localparam [31:0]            COEFF_ABS      = {(COEFF ^ {32{C_SIGN}}) + C_SIGN};
localparam integer           C_WDT          = clog2(COEFF_ABS);
localparam integer           X_WDT          = COEFF_EN ? C_WDT : B_WIDTH ;
localparam integer           M_WDT          = (A_WIDTH + X_WDT);
localparam                   A_WDT_GT_X_WDT = (COEFF_EN | (A_WIDTH > B_WIDTH));
localparam integer           MAX_WDT        = A_WDT_GT_X_WDT ? A_WIDTH : B_WIDTH ;
//localparam integer           PIPES          = (PIPELINES > MAX_WDT) ? MAX_WDT : PIPELINES;
localparam integer           PIPES          = PIPELINES;
//localparam integer           SFT_WDT        = (PIPES > 1) ? MAX_WDT : (MAX_WDT/PIPES);
localparam integer           SFT_WDT        = MAX_WDT;
localparam [C_WDT-1:0]       C_VAL          = COEFF        ;
localparam [A_WIDTH-1:0]     A_VAL_0        = {A_WIDTH{1'b0}};
localparam [B_WIDTH-1:0]     B_VAL_0        = {B_WIDTH{1'b0}};
localparam [M_WDT-1:0]       M_VAL_0        = {M_WDT{1'b0}};

// -----------------------------------------------------------------------------
// Input/Output Declarations
// -----------------------------------------------------------------------------
input                        clk_i;
input                        clk_en_i;
input                        rst_i;
input [A_WIDTH-1:0]          data_a_i;
input [B_WIDTH-1:0]          data_b_i;
output reg [M_WDT-1:0]       result_o;

// -----------------------------------------------------------------------------
// Combinatorial/Sequential Registers
// -----------------------------------------------------------------------------
reg [A_WIDTH-1:0]            A_reg;
reg [B_WIDTH-1:0]            B_reg;

// -----------------------------------------------------------------------------
// Wire Declarations
// -----------------------------------------------------------------------------
wire [M_WDT-1:0]             AxB_i /*synthesis syn_multstyle="logic"*/;

wire                         A_neg = (A_SIGN & A_reg[A_WIDTH-1]);
wire                         B_neg = (B_SIGN & B_reg[B_WIDTH-1]);
wire signed [A_WIDTH:0]      A_se  = {A_neg , A_reg};
wire signed [B_WIDTH:0]      B_se  = {B_neg , B_reg};
wire signed [C_WDT:0]        C_se  = {C_SIGN, C_VAL};
wire signed [X_WDT:0]        X_se  = USE_COEFF ? C_se : B_se ;

// -----------------------------------------------------------------------------
// Generate Combinatorial/Sequential Blocks
// -----------------------------------------------------------------------------
generate
  if (USE_IREG == "on") begin : U_I_REG_ON
    // -----------------
    // Sequential Input
    // -----------------
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        A_reg <= A_VAL_0;
        B_reg <= B_VAL_0;
      end
      else if (clk_en_i) begin
        A_reg <= data_a_i;
        B_reg <= data_b_i;
      end
    end
  end  // U_I_REG_ON
  else begin : U_I_REG_OFF
    // --------------------
    // Combinatorial Input
    // --------------------
    always @* begin
      A_reg = data_a_i;
      B_reg = data_b_i;
    end
  end  // U_I_REG_OFF
endgenerate

generate
  if (PIPES > 0) begin : U_PIPELINES_GT_0
    // -------------------------------------------------------------------------
    // PIPELINED
    // Multiplication here happens as given below.
    // Reset: All pipes initialized to All 0's
    // Stage 0: Multiply raw inputs with Shift Width on one of them
    // Others : Multiply piped inputs with Shift Width on one of them and
    // accumulate with the value from the previous pipe
    // -------------------------------------------------------------------------
    reg signed [A_WIDTH:0]   cA_pipe [PIPES-1:0];
    reg signed [A_WIDTH:0]   sA_pipe [PIPES-1:0];
    reg signed [A_WIDTH:0]   A_pipe  [PIPES-1:0] /*synthesis syn_ramstyle="registers"*/;
    reg signed [X_WDT:0]     cX_pipe [PIPES-1:0];
    reg signed [X_WDT:0]     sX_pipe [PIPES-1:0];
    reg signed [X_WDT:0]     X_pipe  [PIPES-1:0] /*synthesis syn_ramstyle="registers"*/;

    reg signed [M_WDT-1:0]   pp_pipe  [PIPES-1:0] /*synthesis syn_multstyle="logic"*/;
    reg signed [M_WDT-1:0]   spp_pipe [PIPES-1:0];
    reg signed [M_WDT-1:0]   AxB_pipe [PIPES-1:0];

    always @* begin
      A_pipe[0] = A_se;
      X_pipe[0] = X_se;
    end

    integer i;
    always @* begin
      for (i = 0 ; i < (PIPES-1) ; i = i + 1) begin
        if (A_WDT_GT_X_WDT) begin
          sA_pipe[i]              = {A_WIDTH+1{1'b0}};
          sA_pipe[i][SFT_WDT-1:0] =  A_pipe[i][SFT_WDT-1:0];
          sX_pipe[i]              =  X_pipe[i];
          cX_pipe[i]              =  X_pipe[i];
          cA_pipe[i]              = (A_pipe[i] >>> SFT_WDT);
        end
        else begin
          sX_pipe[i]              = {X_WDT+1{1'b0}};
          sX_pipe[i][SFT_WDT-1:0] =  X_pipe[i][SFT_WDT-1:0];
          sA_pipe[i]              =  A_pipe[i];
          cA_pipe[i]              =  A_pipe[i];
          cX_pipe[i]              = (X_pipe[i] >>> SFT_WDT);
        end
      end
      sA_pipe[PIPES-1] =  A_pipe[PIPES-1];
      sX_pipe[PIPES-1] =  X_pipe[PIPES-1];
    end

    integer j;
    always @* begin
      for (j = 0 ; j < PIPES ; j = j + 1) begin
        pp_pipe[j]  = (sA_pipe[j] * sX_pipe[j]);
        spp_pipe[j] = (pp_pipe[j] << (j*SFT_WDT));
      end
    end

    integer k;
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        for (k = 1 ; k < PIPES ; k = k + 1) begin
          A_pipe[k]   <= {A_WIDTH+1{1'b0}};
          X_pipe[k]   <= {X_WDT+1{1'b0}};
          AxB_pipe[k] <= M_VAL_0;
        end
        AxB_pipe[0] <= M_VAL_0;
      end
      else if (clk_en_i) begin
        for (k = 1 ; k < PIPES ; k = k + 1) begin
          A_pipe[k]   <= cA_pipe[k-1];
          X_pipe[k]   <= cX_pipe[k-1];
          AxB_pipe[k] <= {AxB_pipe[k-1] + spp_pipe[k]};
        end
        AxB_pipe[0] <= spp_pipe[0];
      end
    end

    assign AxB_i = AxB_pipe[PIPES-1];

  end  // U_PIPELINES_GT_0
  else begin : U_PIPELINES_EQ_0
    // --------------
    // Combinatorial
    // --------------
    assign AxB_i = (A_se * X_se);
  end  // U_PIPELINES_EQ_0
endgenerate

generate
  if (USE_OREG == "on") begin : U_O_REG_ON
    // ------------------
    // Sequential Output
    // ------------------
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        result_o <= M_VAL_0;
      end
      else if (clk_en_i) begin
        result_o <= AxB_i;
      end
    end
  end  // U_O_REG_ON
  else begin : U_O_REG_OFF
    // ---------------------
    // Combinatorial Output
    // ---------------------
    always @* begin
      result_o = AxB_i;
    end
  end  // U_O_REG_OFF
endgenerate

// -----------------------------------------------------------------------------
// Function Definition
// -----------------------------------------------------------------------------
function integer clog2;
  input integer value;
  integer       val;
  begin
    val = (value < 1) ? 1 : value;
    for (clog2 = 0 ; val > 0 ; clog2 = clog2 + 1)
      val = (val >> 1);
  end
endfunction

endmodule

// =============================================================================
// Submodule             : lscc_multiplier_dsp.v
// =============================================================================
module lscc_multiplier_dsp #
// -----------------------------------------------------------------------------
// Module Parameters
// -----------------------------------------------------------------------------
(
parameter                    USE_COEFF = 1'b0,
parameter [31:0]             COEFF     = 32'd2,
parameter integer            A_WIDTH   = 9,
parameter integer            B_WIDTH   = 9,
parameter                    A_SIGNED  = "on",
parameter                    B_SIGNED  = "on",
parameter                    USE_IREG  = "on",
parameter                    USE_OREG  = "on",
parameter integer            PIPELINES = 1
)
// -----------------------------------------------------------------------------
// Input/Output Ports
// -----------------------------------------------------------------------------
(
                             clk_i,
                             clk_en_i,
                             rst_i,
                             data_a_i,
                             data_b_i,
                             result_o
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
localparam                   A_SIGN         = (A_SIGNED == "on") ? 1'b1 : 1'b0;
localparam                   B_SIGN         = (B_SIGNED == "on") ? 1'b1 : 1'b0;
localparam                   C_SIGN         = COEFF[31];
localparam                   COEFF_EN       = (USE_COEFF == 0) ? 1'b0 : 1'b1;
localparam [31:0]            COEFF_ABS      = {(COEFF ^ {32{C_SIGN}}) + C_SIGN};
localparam integer           C_WDT          = clog2(COEFF_ABS);
localparam integer           X_WDT          = COEFF_EN ? C_WDT : B_WIDTH ;
localparam integer           M_WDT          = (A_WIDTH + X_WDT);
localparam                   A_WDT_GT_X_WDT = (COEFF_EN | (A_WIDTH > B_WIDTH));
localparam integer           MAX_WDT        = A_WDT_GT_X_WDT ? A_WIDTH : B_WIDTH ;
//localparam integer           PIPES          = (PIPELINES > MAX_WDT) ? MAX_WDT : PIPELINES;
localparam integer           PIPES          = PIPELINES;
//localparam integer           SFT_WDT        = (PIPES > 1) ? MAX_WDT : (MAX_WDT/PIPES);
localparam integer           SFT_WDT        = MAX_WDT;
localparam [C_WDT-1:0]       C_VAL          = COEFF        ;
localparam [A_WIDTH-1:0]     A_VAL_0        = {A_WIDTH{1'b0}};
localparam [B_WIDTH-1:0]     B_VAL_0        = {B_WIDTH{1'b0}};
localparam [M_WDT-1:0]       M_VAL_0        = {M_WDT{1'b0}};

// -----------------------------------------------------------------------------
// Input/Output Declarations
// -----------------------------------------------------------------------------
input                        clk_i;
input                        clk_en_i;
input                        rst_i;
input [A_WIDTH-1:0]          data_a_i;
input [B_WIDTH-1:0]          data_b_i;
output reg [M_WDT-1:0]       result_o;

// -----------------------------------------------------------------------------
// Combinatorial/Sequential Registers
// -----------------------------------------------------------------------------
reg [A_WIDTH-1:0]            A_reg;
reg [B_WIDTH-1:0]            B_reg;

// -----------------------------------------------------------------------------
// Wire Declarations
// -----------------------------------------------------------------------------
wire [M_WDT-1:0]             AxB_i /*synthesis syn_multstyle="DSP"*/;

wire                         A_neg = (A_SIGN & A_reg[A_WIDTH-1]);
wire                         B_neg = (B_SIGN & B_reg[B_WIDTH-1]);
wire signed [A_WIDTH:0]      A_se  = {A_neg , A_reg};
wire signed [B_WIDTH:0]      B_se  = {B_neg , B_reg};
wire signed [C_WDT:0]        C_se  = {C_SIGN, C_VAL};
wire signed [X_WDT:0]        X_se  = USE_COEFF ? C_se : B_se ;

// -----------------------------------------------------------------------------
// Generate Combinatorial/Sequential Blocks
// -----------------------------------------------------------------------------
generate
  if (USE_IREG == "on") begin : U_I_REG_ON
    // -----------------
    // Sequential Input
    // -----------------
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        A_reg <= A_VAL_0;
        B_reg <= B_VAL_0;
      end
      else if (clk_en_i) begin
        A_reg <= data_a_i;
        B_reg <= data_b_i;
      end
    end
  end  // U_I_REG_ON
  else begin : U_I_REG_OFF
    // --------------------
    // Combinatorial Input
    // --------------------
    always @* begin
      A_reg = data_a_i;
      B_reg = data_b_i;
    end
  end  // U_I_REG_OFF
endgenerate

generate
  if (PIPES > 0) begin : U_PIPELINES_GT_0
    // -------------------------------------------------------------------------
    // PIPELINED
    // Multiplication here happens as given below.
    // Reset: All pipes initialized to All 0's
    // Stage 0: Multiply raw inputs with Shift Width on one of them
    // Others : Multiply piped inputs with Shift Width on one of them and
    // accumulate with the value from the previous pipe
    // -------------------------------------------------------------------------
    reg signed [A_WIDTH:0]   cA_pipe [PIPES-1:0];
    reg signed [A_WIDTH:0]   sA_pipe [PIPES-1:0];
    reg signed [A_WIDTH:0]   A_pipe  [PIPES-1:0] /*synthesis syn_ramstyle="registers"*/;
    reg signed [X_WDT:0]     cX_pipe [PIPES-1:0];
    reg signed [X_WDT:0]     sX_pipe [PIPES-1:0];
    reg signed [X_WDT:0]     X_pipe  [PIPES-1:0] /*synthesis syn_ramstyle="registers"*/;

    reg signed [M_WDT-1:0]   pp_pipe  [PIPES-1:0] /*synthesis syn_multstyle="DSP"*/;
    reg signed [M_WDT-1:0]   spp_pipe [PIPES-1:0];
    reg signed [M_WDT-1:0]   AxB_pipe [PIPES-1:0];

    always @* begin
      A_pipe[0] = A_se;
      X_pipe[0] = X_se;
    end

    integer i;
    always @* begin
      for (i = 0 ; i < (PIPES-1) ; i = i + 1) begin
        if (A_WDT_GT_X_WDT) begin
          sA_pipe[i]              = {A_WIDTH+1{1'b0}};
          sA_pipe[i][SFT_WDT-1:0] =  A_pipe[i][SFT_WDT-1:0];
          sX_pipe[i]              =  X_pipe[i];
          cX_pipe[i]              =  X_pipe[i];
          cA_pipe[i]              = (A_pipe[i] >>> SFT_WDT);
        end
        else begin
          sX_pipe[i]              = {X_WDT+1{1'b0}};
          sX_pipe[i][SFT_WDT-1:0] =  X_pipe[i][SFT_WDT-1:0];
          sA_pipe[i]              =  A_pipe[i];
          cA_pipe[i]              =  A_pipe[i];
          cX_pipe[i]              = (X_pipe[i] >>> SFT_WDT);
        end
      end
      sA_pipe[PIPES-1] =  A_pipe[PIPES-1];
      sX_pipe[PIPES-1] =  X_pipe[PIPES-1];
    end

    integer j;
    always @* begin
      for (j = 0 ; j < PIPES ; j = j + 1) begin
        pp_pipe[j]  = (sA_pipe[j] * sX_pipe[j]);
        spp_pipe[j] = (pp_pipe[j] << (j*SFT_WDT));
      end
    end

    integer k;
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        for (k = 1 ; k < PIPES ; k = k + 1) begin
          A_pipe[k]   <= {A_WIDTH+1{1'b0}};
          X_pipe[k]   <= {X_WDT+1{1'b0}};
          AxB_pipe[k] <= M_VAL_0;
        end
        AxB_pipe[0] <= M_VAL_0;
      end
      else if (clk_en_i) begin
        for (k = 1 ; k < PIPES ; k = k + 1) begin
          A_pipe[k]   <= cA_pipe[k-1];
          X_pipe[k]   <= cX_pipe[k-1];
          AxB_pipe[k] <= {AxB_pipe[k-1] + spp_pipe[k]};
        end
        AxB_pipe[0] <= spp_pipe[0];
      end
    end

    assign AxB_i = AxB_pipe[PIPES-1];

  end  // U_PIPELINES_GT_0
  else begin : U_PIPELINES_EQ_0
    // --------------
    // Combinatorial
    // --------------
    assign AxB_i = (A_se * X_se);
  end  // U_PIPELINES_EQ_0
endgenerate

generate
  if (USE_OREG == "on") begin : U_O_REG_ON
    // ------------------
    // Sequential Output
    // ------------------
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        result_o <= M_VAL_0;
      end
      else if (clk_en_i) begin
        result_o <= AxB_i;
      end
    end
  end  // U_O_REG_ON
  else begin : U_O_REG_OFF
    // ---------------------
    // Combinatorial Output
    // ---------------------
    always @* begin
      result_o = AxB_i;
    end
  end  // U_O_REG_OFF
endgenerate

// -----------------------------------------------------------------------------
// Function Definition
// -----------------------------------------------------------------------------
function integer clog2;
  input integer value;
  integer       val;
  begin
    val = (value < 1) ? 1 : value;
    for (clog2 = 0 ; val > 0 ; clog2 = clog2 + 1)
      val = (val >> 1);
  end
endfunction

endmodule
// =============================================================================
// lscc_multiplier.v
// =============================================================================
`endif