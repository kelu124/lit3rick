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
// Project               : Radiant Software 1.1
// File                  : lscc_rom.v
// Title                 :
// Dependencies          :
// Description           : Implements a ROM implementing EBR.
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0.0.
// Author(s)             :
// Mod. Date             :
// Changes Made          : Initial release.
// =============================================================================

`ifndef LSCC_ROM
`define LSCC_ROM
module lscc_rom #
(
    parameter    FAMILY            = "iCE40UP",
    parameter    RADDR_DEPTH       = 1024,
    parameter    RADDR_WIDTH       = clog2(RADDR_DEPTH),
    parameter    RDATA_WIDTH       = 18,
    parameter    REGMODE           = "reg",
    parameter    GSR               = "",
    parameter    RESETMODE         = "sync",
    parameter    INIT_FILE         = "none",
    parameter    INIT_FILE_FORMAT  = "binary",
    parameter    MODULE_TYPE       = "rom",
    parameter    INIT_MODE         = "none",
    parameter    PIPELINES         = 0,
    parameter    ECC_ENABLE        = 0,
    parameter    ASYNC_RST_RELEASE = "sync",
    parameter    OUTPUT_CLK_EN     = 0,
    parameter    MEM_SIZE          = "1024,18",
    parameter    MEM_ID            = "MEM0",
    parameter    INIT_VALUE_00     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_01     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_02     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_03     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_04     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_05     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_06     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_07     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_08     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_09     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0A     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0B     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0C     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0D     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0E     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0F     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_10     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_11     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_12     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_13     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_14     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_15     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_16     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_17     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_18     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_19     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1A     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1B     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1C     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1D     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1E     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1F     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_20     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_21     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_22     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_23     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_24     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_25     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_26     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_27     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_28     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_29     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2A     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2B     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2C     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2D     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2E     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2F     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_30     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_31     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_32     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_33     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_34     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_35     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_36     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_37     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_38     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_39     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3A     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3B     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3C     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3D     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3E     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3F     = "0x0000000000000000000000000000000000000000000000000000000000000000"
)
// -----------------------------------------------------------------------------
// Input/Output Ports
// -----------------------------------------------------------------------------
(
    input                     rd_clk_i,
    input                     rst_i,
    input                     rd_clk_en_i,
    input                     rd_out_clk_en_i,
    
    input                     rd_en_i,
    input [RADDR_WIDTH-1:0]   rd_addr_i,
    
    output [RDATA_WIDTH-1:0]  rd_data_o,

    output                    one_err_det_o,
    output                    two_err_det_o
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------

lscc_rom_inst # (
    .FAMILY            (FAMILY),
    .ADDR_DEPTH        (RADDR_DEPTH),
    .ADDR_WIDTH        (RADDR_WIDTH),
    .DATA_WIDTH        (RDATA_WIDTH),
    .REGMODE           (REGMODE),
    .RESETMODE         (RESETMODE),
    .INIT_FILE         (INIT_FILE),
    .INIT_FILE_FORMAT  (INIT_FILE_FORMAT),
    .INIT_MODE         (INIT_MODE),
    .BYTE_ENABLE       (0),
    .ASYNC_RST_RELEASE (ASYNC_RST_RELEASE),
    .OUTPUT_CLK_EN     (OUTPUT_CLK_EN),
    .OPTIMIZATION      ("speed"),
    .MEM_SIZE          (MEM_SIZE),
    .MEM_ID            (MEM_ID),
    .ECC_ENABLE        (ECC_ENABLE),
    .BYTE_WIDTH        (1),
    .INIT_VALUE_00     (INIT_VALUE_00),
    .INIT_VALUE_01     (INIT_VALUE_01),
    .INIT_VALUE_02     (INIT_VALUE_02),
    .INIT_VALUE_03     (INIT_VALUE_03),
    .INIT_VALUE_04     (INIT_VALUE_04),
    .INIT_VALUE_05     (INIT_VALUE_05),
    .INIT_VALUE_06     (INIT_VALUE_06),
    .INIT_VALUE_07     (INIT_VALUE_07),
    .INIT_VALUE_08     (INIT_VALUE_08),
    .INIT_VALUE_09     (INIT_VALUE_09),
    .INIT_VALUE_0A     (INIT_VALUE_0A),
    .INIT_VALUE_0B     (INIT_VALUE_0B),
    .INIT_VALUE_0C     (INIT_VALUE_0C),
    .INIT_VALUE_0D     (INIT_VALUE_0D),
    .INIT_VALUE_0E     (INIT_VALUE_0E),
    .INIT_VALUE_0F     (INIT_VALUE_0F),
    .INIT_VALUE_10     (INIT_VALUE_10),
    .INIT_VALUE_11     (INIT_VALUE_11),
    .INIT_VALUE_12     (INIT_VALUE_12),
    .INIT_VALUE_13     (INIT_VALUE_13),
    .INIT_VALUE_14     (INIT_VALUE_14),
    .INIT_VALUE_15     (INIT_VALUE_15),
    .INIT_VALUE_16     (INIT_VALUE_16),
    .INIT_VALUE_17     (INIT_VALUE_17),
    .INIT_VALUE_18     (INIT_VALUE_18),
    .INIT_VALUE_19     (INIT_VALUE_19),
    .INIT_VALUE_1A     (INIT_VALUE_1A),
    .INIT_VALUE_1B     (INIT_VALUE_1B),
    .INIT_VALUE_1C     (INIT_VALUE_1C),
    .INIT_VALUE_1D     (INIT_VALUE_1D),
    .INIT_VALUE_1E     (INIT_VALUE_1E),
    .INIT_VALUE_1F     (INIT_VALUE_1F),
    .INIT_VALUE_20     (INIT_VALUE_20),
    .INIT_VALUE_21     (INIT_VALUE_21),
    .INIT_VALUE_22     (INIT_VALUE_22),
    .INIT_VALUE_23     (INIT_VALUE_23),
    .INIT_VALUE_24     (INIT_VALUE_24),
    .INIT_VALUE_25     (INIT_VALUE_25),
    .INIT_VALUE_26     (INIT_VALUE_26),
    .INIT_VALUE_27     (INIT_VALUE_27),
    .INIT_VALUE_28     (INIT_VALUE_28),
    .INIT_VALUE_29     (INIT_VALUE_29),
    .INIT_VALUE_2A     (INIT_VALUE_2A),
    .INIT_VALUE_2B     (INIT_VALUE_2B),
    .INIT_VALUE_2C     (INIT_VALUE_2C),
    .INIT_VALUE_2D     (INIT_VALUE_2D),
    .INIT_VALUE_2E     (INIT_VALUE_2E),
    .INIT_VALUE_2F     (INIT_VALUE_2F),
    .INIT_VALUE_30     (INIT_VALUE_30),
    .INIT_VALUE_31     (INIT_VALUE_31),
    .INIT_VALUE_32     (INIT_VALUE_32),
    .INIT_VALUE_33     (INIT_VALUE_33),
    .INIT_VALUE_34     (INIT_VALUE_34),
    .INIT_VALUE_35     (INIT_VALUE_35),
    .INIT_VALUE_36     (INIT_VALUE_36),
    .INIT_VALUE_37     (INIT_VALUE_37),
    .INIT_VALUE_38     (INIT_VALUE_38),
    .INIT_VALUE_39     (INIT_VALUE_39),
    .INIT_VALUE_3A     (INIT_VALUE_3A),
    .INIT_VALUE_3B     (INIT_VALUE_3B),
    .INIT_VALUE_3C     (INIT_VALUE_3C),
    .INIT_VALUE_3D     (INIT_VALUE_3D),
    .INIT_VALUE_3E     (INIT_VALUE_3E),
    .INIT_VALUE_3F     (INIT_VALUE_3F)
) u_rom (
    .clk_i            (rd_clk_i),
    .rst_i            (rst_i),
    .clk_en_i         (rd_clk_en_i & rd_en_i),
    .rd_out_clk_en_i  (rd_out_clk_en_i),

    .wr_en_i          (1'b0),
    .wr_data_i        ({RDATA_WIDTH{1'b0}}),
    .addr_i           (rd_addr_i),
    .ben_i            (1'b1),

    .rd_data_o        (rd_data_o),

    .one_err_det_o    (one_err_det_o),
    .two_err_det_o    (two_err_det_o)
);

// -----------------------------------------------------------------------------
// Function Definition
// -----------------------------------------------------------------------------

function [31:0] clog2;
  input [31:0] value;
  reg   [31:0] num;
  begin
    num = value - 1;
    for (clog2=0; num>0; clog2=clog2+1) num = num>>1;
  end
endfunction

endmodule

//=============================================================================
// lscc_rom_inst.v
// Local Variables:
// verilog-library-directories: ("../../common")
// End:
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
// Project               : Radiant Software 1.1
// File                  : lscc_rom_inst.v
// Title                 :
// Dependencies          : 
// Description           : Implements a Single Port RAM using EBR.
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.1.0.
// Author(s)             :
// Mod. Date             :
// Changes Made          : Initial release.
// =============================================================================
`ifndef LSCC_ROM_INST
`define LSCC_ROM_INST

module lscc_rom_inst #
(
    parameter                _FCODE_LIFCL_      = 1,
    parameter                _FCODE_ICE_       = 2,
    parameter                _FCODE_COMMON_    = 0,
    parameter                FAMILY            = "LIFCL",
    parameter                FAMILY_CODE       = (FAMILY == "iCE40UP") ? _FCODE_ICE_ : ( FAMILY == "LIFCL") ? _FCODE_LIFCL_ 
                                                                                     : _FCODE_COMMON_,
    parameter                ADDR_DEPTH        = 1024,
    parameter                ADDR_WIDTH        = clog2(ADDR_DEPTH),
    parameter                DATA_WIDTH        = 18,
    parameter                REGMODE           = "reg",
    parameter                GSR               = "",
    parameter                RESETMODE         = "sync",
    parameter                INIT_FILE         = "none",
    parameter                INIT_FILE_FORMAT  = "binary",
    parameter                WRITE_MODE        = "normal",
    parameter                MODULE_TYPE       = "ram_dq",
    parameter                INIT_MODE         = "none",
    parameter                BYTE_ENABLE       = 0,
    parameter                BYTE_SIZE         = getByteSize(FAMILY_CODE, DATA_WIDTH),
    parameter                BYTE_WIDTH        = DATA_WIDTH/BYTE_SIZE,
    parameter                PIPELINES         = 0,
    parameter                ASYNC_RST_RELEASE = "sync",
    parameter                ECC_ENABLE        = 0,
    parameter                OUTPUT_CLK_EN     = 0,
    parameter                BYTE_ENABLE_POL   = "active-high",
    parameter                OPTIMIZATION      = "speed", // unused
    parameter                MEM_SIZE          = "18,1024",
    parameter                MEM_ID            = "MEM0",
    parameter                INIT_VALUE_00     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_01     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_02     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_03     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_04     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_05     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_06     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_07     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_08     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_09     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_0A     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_0B     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_0C     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_0D     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_0E     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_0F     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_10     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_11     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_12     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_13     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_14     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_15     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_16     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_17     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_18     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_19     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_1A     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_1B     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_1C     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_1D     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_1E     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_1F     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_20     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_21     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_22     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_23     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_24     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_25     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_26     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_27     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_28     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_29     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_2A     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_2B     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_2C     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_2D     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_2E     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_2F     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_30     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_31     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_32     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_33     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_34     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_35     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_36     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_37     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_38     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_39     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_3A     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_3B     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_3C     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_3D     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_3E     = "0x0000000000000000000000000000000000000000000000000000000000000000",
    parameter                INIT_VALUE_3F     = "0x0000000000000000000000000000000000000000000000000000000000000000"
)
// -----------------------------------------------------------------------------
// Input/Output Ports
// -----------------------------------------------------------------------------
(
    input                   clk_i,
    input                   rst_i,
    input                   clk_en_i,
    input                   rd_out_clk_en_i,
    
    input                   wr_en_i,
    input [DATA_WIDTH-1:0]  wr_data_i,
    input [ADDR_WIDTH-1:0]  addr_i,
    input [BYTE_WIDTH-1:0]  ben_i,
    
    output [DATA_WIDTH-1:0] rd_data_o,

    output                  one_err_det_o,
    output                  two_err_det_o
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
localparam IS_BYTE_ENABLE = (BYTE_ENABLE == 0) ? 1'b0 : ((DATA_WIDTH > BYTE_SIZE) && (DATA_WIDTH%BYTE_SIZE == 0)) ? 1'b1 : 1'b0;
localparam STRING_LENGTH = (FAMILY == "iCE40UP") ? 66 : 82;

// -----------------------------------------------------------------------------
// Generate IP Wiring and Instance
// -----------------------------------------------------------------------------
genvar i0, i1;
generate
    if(FAMILY_CODE != _FCODE_COMMON_) begin : PRIM_MODE
        localparam DATA_WIDTH_IMPL = getMinDataWidth(FAMILY_CODE, DATA_WIDTH, ADDR_DEPTH, IS_BYTE_ENABLE);
        localparam ADDR_DEPTH_IMPL = data_to_addr(FAMILY_CODE, DATA_WIDTH_IMPL);
        localparam ADDR_WIDTH_IMPL = clog2(ADDR_DEPTH_IMPL);
        localparam BYTE_WIDTH_IMPL = BYTE_ENABLE == 0 ? 1 : getByteImpl(FAMILY_CODE, DATA_WIDTH_IMPL);
        localparam T_BYTE_EN = (IS_BYTE_ENABLE == 1) && (DATA_WIDTH_IMPL >= 8); 
        localparam EBR_ADDR = roundUP(ADDR_DEPTH, ADDR_DEPTH_IMPL);
        localparam EBR_DATA = roundUP(DATA_WIDTH, DATA_WIDTH_IMPL);
        
        wire [DATA_WIDTH-1:0] rd_data_raw_w [EBR_ADDR-1:0];
        
        for(i0 = 0; i0 < EBR_ADDR; i0 = i0 + 1) begin : xADDR
            wire [DATA_WIDTH-1:0] raw_output_w;
            assign rd_data_raw_w[i0] = raw_output_w;
            wire chk_addr_w;
            wire [ADDR_WIDTH_IMPL-1:0] true_addr_w;
            if(EBR_ADDR > 1) begin
                assign chk_addr_w = (addr_i[ADDR_WIDTH-1:ADDR_WIDTH_IMPL] == i0);
                assign true_addr_w = addr_i[ADDR_WIDTH_IMPL-1:0];
            end
            else begin
                assign chk_addr_w = 1'b1;
                assign true_addr_w[ADDR_WIDTH-1:0] = addr_i;
                if(ADDR_WIDTH_IMPL > ADDR_WIDTH) begin
                    assign true_addr_w[ADDR_WIDTH_IMPL-1:ADDR_WIDTH] = 'h0;
                end
            end

            for(i1 = 0; i1 < EBR_DATA; i1 = i1+1) begin : xDATA
                localparam ECO_POSX = i1 * DATA_WIDTH_IMPL;
                localparam ECO_POSY = i0 * ADDR_DEPTH_IMPL;

                wire [DATA_WIDTH_IMPL-1:0] wr_data_act_w;
                wire [DATA_WIDTH_IMPL-1:0] rd_data_act_w;
                wire [BYTE_WIDTH_IMPL-1:0] ben_act_w;

                if((i1+1)*DATA_WIDTH_IMPL <= DATA_WIDTH) begin
                    assign wr_data_act_w = wr_data_i[(i1+1)*DATA_WIDTH_IMPL-1:i1*DATA_WIDTH_IMPL];
                    assign raw_output_w[(i1+1)*DATA_WIDTH_IMPL-1:i1*DATA_WIDTH_IMPL] = rd_data_act_w;
                end
                else begin
                    assign wr_data_act_w[DATA_WIDTH-(1+i1*DATA_WIDTH_IMPL):0] = wr_data_i[DATA_WIDTH-1:i1*DATA_WIDTH_IMPL];
                    assign wr_data_act_w[DATA_WIDTH_IMPL-1:DATA_WIDTH-(i1*DATA_WIDTH_IMPL)] = {(DATA_WIDTH_IMPL-(DATA_WIDTH-(i1*DATA_WIDTH_IMPL))){1'b0}};
                    assign raw_output_w[DATA_WIDTH-1:i1*DATA_WIDTH_IMPL] = rd_data_act_w[DATA_WIDTH-(1+i1*DATA_WIDTH_IMPL):0];
                end
                if(IS_BYTE_ENABLE == 1'b1) begin
                    if(DATA_WIDTH_IMPL >= 8) begin
                        if(BYTE_WIDTH_IMPL > 1) begin
                            if((i1+1)*BYTE_WIDTH_IMPL <= BYTE_WIDTH) begin
                                assign ben_act_w = ben_i[(i1+1)*BYTE_WIDTH_IMPL-1:i1*BYTE_WIDTH_IMPL];
                            end
                            else begin
                                assign ben_act_w[BYTE_WIDTH-(1+i1*BYTE_WIDTH_IMPL):0] = ben_i[BYTE_WIDTH-1:i1*BYTE_WIDTH_IMPL];
                                assign ben_act_w[BYTE_WIDTH_IMPL-1:BYTE_WIDTH-(i1*BYTE_WIDTH_IMPL)] = {(BYTE_WIDTH_IMPL-(BYTE_WIDTH-(i1*BYTE_WIDTH_IMPL))){1'b1}};
                            end
                        end
                        else begin
                            assign ben_act_w = ben_i[i1];
                        end
                    end
                    else begin
                        assign ben_act_w = ben_i[i1*DATA_WIDTH_IMPL*BYTE_WIDTH/DATA_WIDTH];
                    end
                end
                else begin
                    assign ben_act_w = {BYTE_WIDTH_IMPL{1'b1}};
                end
                
                if(INIT_MODE == "mem_file") begin : mem_file
                    lscc_rom_inst_core # (
                        .FAMILY(FAMILY),
                        .DATA_WIDTH(DATA_WIDTH_IMPL),
                        .OUTREG(REGMODE),
                        .RESETMODE(RESETMODE),
                        .GSR(GSR),
                        .CSCDECODE(0),
                        .ASYNC_RST_RELEASE(ASYNC_RST_RELEASE),
                        .BYTE_ENABLE(BYTE_ENABLE),
                        .INIT_MODE(INIT_MODE),
                        .OUTPUT_CLK_EN(OUTPUT_CLK_EN),
                        .BYTE_ENABLE_POL(BYTE_ENABLE_POL),
                        .MEM_SIZE(MEM_SIZE),
                        .MEM_ID(MEM_ID),
                        .POSx(ECO_POSX),
                        .POSy(ECO_POSY),
                        .INIT_VALUE_00(INIT_VALUE_00[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_01(INIT_VALUE_01[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_02(INIT_VALUE_02[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_03(INIT_VALUE_03[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_04(INIT_VALUE_04[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_05(INIT_VALUE_05[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_06(INIT_VALUE_06[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_07(INIT_VALUE_07[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_08(INIT_VALUE_08[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_09(INIT_VALUE_09[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_0A(INIT_VALUE_0A[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_0B(INIT_VALUE_0B[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_0C(INIT_VALUE_0C[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_0D(INIT_VALUE_0D[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_0E(INIT_VALUE_0E[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_0F(INIT_VALUE_0F[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8]),
                        .INIT_VALUE_10(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_10[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_11(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_11[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_12(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_12[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_13(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_13[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_14(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_14[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_15(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_15[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_16(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_16[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_17(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_17[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_18(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_18[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_19(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_19[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_1A(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_1A[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_1B(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_1B[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_1C(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_1C[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_1D(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_1D[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_1E(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_1E[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_1F(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_1F[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_20(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_20[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_21(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_21[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_22(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_22[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_23(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_23[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_24(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_24[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_25(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_25[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_26(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_26[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_27(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_27[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_28(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_28[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_29(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_29[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_2A(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_2A[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_2B(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_2B[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_2C(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_2C[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_2D(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_2D[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_2E(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_2E[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_2F(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_2F[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_30(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_30[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_31(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_31[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_32(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_32[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_33(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_33[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_34(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_34[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_35(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_35[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_36(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_36[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_37(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_37[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_38(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_38[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_39(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_39[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_3A(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_3A[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_3B(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_3B[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_3C(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_3C[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_3D(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_3D[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_3E(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_3E[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00"),
                        .INIT_VALUE_3F(checkINIT(FAMILY_CODE) == 1 ? INIT_VALUE_3F[(i0*EBR_DATA+i1+1)*STRING_LENGTH*8-1:(i0*EBR_DATA+i1)*STRING_LENGTH*8] : "0x00")
                    ) mem0 (
                        .clk_i(clk_i),
                        .rst_i(rst_i),
                        .clk_en_i(clk_en_i),
                        .rd_out_clk_en_i(rd_out_clk_en_i),
                        .wr_en_i(wr_en_i & chk_addr_w),
                        .wr_data_i(wr_data_act_w),
                        .addr_i(true_addr_w),
                        .ben_i(ben_act_w),
                        .rd_data_o(rd_data_act_w)
                    );
                end
                else begin : no_mem_file
                    lscc_rom_inst_core # (
                        .FAMILY(FAMILY),
                        .DATA_WIDTH(DATA_WIDTH_IMPL),
                        .OUTREG(REGMODE),
                        .RESETMODE(RESETMODE),
                        .GSR(GSR),
                        .CSCDECODE(0),
                        .ASYNC_RST_RELEASE(ASYNC_RST_RELEASE),
                        .BYTE_ENABLE(BYTE_ENABLE),
                        .INIT_MODE(INIT_MODE),
                        .OUTPUT_CLK_EN(OUTPUT_CLK_EN),
                        .BYTE_ENABLE_POL(BYTE_ENABLE_POL),
                        .MEM_SIZE(MEM_SIZE),
                        .MEM_ID(MEM_ID),
                        .POSx(ECO_POSX),
                        .POSy(ECO_POSY)
                    ) mem0 (
                        .clk_i(clk_i),
                        .rst_i(rst_i),
                        .clk_en_i(clk_en_i),
                        .rd_out_clk_en_i(rd_out_clk_en_i),
                        .wr_en_i(wr_en_i & chk_addr_w),
                        .wr_data_i(wr_data_act_w),
                        .addr_i(true_addr_w),
                        .ben_i(ben_act_w),
                        .rd_data_o(rd_data_act_w)
                    );
                end
            end
        end
        if(EBR_ADDR == 1) begin : EBR_sing
            assign rd_data_o = rd_data_raw_w[0];
        end
        else begin : EBR_mult
            reg [DATA_WIDTH-1:0] reg_buff_r;
            reg [ADDR_WIDTH-1:0] addr_r_0;
            reg [ADDR_WIDTH-1:0] addr_r_1;
        
            // synthesis translate_off
            initial begin
                addr_r_0 = {ADDR_WIDTH{1'b0}};
                addr_r_1 = {ADDR_WIDTH{1'b0}};
                reg_buff_r = {DATA_WIDTH{1'b0}};
            end
            // synthesis translate_on
        
            assign rd_data_o = reg_buff_r;
        
            if(REGMODE == "noreg") begin : _nreg
                if(RESETMODE == "sync") begin : _sync
                    always @ (posedge clk_i) begin
                        if(rst_i) begin
                            addr_r_1 <= {ADDR_WIDTH{1'b0}};
                        end
                        else begin
                            addr_r_1 <= addr_i;
                        end
                    end
                end
                else begin : _async
                    always @ (posedge clk_i, posedge rst_i) begin
                        if(rst_i) begin
                            addr_r_1 <= {ADDR_WIDTH{1'b0}};
                        end
                        else begin
                            addr_r_1 <= addr_i;
                        end
                    end
                end
            end
            else begin : _reg
                if(RESETMODE == "sync") begin : _sync
                    always @ (posedge clk_i) begin
                        if(rst_i) begin
                            addr_r_0 <= {ADDR_WIDTH{1'b0}};
                            addr_r_1 <= {ADDR_WIDTH{1'b0}};
                        end
                        else begin
                            addr_r_0 <= addr_i;
                            addr_r_1 <= addr_r_0;
                        end
                    end
                end
                else begin : _async
                    always @ (posedge clk_i, posedge rst_i) begin
                        if(rst_i) begin
                            addr_r_0 <= {ADDR_WIDTH{1'b0}};
                            addr_r_1 <= {ADDR_WIDTH{1'b0}};
                        end
                        else begin
                            addr_r_0 <= addr_i;
                            addr_r_1 <= addr_r_0;
                        end
                    end
                end
            end
            wire [ADDR_WIDTH-(1+ADDR_WIDTH_IMPL):0] m = addr_r_1[ADDR_WIDTH-1:ADDR_WIDTH_IMPL];
            always @ * begin
                reg_buff_r = rd_data_raw_w[m];
            end
        end
    end
    else begin : BEHV_MODE
        reg [DATA_WIDTH-1:0] dataout_reg;
        reg [DATA_WIDTH-1:0] dataout_reg_buffer;
        reg [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0] /* sythesis syn_ramstyle="block_ram" */;
        
        initial begin
            if((INIT_MODE == "mem_file" && INIT_FILE != "none") || INIT_MODE == "all_one" || INIT_MODE == "all_zero") begin
                if(INIT_FILE_FORMAT == "hex") $readmemh(INIT_FILE, mem, 0, ADDR_DEPTH-1);
                else $readmemb(INIT_FILE, mem, 0, ADDR_DEPTH-1);
            end
        end
        
        assign rd_data_o = (REGMODE == "reg") ? dataout_reg : dataout_reg_buffer;
        
        always @ (posedge clk_i) begin
            if(clk_en_i == 1'b1) begin
                if(wr_en_i == 1'b1) mem[addr_i] <= wr_data_i;
                else dataout_reg_buffer <= mem[addr_i];
            end
        end
        
        if(REGMODE == "reg") begin
            if(RESETMODE == "sync") begin
                always @ (posedge clk_i) begin
                    if(rst_i == 1'b1) dataout_reg <= 'h0;
                    else if(rd_out_clk_en_i == 1'b1 && wr_en_i == 1'b0) dataout_reg <= dataout_reg_buffer;
                end
            end
            else if(ASYNC_RST_RELEASE == "sync") begin
                always @ (posedge clk_i, posedge rst_i) begin
                    if(rst_i == 1'b1) dataout_reg <= 'h0;
                    else if(rd_out_clk_en_i == 1'b1 && wr_en_i == 1'b0) dataout_reg <= dataout_reg_buffer;
                end
            end
            else begin
                always @ * begin
                    if(rst_i == 1'b1) dataout_reg = 'h0;
                    else if(rd_out_clk_en_i == 1'b1 && wr_en_i == 1'b0) dataout_reg = dataout_reg_buffer;
                end
            end
        end
    end
endgenerate

function [31:0] getByteImpl;
    input [10:0] family_code;
    input [31:0] data_width_impl;
    begin
        case(family_code)
            _FCODE_ICE_:    begin
                    case(data_width_impl)
                        8: getByteImpl = 1;
                        16: getByteImpl = 2;
                        default: getByteImpl = 1;
                    endcase
                end
            _FCODE_LIFCL_:    begin
                    case(data_width_impl)
                        8: getByteImpl = 1;
                        9: getByteImpl = 1;
                        16: getByteImpl = 2;
                        18: getByteImpl = 2;
                        default: getByteImpl = 1;
                    endcase
                end
            default: getByteImpl = 1;
        endcase
    end
endfunction

function [31:0] data_to_addr;
    input [10:0] family_code;
    input [31:0] data_width;
    begin
        case(family_code)
            _FCODE_ICE_:    begin
                case(data_width)
                    16:    data_to_addr = 256;
                    8:    data_to_addr = 512;
                    4:    data_to_addr = 1024;
                    2:    data_to_addr = 2048;
                endcase
                end
            _FCODE_LIFCL_:    begin
                case(data_width)
                    18:    data_to_addr = 1024;
                    16:    data_to_addr = 1024;
                    9:    data_to_addr = 2048;
                    8:    data_to_addr = 2048;
                    4:    data_to_addr = 4096;
                    2:    data_to_addr = 8192;
                    1:    data_to_addr = 16384;
                endcase
                end
        endcase
    end
endfunction

function [31:0] getMinDataWidth;
    input [10:0] family_code;
    input [31:0] dwidth;
    input [31:0] adepth;
    input is_byte_enable;
    reg [31:0] impl_x18, impl_x16, impl_x9, impl_x8, impl_x4, impl_x2, impl_x1;
    begin
        case(family_code)
            _FCODE_ICE_: begin
                impl_x16 = EBR_impl(adepth, dwidth, 256, 16);
                impl_x8 = EBR_impl(adepth, dwidth, 512, 8);
                impl_x4 = EBR_impl(adepth, dwidth, 1024, 4);
                impl_x2 = EBR_impl(adepth, dwidth, 2048, 2);
                if(impl_x16 < impl_x8)
                    if(impl_x16 < impl_x4)
                        if(impl_x16 < impl_x2) getMinDataWidth = 16;
                        else getMinDataWidth = 2;
                    else
                        if(impl_x4 < impl_x2) getMinDataWidth = 4;
                        else getMinDataWidth = 2;
                else
                    if(impl_x8 < impl_x4)
                        if(impl_x8 < impl_x2) getMinDataWidth = 8;
                        else getMinDataWidth = 2;
                    else
                        if(impl_x4 < impl_x2) getMinDataWidth = 4;
                        else getMinDataWidth = 2;
            end
            _FCODE_LIFCL_: begin
                impl_x18 = EBR_impl(adepth, dwidth, 1024, 18);
                impl_x16 = EBR_impl(adepth, dwidth, 1024, 16);
                impl_x9 =  EBR_impl(adepth, dwidth, 2048, 9);
                impl_x8 =  EBR_impl(adepth, dwidth, 2048, 8);
                impl_x4 =  EBR_impl(adepth, dwidth, 4096, 4);
                impl_x2 =  EBR_impl(adepth, dwidth, 8192, 2);
                impl_x1 =  EBR_impl(adepth, dwidth, 16384, 1);
                if((is_byte_enable==1'b1) && (dwidth%9!=0)) begin
                    if(impl_x16 < impl_x8)
                        if(impl_x16 < impl_x4)
                            if(impl_x16 < impl_x2) 
                                if(impl_x16 < impl_x1) getMinDataWidth = 16;
                                else getMinDataWidth = 1;
                            else
                                if(impl_x2 < impl_x1) getMinDataWidth = 2;
                                else getMinDataWidth = 1;
                        else
                            if(impl_x4 < impl_x2) 
                                if(impl_x4 < impl_x1) getMinDataWidth = 4;
                                else getMinDataWidth = 1;
                            else
                                if(impl_x2 < impl_x1) getMinDataWidth = 2;
                                else getMinDataWidth = 1;
                    else
                        if(impl_x8 < impl_x4)
                            if(impl_x8 < impl_x2) 
                                if(impl_x8 < impl_x1) getMinDataWidth = 8;
                                else getMinDataWidth = 1;
                            else
                                if(impl_x2 < impl_x1) getMinDataWidth = 2;
                                else getMinDataWidth = 1;
                        else
                            if(impl_x4 < impl_x2) 
                                if(impl_x4 < impl_x1) getMinDataWidth = 4;
                                else getMinDataWidth = 1;
                            else
                                if(impl_x2 < impl_x1) getMinDataWidth = 2;
                                else getMinDataWidth = 1;
                end
                else begin
                    if(impl_x18 < impl_x9)
                        if(impl_x18 < impl_x4)
                            if(impl_x18 < impl_x2) 
                                if(impl_x18 < impl_x1) getMinDataWidth = 18;
                                else getMinDataWidth = 1;
                            else
                                if(impl_x2 < impl_x1) getMinDataWidth = 2;
                                else getMinDataWidth = 1;
                        else
                            if(impl_x4 < impl_x2) 
                                if(impl_x4 < impl_x1) getMinDataWidth = 4;
                                else getMinDataWidth = 1;
                            else
                                if(impl_x2 < impl_x1) getMinDataWidth = 2;
                                else getMinDataWidth = 1;
                    else
                        if(impl_x9 < impl_x4)
                            if(impl_x9 < impl_x2) 
                                if(impl_x9 < impl_x1) getMinDataWidth = 9;
                                else getMinDataWidth = 1;
                            else
                                if(impl_x2 < impl_x1) getMinDataWidth = 2;
                                else getMinDataWidth = 1;
                        else
                            if(impl_x4 < impl_x2) 
                                if(impl_x4 < impl_x1) getMinDataWidth = 4;
                                else getMinDataWidth = 1;
                            else
                                if(impl_x2 < impl_x1) getMinDataWidth = 2;
                                else getMinDataWidth = 1;
                end
            end
        endcase
    end
endfunction

function [31:0] EBR_impl;
    input [31:0] DEPTH_IMPL;
    input [31:0] WIDTH_IMPL;
    input [31:0] ADDR_DEPTH_X;
    input [31:0] DATA_WIDTH_X;
    begin
        EBR_impl = roundUP(DEPTH_IMPL, ADDR_DEPTH_X)*roundUP(WIDTH_IMPL, DATA_WIDTH_X);
    end
endfunction

function [9:0] getByteSize;
    input [31:0] family_code;
    input [31:0] dwidth_impl;
    begin
        if(family_code == _FCODE_ICE_) begin
            getByteSize = 8;
        end
        else if(family_code == _FCODE_LIFCL_) begin
            if(dwidth_impl % 9 == 0) getByteSize = 9;
            else getByteSize = 8;
        end
        else begin
            getByteSize = 8;
        end
    end
endfunction

function [31:0] roundUP;
    input [31:0] dividend;
    input [31:0] divisor;
    begin
        if(divisor == 1) begin
            roundUP = dividend;
        end
        else if(dividend <= divisor) begin
            roundUP = 1;
        end
        else begin
            roundUP = dividend/divisor + (((dividend % divisor) == 0) ? 0 : 1);
        end
    end
endfunction

function checkINIT;
    input [31:0] dev_code;
    begin
        case(dev_code)
            _FCODE_LIFCL_: checkINIT = 1;
            default:      checkINIT = 0;
        endcase
    end
endfunction

function [31:0] clog2;
  input [31:0] value;
  reg   [31:0] num;
  begin
    num = value - 1;
    for (clog2=0; num>0; clog2=clog2+1) num = num>>1;
  end
endfunction

endmodule
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
// Project               : LIFCL, iCE40 UltraPlus
// File                  : lscc_rom_inst_core.v
// Title                 :
// Dependencies          : 
// Description           : Implements a single EBR (Embedded Block RAM) block.
//                       : Can support registered and unregistered outputs.
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0.0.
// Author(s)             :
// Mod. Date             :
// Changes Made          : Initial release.
// =============================================================================

`ifndef LSCC_ROM_INST_CORE
`define LSCC_ROM_INST_CORE

module lscc_rom_inst_core # (
    parameter    _FCODE_LIFCL_      = 1,
    parameter    _FCODE_ICE_        = 2,
    parameter    _FCODE_COMMON_     = 0,
    parameter    FAMILY             = "common",
    parameter    FAMILY_CODE        = (FAMILY == "iCE40UP") ? _FCODE_ICE_ : ( FAMILY == "LIFCL") ? _FCODE_LIFCL_ 
                                                                          : _FCODE_COMMON_,
    parameter    DATA_WIDTH         = 16,
    parameter    ADDR_WIDTH         = getAddrWidth(DATA_WIDTH, FAMILY_CODE),
    parameter    OUTREG             = "noreg",
    parameter    RESETMODE          = "sync",
    parameter    GSR                = "ENABLED",
    parameter    CSCDECODE          = 0,
    parameter    ASYNC_RST_RELEASE  = "sync",
    parameter    BYTE_ENABLE        = 0,
    parameter    BYTE_WIDTH         = ((BYTE_ENABLE == 1) ? getByteWidth(DATA_WIDTH, FAMILY_CODE) : 1),
    parameter    INIT_MODE          = "none",
    parameter    OUTPUT_CLK_EN      = 0,
    parameter    BYTE_ENABLE_POL    = "active-high",
    parameter    POSx               = 0,
    parameter    POSy               = 0,
    parameter    STRING_SIZE        = calculateStringSize(POSx,POSy),
    parameter    MEM_SIZE           = "18,1024",
    parameter    MEM_ID             = "MEM0",
    parameter    INIT_VALUE_00      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_01      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_02      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_03      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_04      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_05      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_06      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_07      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_08      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_09      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0A      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0B      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0C      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0D      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0E      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_0F      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_10      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_11      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_12      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_13      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_14      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_15      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_16      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_17      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_18      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_19      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1A      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1B      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1C      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1D      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1E      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_1F      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_20      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_21      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_22      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_23      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_24      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_25      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_26      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_27      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_28      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_29      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2A      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2B      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2C      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2D      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2E      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_2F      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_30      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_31      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_32      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_33      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_34      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_35      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_36      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_37      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_38      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_39      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3A      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3B      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3C      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3D      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3E      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000",
    parameter    INIT_VALUE_3F      = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000"
)(
    input                   clk_i,
    input                   rst_i,
    input                   clk_en_i,
    input                   rd_out_clk_en_i,
    
    input                   wr_en_i,
    input [DATA_WIDTH-1:0]  wr_data_i,
    input [ADDR_WIDTH-1:0]  addr_i,
    input [BYTE_WIDTH-1:0]  ben_i,
    
    output [DATA_WIDTH-1:0] rd_data_o
);

// -----------------------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------------------
localparam        POS_X0     = POSx % 10;
localparam        POS_X1     = (POSx/10) % 10;
localparam        POS_X2     = (POSx/100) % 10;
localparam        POS_X3     = (POSx/1000) % 10;
localparam        POS_X4     = (POSx/10000) % 10;
localparam        POS_X5     = (POSx/100000) % 10;
localparam        POS_X6     = (POSx/1000000) % 10;
localparam        POS_X7     = (POSx/10000000) % 10;

localparam        POS_Y0     = POSy % 10;
localparam        POS_Y1     = (POSy/10) % 10;
localparam        POS_Y2     = (POSy/100) % 10;
localparam        POS_Y3     = (POSy/1000) % 10; 
localparam        POS_Y4     = (POSy/10000) % 10;
localparam        POS_Y5     = (POSy/100000) % 10;
localparam        POS_Y6     = (POSy/1000000) % 10;
localparam        POS_Y7     = (POSy/10000000) % 10;

localparam [79:0] NUM_STRING = "9876543210";
localparam        BLOCK_POS  = getStringFromPos(POSx, POSy);
localparam        BLOCK_SIZE = DATA_WIDTH == 36 ? "[36,512]" : 
                               DATA_WIDTH == 32 ? "[32,512]" :
                               DATA_WIDTH == 18 ? "[18,1024]" :
                               DATA_WIDTH == 16 ? "[16,1024]" :
                               DATA_WIDTH == 9 ? "[9,2048]" :
                               DATA_WIDTH == 8 ? "[8,2048]" :
                               DATA_WIDTH == 4 ? "[4,4096]" :
                               DATA_WIDTH == 2 ? "[2,8192]" : "[1,16384]";

genvar i0;
generate
    if(FAMILY_CODE == _FCODE_LIFCL_) begin : LIFCL
        localparam DW = (DATA_WIDTH == 18 || DATA_WIDTH == 16) ? "X18" : (DATA_WIDTH == 9 || DATA_WIDTH == 8) ? "X9" : (DATA_WIDTH == 4) ? "X4" : (DATA_WIDTH == 2) ? "X2" : "X1";
        localparam CSC = (CSCDECODE == 0) ? "000" : (CSCDECODE == 1) ? "001" : (CSCDECODE == 2) ? "010" : (CSCDECODE == 3) ? "011" : (CSCDECODE == 4) ? "100" : (CSCDECODE == 5) ? "101" : (CSCDECODE == 6) ? "110" : "111";

        wire [13:0] true_addr;
        wire [17:0] true_din;
        wire [17:0] true_dout;
        wire [DATA_WIDTH-1:0] rd_data_w;

        if(OUTREG == "noreg" || OUTPUT_CLK_EN == 0) begin
            assign rd_data_o = rd_data_w;
        end
        else begin
            reg [DATA_WIDTH-1:0] rd_data_r = {DATA_WIDTH{1'b0}};
            if(RESETMODE == "sync") begin
                always @ (posedge clk_i) begin
                    if(rst_i == 1'b1) begin
                        rd_data_r <= {DATA_WIDTH{1'b0}};
                    end
                    else if(rd_out_clk_en_i == 1'b1) begin
                        rd_data_r <= rd_data_w;
                    end
                end
            end
            else begin
                always @ (posedge clk_i, posedge rst_i) begin
                    if(rst_i == 1'b1) begin
                        rd_data_r <= {DATA_WIDTH{1'b0}};
                    end
                    else if(rd_out_clk_en_i == 1'b1) begin
                        rd_data_r <= rd_data_w;
                    end
                end
            end
            assign rd_data_o = rd_data_r;
        end
        
        if(DATA_WIDTH == 18 || DATA_WIDTH == 16) begin
            assign true_addr[13:4] = addr_i;
            assign true_addr[3:2] = 2'b11;
            assign true_addr[1:0] = (BYTE_ENABLE == 1) ? ben_i : 2'b11;
            if(DATA_WIDTH == 18) begin
                assign true_din = wr_data_i;
                assign rd_data_w = true_dout;
            end
            else begin
                assign true_din[16:9] = wr_data_i[15:8];
                assign true_din[17] = 1'b0;
                assign true_din[8] = 1'b0;
                assign true_din[7:0] = wr_data_i[7:0];
                assign rd_data_w[15:8] = true_dout[16:9];
                assign rd_data_w[7:0] = true_dout[7:0];
            end
        end
        else begin
            assign true_addr[13:13-(ADDR_WIDTH-1)] = addr_i[ADDR_WIDTH-1:0];
            if(ADDR_WIDTH < 14) begin
                assign true_addr[13-ADDR_WIDTH:0] = {(14-ADDR_WIDTH){1'b1}};
            end
            assign true_din[17:DATA_WIDTH] = {(18-DATA_WIDTH){1'b0}};
            assign true_din[DATA_WIDTH-1:0] = wr_data_i;
            assign rd_data_w = true_dout[DATA_WIDTH-1:0];
        end

        wire t_wr_en_i = (BYTE_ENABLE == 0 || DATA_WIDTH >= 16) ? wr_en_i : wr_en_i & ben_i[0];
        wire t_clk_en_w = clk_en_i | rst_i;

        wire [17:0] DI = true_din;
        wire [13:0] AD = true_addr;
        wire CLK = clk_i;
        wire WE = t_wr_en_i & ~rst_i;
        wire CE = clk_en_i;
        wire RST = rst_i;
        wire [2:0] CS = {t_clk_en_w, t_clk_en_w, t_clk_en_w};
        wire [17:0] DO;
        assign true_dout = DO;

        localparam MEM_TYPE = "EBR";
        localparam T_MEM_SIZE = {"[",MEM_SIZE,"]"};

        (* ECO_MEM_TYPE=MEM_TYPE, ECO_MEM_ID=MEM_ID, ECO_MEM_SIZE=T_MEM_SIZE, ECO_MEM_BLOCK_SIZE=BLOCK_SIZE, ECO_MEM_BLOCK_POS=BLOCK_POS *) SP16K sp16k (
            .DI (DI),
            .AD (AD),
            .CLK(CLK),
            .CE (CE),
            .WE (WE),
            .CS (CS),
            .RST(RST),
            .DO (DO)
        );

        defparam sp16k.DATA_WIDTH = DW;
        defparam sp16k.CSDECODE = CSC;
        defparam sp16k.OUTREG = (OUTREG == "reg") ? (OUTPUT_CLK_EN == 0) ? "USED" : "BYPASSED" : "BYPASSED";
        defparam sp16k.RESETMODE = (RESETMODE == "sync") ? "SYNC" : "ASYNC";
        defparam sp16k.ASYNC_RST_RELEASE = (ASYNC_RST_RELEASE == "sync") ? "SYNC" : "ASYNC";
        defparam sp16k.INIT_DATA  = "DYNAMIC";

        defparam sp16k.INITVAL_00 = (INIT_MODE == "mem_file") ? INIT_VALUE_00 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_01 = (INIT_MODE == "mem_file") ? INIT_VALUE_01 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_02 = (INIT_MODE == "mem_file") ? INIT_VALUE_02 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_03 = (INIT_MODE == "mem_file") ? INIT_VALUE_03 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_04 = (INIT_MODE == "mem_file") ? INIT_VALUE_04 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_05 = (INIT_MODE == "mem_file") ? INIT_VALUE_05 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_06 = (INIT_MODE == "mem_file") ? INIT_VALUE_06 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_07 = (INIT_MODE == "mem_file") ? INIT_VALUE_07 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_08 = (INIT_MODE == "mem_file") ? INIT_VALUE_08 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_09 = (INIT_MODE == "mem_file") ? INIT_VALUE_09 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_0A = (INIT_MODE == "mem_file") ? INIT_VALUE_0A : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_0B = (INIT_MODE == "mem_file") ? INIT_VALUE_0B : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_0C = (INIT_MODE == "mem_file") ? INIT_VALUE_0C : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_0D = (INIT_MODE == "mem_file") ? INIT_VALUE_0D : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_0E = (INIT_MODE == "mem_file") ? INIT_VALUE_0E : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_0F = (INIT_MODE == "mem_file") ? INIT_VALUE_0F : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_10 = (INIT_MODE == "mem_file") ? INIT_VALUE_10 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_11 = (INIT_MODE == "mem_file") ? INIT_VALUE_11 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_12 = (INIT_MODE == "mem_file") ? INIT_VALUE_12 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_13 = (INIT_MODE == "mem_file") ? INIT_VALUE_13 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_14 = (INIT_MODE == "mem_file") ? INIT_VALUE_14 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_15 = (INIT_MODE == "mem_file") ? INIT_VALUE_15 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_16 = (INIT_MODE == "mem_file") ? INIT_VALUE_16 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_17 = (INIT_MODE == "mem_file") ? INIT_VALUE_17 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_18 = (INIT_MODE == "mem_file") ? INIT_VALUE_18 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_19 = (INIT_MODE == "mem_file") ? INIT_VALUE_19 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_1A = (INIT_MODE == "mem_file") ? INIT_VALUE_1A : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_1B = (INIT_MODE == "mem_file") ? INIT_VALUE_1B : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_1C = (INIT_MODE == "mem_file") ? INIT_VALUE_1C : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_1D = (INIT_MODE == "mem_file") ? INIT_VALUE_1D : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_1E = (INIT_MODE == "mem_file") ? INIT_VALUE_1E : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_1F = (INIT_MODE == "mem_file") ? INIT_VALUE_1F : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_20 = (INIT_MODE == "mem_file") ? INIT_VALUE_20 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_21 = (INIT_MODE == "mem_file") ? INIT_VALUE_21 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_22 = (INIT_MODE == "mem_file") ? INIT_VALUE_22 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_23 = (INIT_MODE == "mem_file") ? INIT_VALUE_23 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_24 = (INIT_MODE == "mem_file") ? INIT_VALUE_24 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_25 = (INIT_MODE == "mem_file") ? INIT_VALUE_25 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_26 = (INIT_MODE == "mem_file") ? INIT_VALUE_26 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_27 = (INIT_MODE == "mem_file") ? INIT_VALUE_27 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_28 = (INIT_MODE == "mem_file") ? INIT_VALUE_28 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_29 = (INIT_MODE == "mem_file") ? INIT_VALUE_29 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_2A = (INIT_MODE == "mem_file") ? INIT_VALUE_2A : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_2B = (INIT_MODE == "mem_file") ? INIT_VALUE_2B : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_2C = (INIT_MODE == "mem_file") ? INIT_VALUE_2C : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_2D = (INIT_MODE == "mem_file") ? INIT_VALUE_2D : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_2E = (INIT_MODE == "mem_file") ? INIT_VALUE_2E : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_2F = (INIT_MODE == "mem_file") ? INIT_VALUE_2F : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_30 = (INIT_MODE == "mem_file") ? INIT_VALUE_30 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_31 = (INIT_MODE == "mem_file") ? INIT_VALUE_31 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_32 = (INIT_MODE == "mem_file") ? INIT_VALUE_32 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_33 = (INIT_MODE == "mem_file") ? INIT_VALUE_33 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_34 = (INIT_MODE == "mem_file") ? INIT_VALUE_34 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_35 = (INIT_MODE == "mem_file") ? INIT_VALUE_35 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_36 = (INIT_MODE == "mem_file") ? INIT_VALUE_36 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_37 = (INIT_MODE == "mem_file") ? INIT_VALUE_37 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_38 = (INIT_MODE == "mem_file") ? INIT_VALUE_38 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_39 = (INIT_MODE == "mem_file") ? INIT_VALUE_39 : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_3A = (INIT_MODE == "mem_file") ? INIT_VALUE_3A : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_3B = (INIT_MODE == "mem_file") ? INIT_VALUE_3B : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_3C = (INIT_MODE == "mem_file") ? INIT_VALUE_3C : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_3D = (INIT_MODE == "mem_file") ? INIT_VALUE_3D : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_3E = (INIT_MODE == "mem_file") ? INIT_VALUE_3E : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
        defparam sp16k.INITVAL_3F = (INIT_MODE == "mem_file") ? INIT_VALUE_3F : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    end
    else if(FAMILY_CODE == _FCODE_ICE_) begin : iCE40UP
        wire [10:0] addr_w;
        wire [15:0] wdata_w;
        wire [15:0] rdata_w;
        wire [15:0] mask_w;
        wire [DATA_WIDTH-1:0] rd_data_corr_w;
        reg [DATA_WIDTH-1:0] rd_data_buffer_r;
        
        assign rd_data_o = (OUTREG == "reg") ? rd_data_buffer_r : rd_data_corr_w;
        
        for(i0 = 0; i0 < 16; i0 = i0 + 1) begin
            if(i0 < 8) assign mask_w[i0] = (BYTE_ENABLE == 0) ? 1'b0 : (DATA_WIDTH == 16) ? ~ben_i[0] : 1'b0;
            else assign mask_w[i0] = (BYTE_ENABLE == 0) ? 1'b0 : (DATA_WIDTH == 16) ? ~ben_i[1] : 1'b0;
        end
        
        if(DATA_WIDTH == 16) begin
                assign wdata_w = wr_data_i;
                assign addr_w [ADDR_WIDTH-1:0] = addr_i;
                assign addr_w [10:ADDR_WIDTH] = 'h0;
                assign rd_data_corr_w = rdata_w;
        end
        else if(DATA_WIDTH == 8) begin
            assign wdata_w[0]     = wr_data_i[0];
            assign wdata_w[2]     = wr_data_i[1];
            assign wdata_w[4]     = wr_data_i[2];
            assign wdata_w[6]     = wr_data_i[3];
            assign wdata_w[8]     = wr_data_i[4];
            assign wdata_w[10]    = wr_data_i[5];
            assign wdata_w[12]    = wr_data_i[6];
            assign wdata_w[14]    = wr_data_i[7];
            
            assign addr_w [ADDR_WIDTH-1:0] = addr_i;
            assign addr_w [10:ADDR_WIDTH] = 'h0;
            
            assign rd_data_corr_w[0] = rdata_w[0];
            assign rd_data_corr_w[1] = rdata_w[2];
            assign rd_data_corr_w[2] = rdata_w[4];
            assign rd_data_corr_w[3] = rdata_w[6];
            assign rd_data_corr_w[4] = rdata_w[8];
            assign rd_data_corr_w[5] = rdata_w[10];
            assign rd_data_corr_w[6] = rdata_w[12];
            assign rd_data_corr_w[7] = rdata_w[14];
        end
        else if(DATA_WIDTH == 4) begin
            assign wdata_w[1]     = wr_data_i[0];
            assign wdata_w[5]     = wr_data_i[1];
            assign wdata_w[9]     = wr_data_i[2];
            assign wdata_w[13]    = wr_data_i[3];

            assign addr_w [ADDR_WIDTH-1:0] = addr_i;
            assign addr_w [10:ADDR_WIDTH] = 'h0;

            assign rd_data_corr_w[0]    = rdata_w[1];
            assign rd_data_corr_w[1]    = rdata_w[5];
            assign rd_data_corr_w[2]    = rdata_w[9];
            assign rd_data_corr_w[3]    = rdata_w[13];        
        end
        else begin
            assign wdata_w[11]   = wr_data_i[1];
            assign wdata_w[3]    = wr_data_i[0];

            assign addr_w [ADDR_WIDTH-1:0] = addr_i;

            assign rd_data_corr_w[0] = rdata_w[3];
            assign rd_data_corr_w[1] = rdata_w[11];
        end
        
        if(OUTREG == "reg") begin
            if(RESETMODE == "sync") begin
                always @ (posedge clk_i) begin
                    if(rst_i == 1'b1) begin
                        rd_data_buffer_r <= 'h0;
                    end
                    else begin
                        if(rd_out_clk_en_i == 1'b1) begin
                            rd_data_buffer_r <= rd_data_corr_w;
                        end
                    end
                end
            end
            else if(ASYNC_RST_RELEASE == "sync") begin
                always @ (posedge clk_i, posedge rst_i) begin
                    if(rst_i == 1'b1) begin
                        rd_data_buffer_r <= 'h0;
                    end
                    else begin
                        if(rd_out_clk_en_i == 1'b1) begin
                            rd_data_buffer_r <= rd_data_corr_w;
                        end
                    end
                end
            end
            else begin
                always @ * begin
                    if(rst_i == 1'b1) begin
                        rd_data_buffer_r = 'h0;
                    end
                    else begin
                        if(rd_out_clk_en_i == 1'b1) begin
                            rd_data_buffer_r = rd_data_corr_w;
                        end
                    end
                end
            end
        end

        wire t_wr_en_i = (BYTE_ENABLE == 0) ? wr_en_i : ((BYTE_WIDTH > 1) ? wr_en_i : wr_en_i & ben_i);
        
        PDP4K sp4k (    
            .ADR(addr_w),
            .ADW(addr_w),
            .DI(wdata_w),
            .MASK_N(mask_w),
                
            .CER(clk_en_i),
            .CKR(clk_i),
            .RE(~wr_en_i),
            .CEW(clk_en_i),
            .CKW(clk_i),
            .WE(t_wr_en_i),
            
            .DO(rdata_w)
        );

        localparam R = (DATA_WIDTH == 16) ? "16" : (DATA_WIDTH == 8) ? "8" : (DATA_WIDTH == 4) ? "4" : "2";
        localparam W = (DATA_WIDTH == 16) ? "16" : (DATA_WIDTH == 8) ? "8" : (DATA_WIDTH == 4) ? "4" : "2";

        localparam X0 = (INIT_MODE == "mem_file") ? (INIT_VALUE_00) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam X1 = (INIT_MODE == "mem_file") ? (INIT_VALUE_01) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam X2 = (INIT_MODE == "mem_file") ? (INIT_VALUE_02) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam X3 = (INIT_MODE == "mem_file") ? (INIT_VALUE_03) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam X4 = (INIT_MODE == "mem_file") ? (INIT_VALUE_04) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam X5 = (INIT_MODE == "mem_file") ? (INIT_VALUE_05) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam X6 = (INIT_MODE == "mem_file") ? (INIT_VALUE_06) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam X7 = (INIT_MODE == "mem_file") ? (INIT_VALUE_07) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam X8 = (INIT_MODE == "mem_file") ? (INIT_VALUE_08) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam X9 = (INIT_MODE == "mem_file") ? (INIT_VALUE_09) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam XA = (INIT_MODE == "mem_file") ? (INIT_VALUE_0A) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam XB = (INIT_MODE == "mem_file") ? (INIT_VALUE_0B) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam XC = (INIT_MODE == "mem_file") ? (INIT_VALUE_0C) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam XD = (INIT_MODE == "mem_file") ? (INIT_VALUE_0D) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam XE = (INIT_MODE == "mem_file") ? (INIT_VALUE_0E) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";
        localparam XF = (INIT_MODE == "mem_file") ? (INIT_VALUE_0F) : (INIT_MODE == "all_one") ? "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" : "0x0000000000000000000000000000000000000000000000000000000000000000";

        defparam    sp4k.DATA_WIDTH_W     = W;
        defparam    sp4k.DATA_WIDTH_R     = R;

        defparam    sp4k.INITVAL_0        =  X0;
        defparam    sp4k.INITVAL_1        =  X1;
        defparam    sp4k.INITVAL_2        =  X2;
        defparam    sp4k.INITVAL_3        =  X3;
        defparam    sp4k.INITVAL_4        =  X4;
        defparam    sp4k.INITVAL_5        =  X5;
        defparam    sp4k.INITVAL_6        =  X6;
        defparam    sp4k.INITVAL_7        =  X7;
        defparam    sp4k.INITVAL_8        =  X8;
        defparam    sp4k.INITVAL_9        =  X9;
        defparam    sp4k.INITVAL_A        =  XA;
        defparam    sp4k.INITVAL_B        =  XB;
        defparam    sp4k.INITVAL_C        =  XC;
        defparam    sp4k.INITVAL_D        =  XD;
        defparam    sp4k.INITVAL_E        =  XE;
        defparam    sp4k.INITVAL_F        =  XF;
    end
endgenerate

//------------------------------------------------------------------------------
// Function Definition
//------------------------------------------------------------------------------

function [31:0] calculateStringSize;
    input [31:0] x_calc;
    input [31:0] y_calc;
    reg [31:0] x_func;
    reg [31:0] y_func;
    begin
        if(x_calc >= 10000000) begin
            x_func = 8;
        end
        else if(x_calc >= 1000000) begin
            x_func = 7;
        end
        else if(x_calc >= 100000) begin
            x_func = 6;
        end
        else if(x_calc >= 10000) begin
            x_func = 5;
        end
        else if(x_calc >= 1000) begin
            x_func = 4;
        end
        else if(x_calc >= 100) begin
            x_func = 3;
        end
        else if(x_calc >= 10) begin
            x_func = 2;
        end
        else begin
            x_func = 1;
        end

        if(y_calc >= 10000000) begin
            y_func = 8;
        end
        else if(y_calc >= 1000000) begin
            y_func = 7;
        end
        else if(y_calc >= 100000) begin
            y_func = 6;
        end
        else if(y_calc >= 10000) begin
            y_func = 5;
        end
        else if(y_calc >= 1000) begin
            y_func = 4;
        end
        else if(y_calc >= 100) begin
            y_func = 3;
        end
        else if(y_calc >= 10) begin
            y_func = 2;
        end
        else begin
            y_func = 1;
        end

        calculateStringSize = (3 + x_func + y_func) * 8;
    end
endfunction

function [31:0] getByteWidth;
    input [31:0] data_width;
    input [31:0] dev_code;
    begin
        case(dev_code)
            _FCODE_LIFCL_:
            begin
                if(data_width == 18 || data_width == 16) getByteWidth = 2;
                else getByteWidth = 1;
            end
            _FCODE_ICE_:
            begin
                if(data_width == 16) getByteWidth = 2;
                else getByteWidth = 1;
            end
            default: getByteWidth = 1;
        endcase
    end
endfunction

function [STRING_SIZE-1:0] getStringFromPos;
    input [31:0] x;
    input [31:0] y;
    begin
        if (y >= 10000000) begin
            if (x >= 10000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X7*8+7:POS_X7*8],NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y7*8+7:POS_Y7*8],NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y7*8+7:POS_Y7*8],NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y7*8+7:POS_Y7*8],NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10000) begin 
                getStringFromPos = {"[",NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y7*8+7:POS_Y7*8],NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y7*8+7:POS_Y7*8],NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100) begin
                getStringFromPos = {"[",NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y7*8+7:POS_Y7*8],NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10) begin
                getStringFromPos = {"[",NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y7*8+7:POS_Y7*8],NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else begin
                getStringFromPos = {"[",NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y7*8+7:POS_Y7*8],NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
        end
        else if (y >= 1000000) begin
            if (x >= 10000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X7*8+7:POS_X7*8],NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10000) begin 
                getStringFromPos = {"[",NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100) begin
                getStringFromPos = {"[",NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10) begin
                getStringFromPos = {"[",NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else begin
                getStringFromPos = {"[",NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y6*8+7:POS_Y6*8],NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
        end
        else if (y >= 100000) begin
            if (x >= 10000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X7*8+7:POS_X7*8],NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10000) begin 
                getStringFromPos = {"[",NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100) begin
                getStringFromPos = {"[",NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10) begin
                getStringFromPos = {"[",NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else begin
                getStringFromPos = {"[",NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y5*8+7:POS_Y5*8],NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
        end
        else if (y >= 10000) begin
            if (x >= 10000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X7*8+7:POS_X7*8],NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10000) begin 
                getStringFromPos = {"[",NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100) begin
                getStringFromPos = {"[",NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10) begin
                getStringFromPos = {"[",NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else begin
                getStringFromPos = {"[",NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y4*8+7:POS_Y4*8],NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
        end
        else if (y >= 1000) begin
            if (x >= 10000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X7*8+7:POS_X7*8],NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10000) begin 
                getStringFromPos = {"[",NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100) begin
                getStringFromPos = {"[",NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10) begin
                getStringFromPos = {"[",NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else begin
                getStringFromPos = {"[",NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y3*8+7:POS_Y3*8],NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
        end
        else if (y >= 100) begin
            if (x >= 10000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X7*8+7:POS_X7*8],NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10000) begin 
                getStringFromPos = {"[",NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100) begin
                getStringFromPos = {"[",NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10) begin
                getStringFromPos = {"[",NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else begin
                getStringFromPos = {"[",NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y2*8+7:POS_Y2*8],NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
        end
        else if (y >= 10) begin
            if (x >= 10000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X7*8+7:POS_X7*8],NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10000) begin 
                getStringFromPos = {"[",NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100) begin
                getStringFromPos = {"[",NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10) begin
                getStringFromPos = {"[",NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else begin
                getStringFromPos = {"[",NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y1*8+7:POS_Y1*8],NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
        end
        else begin
            if (x >= 10000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X7*8+7:POS_X7*8],NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X6*8+7:POS_X6*8],NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X5*8+7:POS_X5*8],NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10000) begin 
                getStringFromPos = {"[",NUM_STRING[POS_X4*8+7:POS_X4*8],NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 1000) begin
                getStringFromPos = {"[",NUM_STRING[POS_X3*8+7:POS_X3*8],NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 100) begin
                getStringFromPos = {"[",NUM_STRING[POS_X2*8+7:POS_X2*8],NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else if (x >= 10) begin
                getStringFromPos = {"[",NUM_STRING[POS_X1*8+7:POS_X1*8],NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
            else begin
                getStringFromPos = {"[",NUM_STRING[POS_X0*8+7:POS_X0*8],",",
                                        NUM_STRING[POS_Y0*8+7:POS_Y0*8],"]"};
            end
        end
    end
endfunction

function [10:0] getAddrWidth;
    input [31:0] dwidth_impl;
    input [9:0] device_code;
    begin
        case(device_code)
            _FCODE_ICE_:     begin
                    case(dwidth_impl)
                        16: getAddrWidth = 8;
                        8: getAddrWidth = 9;
                        4: getAddrWidth = 10;
                        2: getAddrWidth = 11;
                    endcase
                end
            _FCODE_LIFCL_:    begin
                    case(dwidth_impl)
                        18: getAddrWidth = 10;
                        16: getAddrWidth = 10;
                        9: getAddrWidth = 11;
                        8: getAddrWidth = 11;
                        4: getAddrWidth = 12;
                        2: getAddrWidth = 13;
                        1: getAddrWidth = 14;
                    endcase
                end
        endcase
    end
endfunction

endmodule

`endif
