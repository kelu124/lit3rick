//==============================================================================
// DFT Top level module
//
// 8192-sample (12bits) long signal is fragmented in 256 32-sample long subsignals,
// on which FT is calculated for 3 points (F1, F2, F3), which are put in abs, and
// averaged. The result is a 256-sample long signal.
//
// Interfaces (paste this to wavedrom.com):
//{signal: [
//    ['Input interface',
//        {name: 'clk', wave: 'p....................|'},
//        {name: 'valid_in', wave: '01...0.1010..1.......|'},
//        {name: 'data_in', wave: 'x====x.=x=x..===...==|', data:["d0", "d1", "d2", "d3", "d5", "d6", "d7", "d8", "d9", "d10"]},
//        {name: 'ready', wave: '1..............0..1..|'},
//    ],
//    {},{},
//    ['Output interface',
//        {name: 'clk', wave: 'p....................|'},
//        {name: 'valid_out', wave: '010|..10|..10|..10...|'},
//        {name: 'data_out', wave: 'x=x|..=x|..=x|..=x...|', data:["d0", "d1", "d2", "d3", "d5", "d6", "d7", "d8", "d9", "d10"]},
//    ],
// ]}
//
//=============================================================================
module dft
#(
    parameter DATA_W = 12 // Data input width
)
(
    // System
    input wire                      clk,        // System clock
    input wire                      rst,        // System reset
    // Input data from ADC
    input  wire signed [DATA_W-1:0] data_in,    // Data input
    input  wire                     valid_in,   // Data input is valid
    input  wire                     frame_start,// Data frame start
    output wire                     ready,      // DFT is ready to receive more data
    // Output data
    output wire        [14:0]       data_out,   // Data output
    output wire                     valid_out   // Output data is valid
);

//-----------------------------------------------------------------------------
// Local parameters
//-----------------------------------------------------------------------------
localparam PREPROC_DATA_W = DATA_W;

localparam FIFO_ADDR_W = 6;
localparam FIFO_DATA_W = PREPROC_DATA_W;

localparam CORE_DFT_N       = 16;
localparam CORE_DATA_IN_W   = PREPROC_DATA_W;
localparam CORE_DATA_OUT_W  = PREPROC_DATA_W + $clog2(CORE_DFT_N);

localparam POSTPROC_DATA_W = CORE_DATA_OUT_W;

//-----------------------------------------------------------------------------
// Local variables
//-----------------------------------------------------------------------------
wire signed [PREPROC_DATA_W-1:0] preproc_data_out;
wire                             preproc_valid_out;

wire                   fifo_full;
wire [FIFO_DATA_W-1:0] fifo_rdata;
wire                   fifo_rd;
wire                   fifo_empty;

wire signed [CORE_DATA_OUT_W-1:0] core_data_re_out;
wire signed [CORE_DATA_OUT_W-1:0] core_data_im_out;
wire                              core_data_valid;

//-----------------------------------------------------------------------------
// Data preprocessing unit
//-----------------------------------------------------------------------------
dft_preproc
#(
    .DATA_W     (PREPROC_DATA_W)    // Data width
)
preproc
(
    // System
    .clk        (clk),              // System clock
    .rst        (rst),              // System reset
    // Input data
    .data_in    (data_in),          // Data input
    .valid_in   (valid_in),         // Input data is valid
    // Output data
    .data_out   (preproc_data_out), // Data output
    .valid_out  (preproc_valid_out),// Output data is valid
    .ready_out  (ready)             // System is ready to receive data
);

//-----------------------------------------------------------------------------
// Input FIFO
//-----------------------------------------------------------------------------
dft_fifo
#(
    .ADDR_W (FIFO_ADDR_W),  // Memory depth
    .DATA_W (FIFO_DATA_W)   // Data width
)
fifo
(
    // System
    .clk    (clk),   // System clock
    .rst    (rst),   // System reset
    // Write interface
    .wdata  (preproc_data_out),     // Write data
    .wr     (preproc_valid_out),    // Write operation
    .full   (fifo_full),            // FIFO is full
    // Read interface
    .rdata  (fifo_rdata), // Read data
    .rd     (fifo_rd),       // Read operation
    .empty  (fifo_empty)     // FIFO is empty
);

assign ready = ~fifo_full;

//-----------------------------------------------------------------------------
// DFT Core
//-----------------------------------------------------------------------------
dft_core
#(
    .DATA_IN_W  (CORE_DATA_IN_W),    // Data input width
    .DATA_OUT_W (CORE_DATA_OUT_W),   // Data output width
    .DFT_N      (CORE_DFT_N)         // Number of points in DFT window
)
core
(
    // System
    .clk            (clk),   // System clock
    .rst            (rst),   // System reset
    .sync           (frame_start), // Data frame start
    // Input data from FIFO
    .fifo_rdata     (fifo_rdata),    // FIFO data
    .fifo_rd        (fifo_rd),       // FIFO data read
    .fifo_empty     (fifo_empty),    // FIFO is empty
    // Output data
    .data_re_out    (core_data_re_out),  // Data real part output
    .data_im_out    (core_data_im_out),  // Data imaginary part output
    .valid_out      (core_valid_out)     // Output data is valid
);

//-----------------------------------------------------------------------------
// Data Postprocessing Unit
//-----------------------------------------------------------------------------
dft_postproc
#(
    .DATA_W (POSTPROC_DATA_W) // Data width
)
postproc
(
    // System
    .clk        (clk), // System clock
    .rst        (rst), // System reset
    // Input data from FIFO
    .data_re_in (core_data_re_out),  // Data real part
    .data_im_in (core_data_im_out),  // Data imaginary part
    .valid_in   (core_valid_out),     // Data is valid
    // Output data
    .data_out   (data_out),    // Data output
    .valid_out  (valid_out)    // Data output is valid
);

endmodule