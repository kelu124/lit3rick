module main_fsm(
    input           clk,
    input           reset,
    input           start,
    input           end_working,
    input           end_fft,
    input           fft_working,
    input           control_reg_wr,
    input [31 : 0]  control_reg,
    input [15 : 0]  pdelay,
    input [15 : 0]  PHV_time,
    input [15 : 0]  PnHV_time,
    input [15 : 0]  PDamp_time,
    input           almost_empty_i2s,
    output reg      start_sampling,
    output reg      start_dac_count,
    output reg      start_fft,
    output reg      rgb_r,
    output reg      rgb_g,
    output reg      rgb_b,
    output reg      PHV,
    output reg      PnHV,
    output reg      PDamp,
    output reg      autorestart_mode,
    output wire [9:0]    state_o
);

    localparam p_state_idle = 0;
    localparam p_state_start_sampling = 1;
    localparam p_state_wait_end_sampling = 2;
    localparam p_state_start_fft = 3;
    localparam p_state_wait_end_fft = 4;
    localparam p_state_wait_finish = 5;
    localparam p_state_start_dac = 6;

    localparam p_samples = 8192;
    localparam p_dac_time = 360;

    reg [5:0] state;
    reg start_z;
    reg start_zz;
    reg [15:0] timer;
    reg end_working_z;
    reg end_working_zz;
    reg was_control_reg_wr;
    reg autorestart_mode_int;
    wire start_edge;
    wire end_working_edge;
    reg [15:0] pdamp_start;
    reg [15:0] pdamp_end;
    reg [15:0] pnhv_start;
    reg [15:0] pnhv_end;
    reg [15:0] phv_start;
    reg [15:0] phv_end;

    assign start_edge = start_z & ~start_zz;
    assign end_working_edge = end_working_z & ~end_working_zz;
    assign state_o = {autorestart_mode, autorestart_mode_int, control_reg[4], state[4:0]};

    always @(posedge clk or posedge reset) begin
        if (reset == 1) begin
            state                <= p_state_idle;
            start_z              <= 0;
            start_zz             <= 0;
            end_working_z        <= 0;
            end_working_zz       <= 0;
            rgb_r                <= 0;
            rgb_g                <= 0;
            rgb_b                <= 0;
            PHV                  <= 0;
            PnHV                 <= 0;
            PDamp                <= 0;
            start_sampling       <= 0;
            timer                <= -1;
            start_fft            <= 0;
            was_control_reg_wr   <= 0;
            autorestart_mode     <= 0;
            autorestart_mode_int <= 0;
            start_dac_count      <= 0;
            pdamp_start          <= 0;
            pdamp_end            <= 0;
            pnhv_start           <= 0;
            pnhv_end             <= 0;
            phv_start            <= 0;
            phv_end              <= 0;
        end else begin
            start_zz <= start_z;
            start_z <= start;
            end_working_zz <= end_working_z;
            end_working_z <= end_working;

            if (timer < p_samples + p_dac_time + 3) begin
                timer <= timer + 1;
            end

            // if (was_control_reg_wr == 1 && state == p_state_wait_finish) begin
            // if (was_control_reg_wr == 1 && state == p_state_idle) begin
            if (was_control_reg_wr == 1 && state == p_state_wait_end_fft) begin
                was_control_reg_wr <= 0;
            end else if (control_reg_wr == 1 && control_reg[0] == 1) begin
                was_control_reg_wr <= 1;
            end
            
            phv_start <= pdelay + p_dac_time + 3;
            phv_end <= phv_start + PHV_time;
            pnhv_start <= phv_end + 1;
            pnhv_end <= pnhv_start + PnHV_time;
            pdamp_start <= pnhv_end + 1;
            pdamp_end <= pdamp_start + PDamp_time;

            PHV   <= (timer >= phv_start   && timer < phv_end)   ? 1'b1 : 1'b0;
            PnHV  <= (timer >= pnhv_start  && timer < pnhv_end)  ? 1'b1 : 1'b0;
            PDamp <= (timer >= pdamp_start && timer < pdamp_end) ? 1'b1 : 1'b0;

            
            // if (control_reg_wr == 1) begin
                autorestart_mode_int <= control_reg[4];
            // end

            case (state)
                p_state_idle : begin
                    rgb_r <= 1;
                    timer <= 0;

                    autorestart_mode <= autorestart_mode_int;
                    if (autorestart_mode_int == 1) begin
                        state <= p_state_start_dac;
                        // state <= 1;
                    end else begin
                        if ((start_edge == 1 || (control_reg_wr == 1 && control_reg[3] == 1)) && control_reg[0] == 0) begin
                            state <= p_state_start_dac;
                        end else if (was_control_reg_wr) begin
                            state <= p_state_start_fft;
                        end
                    end
                end

                p_state_start_dac : begin
                    if (timer == 0) begin
                        start_dac_count <= 1;
                    end else begin
                        start_dac_count <= 0;
                    end
                    if (timer == p_dac_time) begin
                        state <= p_state_start_sampling;
                    end
                end

                p_state_start_sampling : begin
                    rgb_r <= 0;
                    rgb_b <= 1;
                    start_sampling <= 1;
                    state <= p_state_wait_end_sampling;
                end

                p_state_wait_end_sampling : begin
                    start_sampling <= 0;
                    if (timer == p_samples + p_dac_time + 3) begin
                        rgb_b <= 0;
                        rgb_g <= 1;
                        state <= p_state_start_fft;
                    end
                end

                p_state_start_fft : begin
                    start_fft <= 1;
                    state <= p_state_wait_end_fft;
                end

                p_state_wait_end_fft : begin
                    start_fft <= 0;
                    if (end_fft == 1 && autorestart_mode == 0) begin
                        // state <= p_state_wait_finish;
                        state <= p_state_idle;
                    end else if (start_fft == 0 && fft_working == 0 && autorestart_mode == 1 && almost_empty_i2s == 1) begin
                        state <= p_state_idle;
                    end
                end

                p_state_wait_finish : begin
                    if (end_working_edge == 1 || was_control_reg_wr == 1 || control_reg[3] == 1) begin
                    // if (end_working_edge == 1 || was_control_reg_wr == 1 || (control_reg_wr == 1 && control_reg[3] == 1 && control_reg[0] == 0)) begin
                        rgb_g <= 0;
                        state <= p_state_idle;
                    end
                end

                // default : begin
                //     state <= p_state_idle;
                // end

            endcase
        end
    end

endmodule