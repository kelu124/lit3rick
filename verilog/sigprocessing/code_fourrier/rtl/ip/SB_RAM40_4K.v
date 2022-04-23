module SB_RAM40_4K (
    output [15:0] RDATA,
    input         RCLK, RCLKE, RE,
    input  [10:0] RADDR,
    input         WCLK, WCLKE, WE,
    input  [10:0] WADDR,
    input  [15:0] MASK, WDATA
);
    // MODE 0:  256 x 16
    // MODE 1:  512 x 8
    // MODE 2: 1024 x 4
    // MODE 3: 2048 x 2
    parameter WRITE_MODE = 0;
    parameter READ_MODE = 0;

    parameter INIT_0 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_4 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_5 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_6 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_7 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_8 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_9 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

    parameter INIT_FILE = "";

`ifndef BLACKBOX
    wire [15:0] WMASK_I;
    wire [15:0] RMASK_I;

    reg  [15:0] RDATA_I;
    wire [15:0] WDATA_I;

    generate
        case (WRITE_MODE)
            0: assign WMASK_I = MASK;

            1: assign WMASK_I = WADDR[   8] == 0 ? 16'b 1010_1010_1010_1010 :
                                WADDR[   8] == 1 ? 16'b 0101_0101_0101_0101 : 16'bx;

            2: assign WMASK_I = WADDR[ 9:8] == 0 ? 16'b 1110_1110_1110_1110 :
                                WADDR[ 9:8] == 1 ? 16'b 1101_1101_1101_1101 :
                                WADDR[ 9:8] == 2 ? 16'b 1011_1011_1011_1011 :
                                WADDR[ 9:8] == 3 ? 16'b 0111_0111_0111_0111 : 16'bx;

            3: assign WMASK_I = WADDR[10:8] == 0 ? 16'b 1111_1110_1111_1110 :
                                WADDR[10:8] == 1 ? 16'b 1111_1101_1111_1101 :
                                WADDR[10:8] == 2 ? 16'b 1111_1011_1111_1011 :
                                WADDR[10:8] == 3 ? 16'b 1111_0111_1111_0111 :
                                WADDR[10:8] == 4 ? 16'b 1110_1111_1110_1111 :
                                WADDR[10:8] == 5 ? 16'b 1101_1111_1101_1111 :
                                WADDR[10:8] == 6 ? 16'b 1011_1111_1011_1111 :
                                WADDR[10:8] == 7 ? 16'b 0111_1111_0111_1111 : 16'bx;
        endcase

        case (READ_MODE)
            0: assign RMASK_I = 16'b 0000_0000_0000_0000;

            1: assign RMASK_I = RADDR[   8] == 0 ? 16'b 1010_1010_1010_1010 :
                                RADDR[   8] == 1 ? 16'b 0101_0101_0101_0101 : 16'bx;

            2: assign RMASK_I = RADDR[ 9:8] == 0 ? 16'b 1110_1110_1110_1110 :
                                RADDR[ 9:8] == 1 ? 16'b 1101_1101_1101_1101 :
                                RADDR[ 9:8] == 2 ? 16'b 1011_1011_1011_1011 :
                                RADDR[ 9:8] == 3 ? 16'b 0111_0111_0111_0111 : 16'bx;

            3: assign RMASK_I = RADDR[10:8] == 0 ? 16'b 1111_1110_1111_1110 :
                                RADDR[10:8] == 1 ? 16'b 1111_1101_1111_1101 :
                                RADDR[10:8] == 2 ? 16'b 1111_1011_1111_1011 :
                                RADDR[10:8] == 3 ? 16'b 1111_0111_1111_0111 :
                                RADDR[10:8] == 4 ? 16'b 1110_1111_1110_1111 :
                                RADDR[10:8] == 5 ? 16'b 1101_1111_1101_1111 :
                                RADDR[10:8] == 6 ? 16'b 1011_1111_1011_1111 :
                                RADDR[10:8] == 7 ? 16'b 0111_1111_0111_1111 : 16'bx;
        endcase

        case (WRITE_MODE)
            0: assign WDATA_I = WDATA;

            1: assign WDATA_I = {WDATA[14], WDATA[14], WDATA[12], WDATA[12],
                                 WDATA[10], WDATA[10], WDATA[ 8], WDATA[ 8],
                                 WDATA[ 6], WDATA[ 6], WDATA[ 4], WDATA[ 4],
                                 WDATA[ 2], WDATA[ 2], WDATA[ 0], WDATA[ 0]};

            2: assign WDATA_I = {WDATA[13], WDATA[13], WDATA[13], WDATA[13],
                                 WDATA[ 9], WDATA[ 9], WDATA[ 9], WDATA[ 9],
                                 WDATA[ 5], WDATA[ 5], WDATA[ 5], WDATA[ 5],
                                 WDATA[ 1], WDATA[ 1], WDATA[ 1], WDATA[ 1]};

            3: assign WDATA_I = {WDATA[11], WDATA[11], WDATA[11], WDATA[11],
                                 WDATA[11], WDATA[11], WDATA[11], WDATA[11],
                                 WDATA[ 3], WDATA[ 3], WDATA[ 3], WDATA[ 3],
                                 WDATA[ 3], WDATA[ 3], WDATA[ 3], WDATA[ 3]};
        endcase

        case (READ_MODE)
            0: assign RDATA = RDATA_I;
            1: assign RDATA = {1'b0, |RDATA_I[15:14], 1'b0, |RDATA_I[13:12], 1'b0, |RDATA_I[11:10], 1'b0, |RDATA_I[ 9: 8],
                               1'b0, |RDATA_I[ 7: 6], 1'b0, |RDATA_I[ 5: 4], 1'b0, |RDATA_I[ 3: 2], 1'b0, |RDATA_I[ 1: 0]};
            2: assign RDATA = {2'b0, |RDATA_I[15:12], 3'b0, |RDATA_I[11: 8], 3'b0, |RDATA_I[ 7: 4], 3'b0, |RDATA_I[ 3: 0], 1'b0};
            3: assign RDATA = {4'b0, |RDATA_I[15: 8], 7'b0, |RDATA_I[ 7: 0], 3'b0};
        endcase
    endgenerate

    integer i;
    reg [15:0] memory [0:255];

    initial begin
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, memory);
        else
            for (i=0; i<16; i=i+1) begin
                memory[ 0*16 + i] = INIT_0[16*i +: 16];
                memory[ 1*16 + i] = INIT_1[16*i +: 16];
                memory[ 2*16 + i] = INIT_2[16*i +: 16];
                memory[ 3*16 + i] = INIT_3[16*i +: 16];
                memory[ 4*16 + i] = INIT_4[16*i +: 16];
                memory[ 5*16 + i] = INIT_5[16*i +: 16];
                memory[ 6*16 + i] = INIT_6[16*i +: 16];
                memory[ 7*16 + i] = INIT_7[16*i +: 16];
                memory[ 8*16 + i] = INIT_8[16*i +: 16];
                memory[ 9*16 + i] = INIT_9[16*i +: 16];
                memory[10*16 + i] = INIT_A[16*i +: 16];
                memory[11*16 + i] = INIT_B[16*i +: 16];
                memory[12*16 + i] = INIT_C[16*i +: 16];
                memory[13*16 + i] = INIT_D[16*i +: 16];
                memory[14*16 + i] = INIT_E[16*i +: 16];
                memory[15*16 + i] = INIT_F[16*i +: 16];
            end
    end

    always @(posedge WCLK) begin
        if (WE && WCLKE) begin
            if (!WMASK_I[ 0]) memory[WADDR[7:0]][ 0] <= WDATA_I[ 0];
            if (!WMASK_I[ 1]) memory[WADDR[7:0]][ 1] <= WDATA_I[ 1];
            if (!WMASK_I[ 2]) memory[WADDR[7:0]][ 2] <= WDATA_I[ 2];
            if (!WMASK_I[ 3]) memory[WADDR[7:0]][ 3] <= WDATA_I[ 3];
            if (!WMASK_I[ 4]) memory[WADDR[7:0]][ 4] <= WDATA_I[ 4];
            if (!WMASK_I[ 5]) memory[WADDR[7:0]][ 5] <= WDATA_I[ 5];
            if (!WMASK_I[ 6]) memory[WADDR[7:0]][ 6] <= WDATA_I[ 6];
            if (!WMASK_I[ 7]) memory[WADDR[7:0]][ 7] <= WDATA_I[ 7];
            if (!WMASK_I[ 8]) memory[WADDR[7:0]][ 8] <= WDATA_I[ 8];
            if (!WMASK_I[ 9]) memory[WADDR[7:0]][ 9] <= WDATA_I[ 9];
            if (!WMASK_I[10]) memory[WADDR[7:0]][10] <= WDATA_I[10];
            if (!WMASK_I[11]) memory[WADDR[7:0]][11] <= WDATA_I[11];
            if (!WMASK_I[12]) memory[WADDR[7:0]][12] <= WDATA_I[12];
            if (!WMASK_I[13]) memory[WADDR[7:0]][13] <= WDATA_I[13];
            if (!WMASK_I[14]) memory[WADDR[7:0]][14] <= WDATA_I[14];
            if (!WMASK_I[15]) memory[WADDR[7:0]][15] <= WDATA_I[15];
        end
    end

    always @(posedge RCLK) begin
        if (RE && RCLKE) begin
            RDATA_I <= memory[RADDR[7:0]] & ~RMASK_I;
        end
    end
`endif
`ifdef ICE40_HX
    specify
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_hx1k.txt#L343-L358
        $setup(MASK, posedge WCLK &&& WE && WCLKE, 274);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_hx1k.txt#L359-L369
        $setup(RADDR, posedge RCLK &&& RE && RCLKE, 203);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_hx1k.txt#L370
        $setup(RCLKE, posedge RCLK, 267);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_hx1k.txt#L371
        $setup(RE, posedge RCLK, 98);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_hx1k.txt#L372-L382
        $setup(WADDR, posedge WCLK &&& WE && WCLKE, 224);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_hx1k.txt#L383
        $setup(WCLKE, posedge WCLK, 267);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_hx1k.txt#L384-L399
        $setup(WDATA, posedge WCLK &&& WE && WCLKE, 161);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_hx1k.txt#L400
        $setup(WE, posedge WCLK, 133);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_hx1k.txt#L401
        (posedge RCLK => (RDATA : 16'bx)) = 2146;
    endspecify
`endif
`ifdef ICE40_LP
    specify
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_lp1k.txt#L343-L358
        $setup(MASK, posedge WCLK &&& WE && WCLKE, 403);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_lp1k.txt#L359-L369
        $setup(RADDR, posedge RCLK &&& RE && RCLKE, 300);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_lp1k.txt#L370
        $setup(RCLKE, posedge RCLK, 393);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_lp1k.txt#L371
        $setup(RE, posedge RCLK, 145);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_lp1k.txt#L372-L382
        $setup(WADDR, posedge WCLK &&& WE && WCLKE, 331);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_lp1k.txt#L383
        $setup(WCLKE, posedge WCLK, 393);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_lp1k.txt#L384-L399
        $setup(WDATA, posedge WCLK &&& WE && WCLKE, 238);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_lp1k.txt#L400
        $setup(WE, posedge WCLK, 196);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_lp1k.txt#L401
        (posedge RCLK => (RDATA : 16'bx)) = 3163;
    endspecify
`endif
`ifdef ICE40_U
    specify
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_up5k.txt#L12968-12983
        $setup(MASK, posedge WCLK &&& WE && WCLKE, 517);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_up5k.txt#L12984-12994
        $setup(RADDR, posedge RCLK &&& RE && RCLKE, 384);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_up5k.txt#L12995
        $setup(RCLKE, posedge RCLK, 503);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_up5k.txt#L12996
        $setup(RE, posedge RCLK, 185);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_up5k.txt#L12997-13007
        $setup(WADDR, posedge WCLK &&& WE && WCLKE, 424);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_up5k.txt#L13008
        $setup(WCLKE, posedge WCLK, 503);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_up5k.txt#L13009-13024
        $setup(WDATA, posedge WCLK &&& WE && WCLKE, 305);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_up5k.txt#L13025
        $setup(WE, posedge WCLK, 252);
        // https://github.com/cliffordwolf/icestorm/blob/95949315364f8d9b0c693386aefadf44b28e2cf6/icefuzz/timings_up5k.txt#L13026
        (posedge RCLK => (RDATA : 16'bx)) = 1179;
    endspecify
`endif
endmodule