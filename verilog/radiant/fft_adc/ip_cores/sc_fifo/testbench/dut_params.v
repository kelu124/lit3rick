localparam FAMILY = "iCE40UP";
localparam ADDRESS_DEPTH = 256;
localparam DATA_WIDTH = 16;
localparam ADDRESS_WIDTH = 8;
localparam REGMODE = "noreg";
localparam RESET_MODE = "sync";
localparam ENABLE_ALMOST_FULL_FLAG = "TRUE";
localparam ALMOST_FULL_ASSERTION = "static-single";
localparam ALMOST_FULL_ASSERT_LVL = 100;
localparam ALMOST_FULL_DEASSERT_LVL = 99;
localparam ENABLE_ALMOST_EMPTY_FLAG = "TRUE";
localparam ALMOST_EMPTY_ASSERTION = "static-dual";
localparam ALMOST_EMPTY_ASSERT_LVL = 40;
localparam ALMOST_EMPTY_DEASSERT_LVL = 41;
localparam ENABLE_DATA_COUNT = "FALSE";
localparam IMPLEMENTATION = "EBR";
`define ICE40UP
