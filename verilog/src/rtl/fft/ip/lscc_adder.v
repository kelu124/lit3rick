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
// File                  : lscc_adder.v
// Title                 : 
// Dependencies          : 
// Description           : A two-input adder that performs signed/unsigned
//                       : addition of the data from inputs DataA and DataB
//                       : with an optional Cin carry input. The output Result
//                       : carries the Sum of the addition operation with an
//                       : optional Cout carry output.
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.1.0.
// Author(s)             : 
// Mod. Date             : 
// Changes Made          : Removed register input option.
// =============================================================================

`ifndef LSCC_ADDER
`define LSCC_ADDER

module lscc_adder #
// -----------------------------------------------------------------------------
// Module Parameters
// -----------------------------------------------------------------------------
(
parameter integer            D_WIDTH   = 16,
parameter                    SIGNED    = "off",
parameter                    USE_CNUM  = 0,
parameter                    USE_CIN   = 0,
parameter                    USE_COUT  = 0,
parameter                    USE_IREG  = "off",
parameter                    USE_OREG  = "off",
parameter integer            PIPELINES = 0,
parameter                    PIPE_4BIT = 1'b0,
parameter                    FAMILY    = "LIFCL"
)
// -----------------------------------------------------------------------------
// Input/Output Ports
// -----------------------------------------------------------------------------
(
input                        clk_i,
input                        clk_en_i,
input                        rst_i,
input [D_WIDTH-1:0]          data_a_re_i,
input [D_WIDTH-1:0]          data_a_im_i,
input [D_WIDTH-1:0]          data_b_re_i,
input [D_WIDTH-1:0]          data_b_im_i,
input                        cin_re_i,
input                        cin_im_i,

output reg [D_WIDTH-1:0]     result_re_o,
output reg [D_WIDTH-1:0]     result_im_o,
output reg                   cout_re_o,
output reg                   cout_im_o
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
localparam                   CNUM      = (USE_CNUM == 0) ? 1'b0 : 1'b1;
localparam                   CIN       = (USE_CIN  == 0) ? 1'b0 : 1'b1;
localparam                   COUT      = (USE_COUT == 0) ? 1'b0 : 1'b1;
localparam integer           MAX_PIPES = ((D_WIDTH - 1) >> (3 - PIPE_4BIT));
localparam integer           PIPES     = (PIPELINES > MAX_PIPES) ? MAX_PIPES : PIPELINES;
localparam integer           MIN_SFT   = (D_WIDTH/(PIPES + 1));
localparam integer           MIN_SFT_C = (MIN_SFT * (PIPES + 1));
localparam integer           SFT_WDT   = (MIN_SFT + (MIN_SFT_C < D_WIDTH));
localparam integer           PIPE_WDT  = (PIPES * SFT_WDT);
localparam [D_WIDTH-1:0]     I_VAL_0   = {D_WIDTH{1'b0}};

// -----------------------------------------------------------------------------
// Combinatorial/Sequential Registers
// -----------------------------------------------------------------------------
reg [D_WIDTH-1:0]            A_Re;
reg [D_WIDTH-1:0]            B_Re;
reg [D_WIDTH-1:0]            A_Im;
reg [D_WIDTH-1:0]            B_Im;
reg                          Ci_Im;
reg                          Ci_Re;
reg                          Co_Re;
reg                          Co_Im;

// -----------------------------------------------------------------------------
// Wire Declarations
// -----------------------------------------------------------------------------
wire [D_WIDTH-1:0]           ApB_Re;
wire [D_WIDTH-1:0]           ApB_Im;
wire                         A_Re_msb;
wire                         B_Re_msb;
wire                         A_Im_msb;
wire                         B_Im_msb;

wire                         ApB_Re_msb = ApB_Re[D_WIDTH-1];
wire                         ApB_Im_msb = ApB_Im[D_WIDTH-1];
wire                         Co_Re_c    = (COUT & Co_Re);
wire                         Co_Im_c    = (COUT & Co_Im);

// -----------------------------------------------------------------------------
// Combinatorial Blocks
// -----------------------------------------------------------------------------
always @* begin
  if (SIGNED == "on") begin
    case({A_Re_msb, B_Re_msb})
      2'b00: Co_Re =  ApB_Re_msb;
      2'b11: Co_Re = ~ApB_Re_msb;
      2'b01,
      2'b10: Co_Re = 1'b0;
    endcase

    case({A_Im_msb, B_Im_msb})
      2'b00: Co_Im =  ApB_Im_msb;
      2'b11: Co_Im = ~ApB_Im_msb;
      2'b01,
      2'b10: Co_Im = 1'b0;
    endcase
  end
  else begin
    case({A_Re_msb, B_Re_msb})
      2'b00: Co_Re = 1'b0;
      2'b11: Co_Re = 1'b1;
      2'b01,
      2'b10: Co_Re = ~ApB_Re_msb;
    endcase

    case({A_Im_msb, B_Im_msb})
      2'b00: Co_Im = 1'b0;
      2'b11: Co_Im = 1'b1;
      2'b01,
      2'b10: Co_Im = ~ApB_Im_msb;
    endcase
  end
end

// -----------------------------------------------------------------------------
// Generate Combinatorial/Sequential Blocks
// -----------------------------------------------------------------------------
generate
  if(USE_IREG == "on") begin : U_I_REG_ON
    // -----------------
    // Sequential Input
    // -----------------
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        A_Re  <= I_VAL_0;
        B_Re  <= I_VAL_0;
        A_Im  <= I_VAL_0;
        B_Im  <= I_VAL_0;
        Ci_Im <= 1'b0;
        Ci_Re <= 1'b0;
      end
      else if (clk_en_i) begin
        A_Re  <= data_a_re_i ;
        B_Re  <= data_b_re_i ;
        A_Im  <= ({D_WIDTH {CNUM}} & data_a_im_i);
        B_Im  <= ({D_WIDTH {CNUM}} & data_b_im_i);
        Ci_Im <= (CIN & CNUM & cin_im_i);
        Ci_Re <= (CIN & cin_re_i);
      end
    end
  end  // U_I_REG_ON
  else begin : U_I_REG_OFF
    // --------------------
    // Combinatorial Input
    // --------------------
    always @* begin
      A_Re  = data_a_re_i ;
      B_Re  = data_b_re_i ;
      A_Im  = ({D_WIDTH {CNUM}} & data_a_im_i);
      B_Im  = ({D_WIDTH {CNUM}} & data_b_im_i);
      Ci_Im = (CIN & CNUM & cin_im_i);
      Ci_Re = (CIN & cin_re_i);
    end
  end  // U_I_REG_OFF
endgenerate

generate
  if (PIPES > 0) begin : U_PIPELINES_GT_0
    // -------------------------------------------------------------------------
    // PIPELINED
    // Addition here happens as given below.
    // rst_i: All pipes initialized to All 0's
    // i is 0: Add raw inputs of Shift Width size
    // Add piped inputs of Shift Width size and accumulate with the value
    // from the previous pipe.
    // -------------------------------------------------------------------------
    reg [D_WIDTH-1:0] A_Re_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] B_Re_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] A_Im_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] B_Im_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] ApB_Re_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] ApB_Im_pipe [PIPES-1:0];
  
    integer i;
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        for(i = 0 ; i < PIPES ; i = i + 1) begin
          A_Re_pipe[i]   <= I_VAL_0;
          B_Re_pipe[i]   <= I_VAL_0;
          A_Im_pipe[i]   <= I_VAL_0;
          B_Im_pipe[i]   <= I_VAL_0;
          ApB_Re_pipe[i] <= I_VAL_0;
          ApB_Im_pipe[i] <= I_VAL_0;
        end
      end
      else begin
        for (i = 0 ; i < PIPES ; i = i + 1) begin
          if (i == 0) begin
            A_Re_pipe[0] <= A_Re;
            B_Re_pipe[0] <= B_Re;
            A_Im_pipe[0] <= A_Im;
            B_Im_pipe[0] <= B_Im;
          end
          else begin
            A_Re_pipe[i] <= A_Re_pipe[i-1];
            B_Re_pipe[i] <= B_Re_pipe[i-1];
            A_Im_pipe[i] <= A_Im_pipe[i-1];
            B_Im_pipe[i] <= B_Im_pipe[i-1];
          end
  
          if (i == 0) begin
            ApB_Re_pipe[0] <= ( A_Re[SFT_WDT-1:0] +
                                B_Re[SFT_WDT-1:0] +
                               Ci_Re             );
            ApB_Im_pipe[0] <= ( A_Im[SFT_WDT-1:0] +
                                B_Im[SFT_WDT-1:0] +
                               Ci_Im             );
          end
          else begin
            ApB_Re_pipe[i] <= {ApB_Re_pipe[i-1]                         +
                               ((A_Re_pipe[i-1][(i*SFT_WDT) +: SFT_WDT] +
                                 B_Re_pipe[i-1][(i*SFT_WDT) +: SFT_WDT]
                                ) << (i*SFT_WDT))
                              };
            ApB_Im_pipe[i] <= {ApB_Im_pipe[i-1]                         +
                               ((A_Im_pipe[i-1][(i*SFT_WDT) +: SFT_WDT] +
                                 B_Im_pipe[i-1][(i*SFT_WDT) +: SFT_WDT]
                                ) << (i*SFT_WDT))
                              };
          end
        end
      end
    end
  
    assign A_Re_msb = A_Re_pipe[PIPES-1][D_WIDTH-1];
    assign B_Re_msb = B_Re_pipe[PIPES-1][D_WIDTH-1];
    assign A_Im_msb = A_Im_pipe[PIPES-1][D_WIDTH-1];
    assign B_Im_msb = B_Im_pipe[PIPES-1][D_WIDTH-1];
  
    assign ApB_Re   = {ApB_Re_pipe[PIPES-1]                   +
                       ((A_Re_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT] +
                         B_Re_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT]
                        ) << PIPE_WDT)
                      };
    assign ApB_Im   = {ApB_Im_pipe[PIPES-1]                   +
                       ((A_Im_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT] +
                         B_Im_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT]
                        ) << PIPE_WDT)
                      };
  end  // U_PIPELINES_GT_0
  else begin : U_PIPELINES_EQ_0
    // --------------
    // Combinatorial
    // --------------
    assign A_Re_msb = A_Re[D_WIDTH-1];
    assign B_Re_msb = B_Re[D_WIDTH-1];
    assign A_Im_msb = A_Im[D_WIDTH-1];
    assign B_Im_msb = B_Im[D_WIDTH-1];
  
    assign ApB_Re = {A_Re + B_Re + Ci_Re};
    assign ApB_Im = {A_Im + B_Im + Ci_Im};

  end  // U_PIPELINES_EQ_0
endgenerate

generate
  if (USE_OREG == "on") begin : U_O_REG_ON
    // ------------------
    // Sequential Output
    // ------------------
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        result_re_o <= I_VAL_0;
        result_im_o <= I_VAL_0;
        cout_re_o   <= 1'b0;
        cout_im_o   <= 1'b0;
      end
      else if (clk_en_i) begin
        result_re_o <= ApB_Re;
        result_im_o <= ApB_Im;
        cout_re_o   <=  Co_Re_c;
        cout_im_o   <=  Co_Im_c;
      end
    end
  end  // U_O_REG_ON
  else begin : U_O_REG_OFF
    // ---------------------
    // Combinatorial Output
    // ---------------------
    always @* begin
      result_re_o = ApB_Re;
      result_im_o = ApB_Im;
      cout_re_o   =  Co_Re_c;
      cout_im_o   =  Co_Im_c;
    end
  end  // U_O_REG_OFF
endgenerate

endmodule
//=============================================================================
// lscc_adder.v
//=============================================================================
`endif