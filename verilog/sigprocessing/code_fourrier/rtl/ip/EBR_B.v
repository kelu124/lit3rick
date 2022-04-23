`timescale 1ns/1ns
module EBR_B (RADDR10, RADDR9, RADDR8, RADDR7, RADDR6, RADDR5, RADDR4, RADDR3, RADDR2, RADDR1, RADDR0, WADDR10, WADDR9, WADDR8, WADDR7, WADDR6, WADDR5, WADDR4, WADDR3, WADDR2, WADDR1, WADDR0, MASK_N15, MASK_N14, MASK_N13, MASK_N12, MASK_N11, MASK_N10, MASK_N9, MASK_N8, MASK_N7, MASK_N6, MASK_N5, MASK_N4, MASK_N3, MASK_N2, MASK_N1, MASK_N0, WDATA15, WDATA14, WDATA13, WDATA12, WDATA11, WDATA10, WDATA9, WDATA8, WDATA7, WDATA6, WDATA5, WDATA4, WDATA3, WDATA2, WDATA1, WDATA0, RCLKE, RCLK, RE, WCLKE, WCLK, WE, RDATA15, RDATA14, RDATA13, RDATA12, RDATA11, RDATA10, RDATA9, RDATA8, RDATA7, RDATA6, RDATA5, RDATA4, RDATA3, RDATA2, RDATA1, RDATA0);

	//Port Type List [Expanded Bus/Bit]
	input RADDR10;
	input RADDR9;
	input RADDR8;
	input RADDR7;
	input RADDR6;
	input RADDR5;
	input RADDR4;
	input RADDR3;
	input RADDR2;
	input RADDR1;
	input RADDR0;
	input WADDR10;
	input WADDR9;
	input WADDR8;
	input WADDR7;
	input WADDR6;
	input WADDR5;
	input WADDR4;
	input WADDR3;
	input WADDR2;
	input WADDR1;
	input WADDR0;
	input MASK_N15;
	input MASK_N14;
	input MASK_N13;
	input MASK_N12;
	input MASK_N11;
	input MASK_N10;
	input MASK_N9;
	input MASK_N8;
	input MASK_N7;
	input MASK_N6;
	input MASK_N5;
	input MASK_N4;
	input MASK_N3;
	input MASK_N2;
	input MASK_N1;
	input MASK_N0;
	input WDATA15;
	input WDATA14;
	input WDATA13;
	input WDATA12;
	input WDATA11;
	input WDATA10;
	input WDATA9;
	input WDATA8;
	input WDATA7;
	input WDATA6;
	input WDATA5;
	input WDATA4;
	input WDATA3;
	input WDATA2;
	input WDATA1;
	input WDATA0;
	input RCLKE;
	input RCLK;
	input RE;
	input WCLKE;
	input WCLK;
	input WE;
	output RDATA15;
	output RDATA14;
	output RDATA13;
	output RDATA12;
	output RDATA11;
	output RDATA10;
	output RDATA9;
	output RDATA8;
	output RDATA7;
	output RDATA6;
	output RDATA5;
	output RDATA4;
	output RDATA3;
	output RDATA2;
	output RDATA1;
	output RDATA0;


	//Assigning input IP Ports to corresponding SW bit ports [Inputs]
	wire [10:0] RADDR;
	assign RADDR = {RADDR10, RADDR9, RADDR8, RADDR7, RADDR6, RADDR5, RADDR4, RADDR3, RADDR2, RADDR1, RADDR0};
	wire [10:0] WADDR;
	assign WADDR = {WADDR10, WADDR9, WADDR8, WADDR7, WADDR6, WADDR5, WADDR4, WADDR3, WADDR2, WADDR1, WADDR0};
	wire [15:0] MASK_N;
	assign MASK_N = {MASK_N15, MASK_N14, MASK_N13, MASK_N12, MASK_N11, MASK_N10, MASK_N9, MASK_N8, MASK_N7, MASK_N6, MASK_N5, MASK_N4, MASK_N3, MASK_N2, MASK_N1, MASK_N0};
	wire [15:0] WDATA;
	assign WDATA = {WDATA15, WDATA14, WDATA13, WDATA12, WDATA11, WDATA10, WDATA9, WDATA8, WDATA7, WDATA6, WDATA5, WDATA4, WDATA3, WDATA2, WDATA1, WDATA0};
	//Fanning IP Bus Output to Individual SW Bit [Outputs]
	wire [15:0] RDATA;
	assign RDATA0 = RDATA[0];
	assign RDATA1 = RDATA[1];
	assign RDATA2 = RDATA[2];
	assign RDATA3 = RDATA[3];
	assign RDATA4 = RDATA[4];
	assign RDATA5 = RDATA[5];
	assign RDATA6 = RDATA[6];
	assign RDATA7 = RDATA[7];
	assign RDATA8 = RDATA[8];
	assign RDATA9 = RDATA[9];
	assign RDATA10 = RDATA[10];
	assign RDATA11 = RDATA[11];
	assign RDATA12 = RDATA[12];
	assign RDATA13 = RDATA[13];
	assign RDATA14 = RDATA[14];
	assign RDATA15 = RDATA[15];

	//IP Ports Tied Off for Simulation
	//Attribute List
	parameter INIT_0 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_1 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_2 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_3 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_4 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_5 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_6 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_7 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_8 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_9 = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_A = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_B = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_C = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_D = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_E = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter INIT_F = "0x0000000000000000000000000000000000000000000000000000000000000000";
	parameter DATA_WIDTH_W = "2";
	parameter DATA_WIDTH_R = "2";
	 localparam MAX_STRING_LENGTH = 85;
 function [255:0] convertDeviceString; 
        input [(MAX_STRING_LENGTH)*8-1:0] attributeValue;

        integer i, j;
	integer decVal;
	real decPlace;
	integer temp, count;
	reg decimalFlag;
	reg [255:0] reverseVal;
	integer concatDec[255:0];
        reg [1:8] character;

        reg [7:0] checkType;
        begin 

	    decimalFlag = 1'b0;
	    decVal = 0;
	    decPlace = 1;
	    temp = 0;
	    count = 0;
	    for(i=0; i<=255; i=i+1) begin
	    	concatDec[i] = -1;
	    end
            convertDeviceString = 0;
            checkType = "N";
            for (i=MAX_STRING_LENGTH-1; i>=1 ; i=i-1) begin 
                for (j=1; j<=8; j=j+1) begin 

                    character[j] = attributeValue[i*8-j];
                end 

                //Check to see if binary or hex
                if (checkType === "N") begin 
                    if (character === "b" || character === "x") begin 
                        checkType = character;
			decimalFlag = 1'b1;
                    end else begin
			//Convert to string decimal to array of integers for each digit of the number
                        case(character) 
                            "0": concatDec[i-1] = 0;
                            "1": concatDec[i-1] = 1;
                            "2": concatDec[i-1] = 2;
                            "3": concatDec[i-1] = 3;
                            "4": concatDec[i-1] = 4;
                            "5": concatDec[i-1] = 5;
                            "6": concatDec[i-1] = 6;
                            "7": concatDec[i-1] = 7;
                            "8": concatDec[i-1] = 8;
                            "9": concatDec[i-1] = 9;
                            default: concatDec[i-1] = -1;
                        endcase 
		    end

                end else begin 

                    //$display("Index %d: %s", i, character);

                    //handle binary
                    if (checkType === "b") begin 
                        case(character) 
                            "0": convertDeviceString[i-1] = 1'b0;
                            "1": convertDeviceString[i-1] = 1'b1;
                            default: convertDeviceString[i-1] = 1'bx;
                        endcase 

                    //handle hex
                    end else if (checkType === "x") begin 
                        case(character)
                          "0" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h0;
                          "1" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h1;
                          "2" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h2;
                          "3" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h3;
                          "4" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h4;
                          "5" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h5;
                          "6" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h6;
                          "7" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h7;
                          "8" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h8;
                          "9" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'h9;
                          "a", "A" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'hA;
                          "b", "B" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'hB;
                          "c", "C" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'hC;
                          "d", "D" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'hD;
                          "e", "E" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'hE;
                          "f", "F" : {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'hF;
                          default: {convertDeviceString[i*4-1], convertDeviceString[i*4-2], convertDeviceString[i*4-3], convertDeviceString[(i-1)*4]} = 4'hX;     
                        endcase
                    end



                end 

            end 


	    //Calculate decmial value from integer array.
	    if(decimalFlag === 1'b0) begin
                for (i=0; i<=255 ; i=i+1) begin
                        case(concatDec[i]) 
                            0: temp = 0;
                            1: temp = 1;
                            2: temp = 2;
                            3: temp = 3;
                            4: temp = 4;
                            5: temp = 5;
                            6: temp = 6;
                            7: temp = 7;
                            8: temp = 8;
                            9: temp = 9;
                            default: temp = -1;
                        endcase 
			
			if(temp != -1) begin
				decVal = decVal + (temp * decPlace);
				count = count + 1;
				decPlace = 10 ** count;
			end
		end

		convertDeviceString = decVal;
	    end
        end
    endfunction 

	//Converted Attribute List [For Device Binary / Hex String]
	localparam CONVERTED_INIT_0 = convertDeviceString(INIT_0);
	localparam CONVERTED_INIT_1 = convertDeviceString(INIT_1);
	localparam CONVERTED_INIT_2 = convertDeviceString(INIT_2);
	localparam CONVERTED_INIT_3 = convertDeviceString(INIT_3);
	localparam CONVERTED_INIT_4 = convertDeviceString(INIT_4);
	localparam CONVERTED_INIT_5 = convertDeviceString(INIT_5);
	localparam CONVERTED_INIT_6 = convertDeviceString(INIT_6);
	localparam CONVERTED_INIT_7 = convertDeviceString(INIT_7);
	localparam CONVERTED_INIT_8 = convertDeviceString(INIT_8);
	localparam CONVERTED_INIT_9 = convertDeviceString(INIT_9);
	localparam CONVERTED_INIT_A = convertDeviceString(INIT_A);
	localparam CONVERTED_INIT_B = convertDeviceString(INIT_B);
	localparam CONVERTED_INIT_C = convertDeviceString(INIT_C);
	localparam CONVERTED_INIT_D = convertDeviceString(INIT_D);
	localparam CONVERTED_INIT_E = convertDeviceString(INIT_E);
	localparam CONVERTED_INIT_F = convertDeviceString(INIT_F);
	localparam CONVERTED_DATA_WIDTH_W = convertDeviceString(DATA_WIDTH_W);
	localparam CONVERTED_DATA_WIDTH_R = convertDeviceString(DATA_WIDTH_R);

	RAM40_4K EBR_inst(.RADDR(RADDR), .WADDR(WADDR), .MASK(MASK_N), .WDATA(WDATA), .RCLKE(RCLKE), .RCLK(RCLK), .RE(RE), .WCLKE(WCLKE), .WCLK(WCLK), .WE(WE), .RDATA(RDATA));
	defparam EBR_inst.INIT_0 = CONVERTED_INIT_0[255:0];
	defparam EBR_inst.INIT_1 = CONVERTED_INIT_1[255:0];
	defparam EBR_inst.INIT_2 = CONVERTED_INIT_2[255:0];
	defparam EBR_inst.INIT_3 = CONVERTED_INIT_3[255:0];
	defparam EBR_inst.INIT_4 = CONVERTED_INIT_4[255:0];
	defparam EBR_inst.INIT_5 = CONVERTED_INIT_5[255:0];
	defparam EBR_inst.INIT_6 = CONVERTED_INIT_6[255:0];
	defparam EBR_inst.INIT_7 = CONVERTED_INIT_7[255:0];
	defparam EBR_inst.INIT_8 = CONVERTED_INIT_8[255:0];
	defparam EBR_inst.INIT_9 = CONVERTED_INIT_9[255:0];
	defparam EBR_inst.INIT_A = CONVERTED_INIT_A[255:0];
	defparam EBR_inst.INIT_B = CONVERTED_INIT_B[255:0];
	defparam EBR_inst.INIT_C = CONVERTED_INIT_C[255:0];
	defparam EBR_inst.INIT_D = CONVERTED_INIT_D[255:0];
	defparam EBR_inst.INIT_E = CONVERTED_INIT_E[255:0];
	defparam EBR_inst.INIT_F = CONVERTED_INIT_F[255:0];
	defparam EBR_inst.DATA_WIDTH_W = CONVERTED_DATA_WIDTH_W;
	defparam EBR_inst.DATA_WIDTH_R = CONVERTED_DATA_WIDTH_R;


endmodule
