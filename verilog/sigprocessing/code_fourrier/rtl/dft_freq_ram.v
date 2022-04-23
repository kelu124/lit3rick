//==============================================================================
// DFT Frequency Bins RAM
//
//==============================================================================

module dft_freq_ram
#(
    parameter ADDR_W = 2,   // Memory depth
    parameter DATA_W = 16   // Data width
)(
    // System
    input wire               clk,      // System clock
    input wire               rst,      // System reset
    // Write interface
    input  wire [DATA_W-1:0] wdata_re, // Write data real part
    input  wire [DATA_W-1:0] wdata_im, // Write data imaginary part
    input  wire [ADDR_W-1:0] waddr,    // Write address
    input  wire              wr,       // Write operation
    // Read interface
    output reg  [DATA_W-1:0] rdata_re, // Read data real part
    output reg  [DATA_W-1:0] rdata_im, // Read data imaginary part
    input  wire [ADDR_W-1:0] raddr,    // Read address
    input  wire              rd        // Read operation
);

// Memory array
reg [DATA_W-1:0] mem_re [2**ADDR_W-1:0];
reg [DATA_W-1:0] mem_im [2**ADDR_W-1:0];

// Write port
always @(posedge clk)
begin
    if (wr) begin
        mem_re[waddr] <= wdata_re;
        mem_im[waddr] <= wdata_im;
    end
end

// Read port
always @(posedge clk or posedge rst)
begin
    if (rst) begin
        rdata_re <= {DATA_W{1'b0}};
        rdata_im <= {DATA_W{1'b0}};
    end else if (rd) begin
        rdata_re <= mem_re[raddr];
        rdata_im <= mem_im[raddr];
    end
end

endmodule
