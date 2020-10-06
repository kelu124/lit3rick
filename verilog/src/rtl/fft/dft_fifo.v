//==============================================================================
// DFT Data FIFO
//
//==============================================================================

module dft_fifo
#(
    parameter ADDR_W = 8,   // Memory depth
    parameter DATA_W = 12   // Data width
)(
    // System
    input  wire              clk,   // System clock
    input  wire              rst,   // System reset
    // Write interface
    input  wire [DATA_W-1:0] wdata, // Write data
    input  wire              wr,    // Write operation
    output wire              full,  // FIFO is full
    // Read interface
    output wire [DATA_W-1:0] rdata, // Read data
    input  wire              rd,    // Read operation
    output wire              empty  // FIFO is empty
);

 lscc_fifo
#(
    .IMPLEMENTATION           ("EBR"),
    .ADDRESS_DEPTH            (2**ADDR_W),
    .ADDRESS_WIDTH            (ADDR_W),
    .DATA_WIDTH               (DATA_W),
    .REGMODE                  ("wire"),
    .RESET_MODE               ("async"),
    .ENABLE_ALMOST_FULL_FLAG  ("FALSE"),
    .ENABLE_ALMOST_EMPTY_FLAG ("FALSE"),
    .ENABLE_DATA_COUNT        ("FALSE"),
    .FAMILY                   ("iCE40UP")
) lscc_fifo_ip (
    .clk_i      (clk),
    .wr_data_i  (wdata),
    .wr_en_i    (wr),
    .rd_en_i    (rd),
    .rst_i      (rst),
    .rd_data_o  (rdata),
    .full_o     (full),
    .empty_o    (empty)
);

endmodule
