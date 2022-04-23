// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2018 by Lattice Semiconductor Corporation
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
// File                  : lscc_add_sub.v
// Title                 : 
// Dependencies          : 
// Description           : A two-input adder/subtractor that performs 
//                       : signed/unsigned addition/subtraction of the data 
//                       : from inputs data_a_re_i and data_b_re_i with an 
//                       : optional cin_re_i carry/borrow input. The output 
//                       : result carries the Sum/Difference of the 
//						 : addition/subtraction operation with an optional 
//						 : cout_re_o carry/borrow output.
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0.0.
// Author(s)             : 
// Mod. Date             : 
// Changes Made          : Initial release.
// =============================================================================

`ifndef LSCC_ADD_SUB
`define LSCC_ADD_SUB

module lscc_add_sub #
// -----------------------------------------------------------------------------
// Module Parameters
// -----------------------------------------------------------------------------
(
parameter integer D_WIDTH        = 16,
parameter         SIGNED         = "off",
parameter [ 0:0]  USE_CNUM       = 1'b0,
parameter [ 0:0]  USE_CIN        = 1'b0,
parameter [ 0:0]  USE_COUT       = 1'b0,
parameter [ 0:0]  USE_OREG       = 1'b0,
parameter integer PIPELINES      = 0,
parameter [ 0:0]  PIPE_4BIT      = 1'b0,
parameter         FAMILY         = "LIFCL"
)
// -----------------------------------------------------------------------------
// Ports
// -----------------------------------------------------------------------------
(
  // ----- Clocks-Resets for registering -----
clk_i,
clk_en_i,
rst_i,

  // ----- Addition/Subtraction IOs -----
add_sub_i  ,
data_a_re_i,
data_a_im_i,
data_b_re_i,
data_b_im_i,
cin_re_i   ,
cin_im_i   ,
result_re_o,
result_im_o,
cout_re_o  ,
cout_im_o
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
// Modifying parameter interpretations for easy internal use
// Elaboration Computed
// Not to be externally Overridden/Configured even if parameters

localparam integer I_WIDTH = D_WIDTH;
localparam integer I_WDT = (I_WIDTH < 1) ? 1 : I_WIDTH;
localparam integer MAX_PIPES = ((I_WDT - 1) >> (3 - PIPE_4BIT));
localparam integer PIPES = (PIPELINES > MAX_PIPES) ? MAX_PIPES :
                                                     PIPELINES ;
localparam [I_WDT-1:0] I_VAL_0 = {I_WDT{1'b0}};

// -----------------------------------------------------------------------------
// Declared Input/Output Ports
// -----------------------------------------------------------------------------
  // ----- Clocks-Resets for registering -----
input                  clk_i   ;
input                  clk_en_i;
input                  rst_i   ;

  // ----- Addition/Subtraction IOs -----
input                  add_sub_i  ;
input      [I_WDT-1:0] data_a_re_i;
input      [I_WDT-1:0] data_a_im_i;
input      [I_WDT-1:0] data_b_re_i;
input      [I_WDT-1:0] data_b_im_i;
input                  cin_re_i   ;
input                  cin_im_i   ;
output reg [I_WDT-1:0] result_re_o;
output reg [I_WDT-1:0] result_im_o;
output reg             cout_re_o  ;
output reg             cout_im_o  ;

// -----------------------------------------------------------------------------
// Wire Declarations for Addition/Subtraction
// -----------------------------------------------------------------------------
// ----- Addition -----
wire [I_WDT-1:0] ApB_Re;
wire [I_WDT-1:0] ApB_Im;
wire             pCo_Re;
wire             pCo_Im;

// ----- Subtraction -----
wire [I_WDT-1:0] AmB_Re;
wire [I_WDT-1:0] AmB_Im;
wire             mCo_Re;
wire             mCo_Im;

// -----------------------------------------------------------------------------
// ----- Wire Declarations for Addition/Subtraction Selection -----
// -----------------------------------------------------------------------------
wire add_sub_w;

wire [I_WDT-1:0] result_Re = add_sub_w ? ApB_Re : AmB_Re;
wire [I_WDT-1:0] result_Im = add_sub_w ? ApB_Im : AmB_Im;
wire                 Co_Re = add_sub_w ? pCo_Re : mCo_Re;
wire                 Co_Im = add_sub_w ? pCo_Im : mCo_Im;

// -----------------------------------------------------------------------------
// Submodule Instantiations
// -----------------------------------------------------------------------------
lscc_adder #
(
  .D_WIDTH        ( I_WDT     ),
  .SIGNED         ( SIGNED    ),
  .USE_CNUM       ( USE_CNUM  ),
  .USE_CIN        ( USE_CIN   ),
  .USE_COUT       ( USE_COUT  ),
  .USE_OREG       ( 1'b0      ),
  .PIPELINES      ( PIPES     ),
  .PIPE_4BIT      ( PIPE_4BIT )
) 

U_ADDER (
  // ----- Clocks-Resets for registering -----
  .clk_i     ( clk_i     ),  // I:             Top
  .clk_en_i  ( clk_en_i  ),  // I:             Top
  .rst_i     ( rst_i     ),  // I:             Top

  // ----- Addition IOs -----
  .data_a_re_i  ( data_a_re_i ),  // O: [I_WDT-1:0] Top
  .data_a_im_i  ( data_a_im_i ),  // O: [I_WDT-1:0] Top
  .data_b_re_i  ( data_b_re_i ),  // O: [I_WDT-1:0] Top
  .data_b_im_i  ( data_b_im_i ),  // O: [I_WDT-1:0] Top
  .cin_re_i     ( cin_re_i    ),  // O:             Top
  .cin_im_i     ( cin_im_i    ),  // O:             Top
  .result_re_o  ( ApB_Re      ),  // O: [I_WDT-1:0]
  .result_im_o  ( ApB_Im      ),  // O: [I_WDT-1:0]
  .cout_re_o    ( pCo_Re      ),  // O:            
  .cout_im_o    ( pCo_Im      )   // O:            
);  // U_ADDER

lscc_subtractor #
(
  .D_WIDTH        ( I_WDT     ),
  .SIGNED         ( SIGNED    ),
  .USE_CNUM       ( USE_CNUM  ),
  .USE_CIN        ( USE_CIN   ),
  .USE_COUT       ( USE_COUT  ),
  .USE_OREG       ( 1'b0      ),
  .PIPELINES      ( PIPES     ),
  .PIPE_4BIT      ( PIPE_4BIT )
) 

U_SUBTRACTOR (
  // ----- Clocks-Resets for registering -----
  .clk_i     ( clk_i    ),  // I:             Top
  .clk_en_i  ( clk_en_i ),  // I:             Top
  .rst_i     ( rst_i    ),  // I:             Top

  // ----- Subtraction IOs -----
  .data_a_re_i  ( data_a_re_i ),  // O: [I_WDT-1:0] Top
  .data_a_im_i  ( data_a_im_i ),  // O: [I_WDT-1:0] Top
  .data_b_re_i  ( data_b_re_i ),  // O: [I_WDT-1:0] Top
  .data_b_im_i  ( data_b_im_i ),  // O: [I_WDT-1:0] Top
  .cin_re_i     ( cin_re_i    ),  // O:             Top
  .cin_im_i     ( cin_im_i    ),  // O:             Top
  .result_re_o  ( AmB_Re      ),  // O: [I_WDT-1:0]
  .result_im_o  ( AmB_Im      ),  // O: [I_WDT-1:0]
  .cout_re_o    ( mCo_Re      ),  // O:            
  .cout_im_o    ( mCo_Im      )   // O:            
);  // U_SUBTRACTOR

// -----------------------------------------------------------------------------
// ----- Addition/Subtraction Selection -----
// -----------------------------------------------------------------------------
// Pipelining the Add_Sub selector so that each transfer can have
// independent Addition/Subtraction Selection

generate
if(PIPES > 0)
begin : U_PIPELINES_GT_0
    // --------------
    // Pipelined
    // --------------
  reg add_sub_pipe [PIPES-1:0];

  integer i;
  always @(posedge clk_i or posedge rst_i)
  begin
    if(rst_i)
    begin
      for(i = 0 ; i < PIPES ; i = i + 1)
        add_sub_pipe[i] <= 1'b0;
    end
    else
    begin
      for(i = 0 ; i < PIPES ; i = i + 1)
      begin
        if(i == 0) add_sub_pipe[0] <= add_sub_i        ;
        else       add_sub_pipe[i] <= add_sub_pipe[i-1];
      end
    end
  end

  assign add_sub_w = add_sub_pipe[PIPES-1];
end  // U_PIPELINES_GT_0
else
begin : U_PIPELINES_EQ_0
    // --------------
    // Combinatorial
    // --------------
  assign add_sub_w = add_sub_i;
end  // U_PIPELINES_EQ_0
endgenerate



// -----------------------------------------------------------------------------
// ----- Output Registering -----
// -----------------------------------------------------------------------------
generate
if(USE_OREG)
begin : U_USE_OREG_ON
    // ------------------
    // Sequential Output
    // ------------------
  always @(posedge clk_i or posedge rst_i)
  begin
    if(rst_i)
    begin
      result_re_o <= I_VAL_0;
      result_im_o <= I_VAL_0;
      cout_re_o   <= 1'b0   ;
      cout_im_o   <= 1'b0   ;
    end
    else if(clk_en_i)
    begin
      result_re_o <= result_Re;
      result_im_o <= result_Im;
      cout_re_o   <=     Co_Re;
      cout_im_o   <=     Co_Im;
    end
  end
end  // U_USE_OREG_ON
else
begin : U_USE_OREG_OFF
    // ---------------------
    // Combinatorial Output
    // ---------------------
  always @( * )
  begin
    result_re_o = result_Re;
    result_im_o = result_Im;
    cout_re_o   =     Co_Re;
    cout_im_o   =     Co_Im;
  end
end  // U_USE_OREG_OFF
endgenerate

// synthesis translate_off

// -----------------------------------------------------------------------------
// Parsing User Configurations
// -----------------------------------------------------------------------------
initial
begin
  if(I_WIDTH != I_WDT)
  begin
    $display("@I:Invalid configuration D_WIDTH = %d", I_WIDTH);
    $display("@I:Corrected to                           %d", I_WDT);
  end

  if(PIPELINES != PIPES)
  begin
    $display("@I:Invalid configuration PIPELINES = %d", PIPELINES);
    $display("@I:Corrected to                      %d", PIPES    );
  end
end

// synthesis translate_on

endmodule 
//=============================================================================
// lscc_add_sub.v
//=============================================================================

`endif

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
// File                  : lscc_subtractor.v
// Title                 : 
// Dependencies          : 
// Description           : A two-input subtractor that performs signed/unsigned
//                       : subtraction of the data from inputs DataA and DataB
//                       : with an optional Cin borrow input. The output Result
//                       : carries the Difference of the subtraction operation
//                       : with an optional Cout borrow output.
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.1.0
// Author(s)             : 
// Mod. Date             : 
// Changes Made          : Removed registered input option.
// =============================================================================

`ifndef LSCC_SUBTRACTOR
`define LSCC_SUBTRACTOR

module lscc_subtractor #
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
localparam                   UNSIGNED  = (SIGNED == "on") ? 1'b0 : 1'b1;
localparam integer           MAX_PIPES = ((D_WIDTH - 1) >> (3 - PIPE_4BIT));
localparam integer           PIPES     = (PIPELINES > MAX_PIPES) ? MAX_PIPES : PIPELINES ;
localparam integer           MIN_SFT   = (D_WIDTH/(PIPES + 1));
localparam integer           MIN_SFT_C = (MIN_SFT * (PIPES + 1));
localparam integer           SFT_WDT   = (MIN_SFT + (MIN_SFT_C < D_WIDTH));
localparam integer           PIPE_WDT  = (PIPES * SFT_WDT);
localparam [D_WIDTH-1:0]     VAL_0     = {D_WIDTH{1'b0}};

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
wire [D_WIDTH-1:0]           AmB_Re;
wire [D_WIDTH-1:0]           AmB_Im;
wire                         A_Re_msb;
wire                         B_Re_msb;
wire                         A_Im_msb;
wire                         B_Im_msb;

wire                         AmB_Re_msb = AmB_Re[D_WIDTH-1];
wire                         AmB_Im_msb = AmB_Im[D_WIDTH-1];
wire                         Co_Re_c    = (COUT & (UNSIGNED ^ Co_Re));
wire                         Co_Im_c    = (COUT & (UNSIGNED ^ Co_Im));

// -----------------------------------------------------------------------------
// Combinatorial Blocks
// -----------------------------------------------------------------------------
always @* begin
  if (SIGNED == "on") begin
    case({A_Re_msb, B_Re_msb})
      2'b00,
      2'b11: Co_Re = 1'b0;
      2'b01: Co_Re =  AmB_Re_msb;
      2'b10: Co_Re = ~AmB_Re_msb;
    endcase

    case({A_Im_msb, B_Im_msb})
      2'b00,
      2'b11: Co_Im = 1'b0;
      2'b01: Co_Im =  AmB_Im_msb;
      2'b10: Co_Im = ~AmB_Im_msb;
    endcase
  end
  else begin
    case({A_Re_msb, B_Re_msb})
      2'b00,
      2'b11: Co_Re = ~AmB_Re_msb;
      2'b01: Co_Re = 1'b0;
      2'b10: Co_Re = 1'b1;
    endcase

    case({A_Im_msb, B_Im_msb})
      2'b00,
      2'b11: Co_Im = ~AmB_Im_msb;
      2'b01: Co_Im = 1'b0;
      2'b10: Co_Im = 1'b1;
    endcase
  end
end

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
        A_Re  <= VAL_0;
        B_Re  <= VAL_0;
        A_Im  <= VAL_0;
        B_Im  <= VAL_0;
        Ci_Im <= 1'b0;
        Ci_Re <= 1'b0;
      end
      else if (clk_en_i) begin
        A_Re  <= data_a_re_i;
        B_Re  <= data_b_re_i;
        A_Im  <= ({D_WIDTH {CNUM}} & data_a_im_i);
        B_Im  <= ({D_WIDTH {CNUM}} & data_b_im_i);
        Ci_Im <= (CIN & CNUM & ~cin_im_i);
        Ci_Re <= (CIN &  ~cin_re_i);
      end
    end
  end  // U_I_REG_ON
  else begin : U_I_REG_OFF
    // --------------------
    // Combinatorial Input
    // --------------------
    always @* begin
      A_Re  = data_a_re_i;
      B_Re  = data_b_re_i;
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
    // Subtraction here happens as given below.
    // rst_i: All pipes initialized to All 0's
    // i is 0: Subtract raw inputs of Shift Width size
    // Subtract piped inputs of Shift Width size and accumulate with the
    // value from the previous pipe
    // -------------------------------------------------------------------------
    reg [D_WIDTH-1:0] A_Re_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] B_Re_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] A_Im_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] B_Im_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] AmB_Re_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] AmB_Im_pipe [PIPES-1:0];

    integer i;
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        for (i = 0 ; i < PIPES ; i = i + 1) begin
          A_Re_pipe[i]   <= VAL_0;
          B_Re_pipe[i]   <= VAL_0;
          A_Im_pipe[i]   <= VAL_0;
          B_Im_pipe[i]   <= VAL_0;
          AmB_Re_pipe[i] <= VAL_0;
          AmB_Im_pipe[i] <= VAL_0;
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
            AmB_Re_pipe[0] <= ( A_Re[SFT_WDT-1:0] -
                                B_Re[SFT_WDT-1:0] -
                               Ci_Re             );
            AmB_Im_pipe[0] <= ( A_Im[SFT_WDT-1:0] -
                                B_Im[SFT_WDT-1:0] -
                               Ci_Im             );
          end
          else begin
            AmB_Re_pipe[i] <= {AmB_Re_pipe[i-1]                         +
                               ((A_Re_pipe[i-1][(i*SFT_WDT) +: SFT_WDT] -
                                 B_Re_pipe[i-1][(i*SFT_WDT) +: SFT_WDT]
                                ) << (i*SFT_WDT))
                              };
            AmB_Im_pipe[i] <= {AmB_Im_pipe[i-1]                         +
                               ((A_Im_pipe[i-1][(i*SFT_WDT) +: SFT_WDT] -
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
    
    assign AmB_Re   = {AmB_Re_pipe[PIPES-1]                   +
                       ((A_Re_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT] -
                         B_Re_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT]
                        ) << PIPE_WDT)
                      };
    assign AmB_Im   = {AmB_Im_pipe[PIPES-1]                   +
                       ((A_Im_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT] -
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
    
    assign AmB_Re = {A_Re - B_Re - Ci_Re};
    assign AmB_Im = {A_Im - B_Im - Ci_Im};

  end  // U_PIPELINES_EQ_0
endgenerate

generate
  if (USE_OREG == "on") begin : U_O_REG_ON
    // ------------------
    // Sequential Output
    // ------------------
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        result_re_o <= VAL_0;
        result_im_o <= VAL_0;
        cout_re_o   <= UNSIGNED;
        cout_im_o   <= UNSIGNED;
      end
      else if (clk_en_i) begin
        result_re_o <= AmB_Re;
        result_im_o <= AmB_Im;
        cout_re_o   <= Co_Re_c;
        cout_im_o   <= Co_Im_c;
      end
    end
  end  // U_O_REG_ON
  else begin : U_O_REG_OFF
    // ---------------------
    // Combinatorial Output
    // ---------------------
    always @* begin
      result_re_o = AmB_Re;
      result_im_o = AmB_Im;
      cout_re_o   = Co_Re_c;
      cout_im_o   = Co_Im_c;
    end
  end  // U_O_REG_OFF
endgenerate

endmodule
//=============================================================================
// lscc_subtractor.v
//=============================================================================
`endif

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
// File                  : lscc_subtractor.v
// Title                 : 
// Dependencies          : 
// Description           : A two-input subtractor that performs signed/unsigned
//                       : subtraction of the data from inputs DataA and DataB
//                       : with an optional Cin borrow input. The output Result
//                       : carries the Difference of the subtraction operation
//                       : with an optional Cout borrow output.
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.1.0
// Author(s)             : 
// Mod. Date             : 
// Changes Made          : Removed registered input option.
// =============================================================================

`ifndef LSCC_SUBTRACTOR
`define LSCC_SUBTRACTOR

module lscc_subtractor #
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
localparam                   UNSIGNED  = (SIGNED == "on") ? 1'b0 : 1'b1;
localparam integer           MAX_PIPES = ((D_WIDTH - 1) >> (3 - PIPE_4BIT));
localparam integer           PIPES     = (PIPELINES > MAX_PIPES) ? MAX_PIPES : PIPELINES ;
localparam integer           MIN_SFT   = (D_WIDTH/(PIPES + 1));
localparam integer           MIN_SFT_C = (MIN_SFT * (PIPES + 1));
localparam integer           SFT_WDT   = (MIN_SFT + (MIN_SFT_C < D_WIDTH));
localparam integer           PIPE_WDT  = (PIPES * SFT_WDT);
localparam [D_WIDTH-1:0]     VAL_0     = {D_WIDTH{1'b0}};

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
wire [D_WIDTH-1:0]           AmB_Re;
wire [D_WIDTH-1:0]           AmB_Im;
wire                         A_Re_msb;
wire                         B_Re_msb;
wire                         A_Im_msb;
wire                         B_Im_msb;

wire                         AmB_Re_msb = AmB_Re[D_WIDTH-1];
wire                         AmB_Im_msb = AmB_Im[D_WIDTH-1];
wire                         Co_Re_c    = (COUT & (UNSIGNED ^ Co_Re));
wire                         Co_Im_c    = (COUT & (UNSIGNED ^ Co_Im));

// -----------------------------------------------------------------------------
// Combinatorial Blocks
// -----------------------------------------------------------------------------
always @* begin
  if (SIGNED == "on") begin
    case({A_Re_msb, B_Re_msb})
      2'b00,
      2'b11: Co_Re = 1'b0;
      2'b01: Co_Re =  AmB_Re_msb;
      2'b10: Co_Re = ~AmB_Re_msb;
    endcase

    case({A_Im_msb, B_Im_msb})
      2'b00,
      2'b11: Co_Im = 1'b0;
      2'b01: Co_Im =  AmB_Im_msb;
      2'b10: Co_Im = ~AmB_Im_msb;
    endcase
  end
  else begin
    case({A_Re_msb, B_Re_msb})
      2'b00,
      2'b11: Co_Re = ~AmB_Re_msb;
      2'b01: Co_Re = 1'b0;
      2'b10: Co_Re = 1'b1;
    endcase

    case({A_Im_msb, B_Im_msb})
      2'b00,
      2'b11: Co_Im = ~AmB_Im_msb;
      2'b01: Co_Im = 1'b0;
      2'b10: Co_Im = 1'b1;
    endcase
  end
end

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
        A_Re  <= VAL_0;
        B_Re  <= VAL_0;
        A_Im  <= VAL_0;
        B_Im  <= VAL_0;
        Ci_Im <= 1'b0;
        Ci_Re <= 1'b0;
      end
      else if (clk_en_i) begin
        A_Re  <= data_a_re_i;
        B_Re  <= data_b_re_i;
        A_Im  <= ({D_WIDTH {CNUM}} & data_a_im_i);
        B_Im  <= ({D_WIDTH {CNUM}} & data_b_im_i);
        Ci_Im <= (CIN & CNUM & ~cin_im_i);
        Ci_Re <= (CIN &  ~cin_re_i);
      end
    end
  end  // U_I_REG_ON
  else begin : U_I_REG_OFF
    // --------------------
    // Combinatorial Input
    // --------------------
    always @* begin
      A_Re  = data_a_re_i;
      B_Re  = data_b_re_i;
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
    // Subtraction here happens as given below.
    // rst_i: All pipes initialized to All 0's
    // i is 0: Subtract raw inputs of Shift Width size
    // Subtract piped inputs of Shift Width size and accumulate with the
    // value from the previous pipe
    // -------------------------------------------------------------------------
    reg [D_WIDTH-1:0] A_Re_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] B_Re_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] A_Im_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] B_Im_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] AmB_Re_pipe [PIPES-1:0];
    reg [D_WIDTH-1:0] AmB_Im_pipe [PIPES-1:0];

    integer i;
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        for (i = 0 ; i < PIPES ; i = i + 1) begin
          A_Re_pipe[i]   <= VAL_0;
          B_Re_pipe[i]   <= VAL_0;
          A_Im_pipe[i]   <= VAL_0;
          B_Im_pipe[i]   <= VAL_0;
          AmB_Re_pipe[i] <= VAL_0;
          AmB_Im_pipe[i] <= VAL_0;
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
            AmB_Re_pipe[0] <= ( A_Re[SFT_WDT-1:0] -
                                B_Re[SFT_WDT-1:0] -
                               Ci_Re             );
            AmB_Im_pipe[0] <= ( A_Im[SFT_WDT-1:0] -
                                B_Im[SFT_WDT-1:0] -
                               Ci_Im             );
          end
          else begin
            AmB_Re_pipe[i] <= {AmB_Re_pipe[i-1]                         +
                               ((A_Re_pipe[i-1][(i*SFT_WDT) +: SFT_WDT] -
                                 B_Re_pipe[i-1][(i*SFT_WDT) +: SFT_WDT]
                                ) << (i*SFT_WDT))
                              };
            AmB_Im_pipe[i] <= {AmB_Im_pipe[i-1]                         +
                               ((A_Im_pipe[i-1][(i*SFT_WDT) +: SFT_WDT] -
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
    
    assign AmB_Re   = {AmB_Re_pipe[PIPES-1]                   +
                       ((A_Re_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT] -
                         B_Re_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT]
                        ) << PIPE_WDT)
                      };
    assign AmB_Im   = {AmB_Im_pipe[PIPES-1]                   +
                       ((A_Im_pipe[PIPES-1][D_WIDTH-1:PIPE_WDT] -
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
    
    assign AmB_Re = {A_Re - B_Re - Ci_Re};
    assign AmB_Im = {A_Im - B_Im - Ci_Im};

  end  // U_PIPELINES_EQ_0
endgenerate

generate
  if (USE_OREG == "on") begin : U_O_REG_ON
    // ------------------
    // Sequential Output
    // ------------------
    always @ (posedge clk_i or posedge rst_i) begin
      if (rst_i) begin
        result_re_o <= VAL_0;
        result_im_o <= VAL_0;
        cout_re_o   <= UNSIGNED;
        cout_im_o   <= UNSIGNED;
      end
      else if (clk_en_i) begin
        result_re_o <= AmB_Re;
        result_im_o <= AmB_Im;
        cout_re_o   <= Co_Re_c;
        cout_im_o   <= Co_Im_c;
      end
    end
  end  // U_O_REG_ON
  else begin : U_O_REG_OFF
    // ---------------------
    // Combinatorial Output
    // ---------------------
    always @* begin
      result_re_o = AmB_Re;
      result_im_o = AmB_Im;
      cout_re_o   = Co_Re_c;
      cout_im_o   = Co_Im_c;
    end
  end  // U_O_REG_OFF
endgenerate

endmodule
//=============================================================================
// lscc_subtractor.v
//=============================================================================
`endif
