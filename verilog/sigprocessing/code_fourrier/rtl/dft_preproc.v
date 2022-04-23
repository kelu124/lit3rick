//==============================================================================
// DFT Preprocessing Unit
//
// Performs an average of every 2 input points
//
//=============================================================================
module dft_preproc
#(
    parameter DATA_W = 12   // Data width
)
(
    // System
    input wire                      clk,       // System clock
    input wire                      rst,       // System reset
    // Input data
    input  wire signed [DATA_W-1:0] data_in,   // Data input
    input  wire                     valid_in,  // Input data is valid
    // Output data
    output wire signed [DATA_W-1:0] data_out,  // Data output
    output reg                      valid_out, // Output data is valid
    input  wire                     ready_out  // System is ready to receive data
);
//-----------------------------------------------------------------------------
// Local parameters
//-----------------------------------------------------------------------------
localparam AVG_0_S = 2'd0;
localparam AVG_1_S = 2'd1;
localparam WAIT_READY_S = 2'd2;

//-----------------------------------------------------------------------------
// Local variables
//-----------------------------------------------------------------------------
reg [1:0] fsm_state;    // FSM current state
reg [1:0] fsm_next;     // FSM next

reg signed [DATA_W:0] avg;

//-----------------------------------------------------------------------------
// Average FSM
//-----------------------------------------------------------------------------
always @(posedge clk or posedge rst)
begin
    if (rst)
        fsm_state <= AVG_0_S;
    else
        fsm_state <= fsm_next;
end

always @(*)
begin
    fsm_next = fsm_state;
    case (fsm_state)
        AVG_0_S : begin
            if (valid_in)
                fsm_next = AVG_1_S;
        end

        AVG_1_S : begin
            if (valid_in && ready_out)
                fsm_next = AVG_0_S;
            else if (!ready_out)
                fsm_next = WAIT_READY_S;
        end

        WAIT_READY_S : begin
            if (ready_out)
                fsm_next = AVG_0_S;
        end
    endcase
end

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        valid_out <= 1'b0;
        avg       <= {DATA_W+1{1'b0}};
    end
    else begin
        case (fsm_state)
            AVG_0_S : begin
                valid_out <= 1'b0;
                if (valid_in) begin
                    avg <= data_in;
                end
            end

            AVG_1_S : begin
                if (valid_in) begin
                    avg <= avg + data_in;
                    if (ready_out)
                        valid_out <= 1'b1;
                end
            end

            WAIT_READY_S : begin
                if (ready_out)
                    valid_out <= 1'b1;
            end
        endcase
    end
end

// Vector part select instead of shift
assign data_out = avg[DATA_W:1];

endmodule