// ==============================================================================
// --
//
// Version      : V 1.0
// Creation     : 02/09/2019
// Update       : --
// Created by   : KHOYRATEE Farad
// Updated by   : KHOYRATEE Farad
// 
// Description  : 
//
// Update       : 	
//
// ===============================================================================

`timescale 1ns/10ps

`define ADCDATA 12
`define DACDATA 12
`define	NSAMPLE 10
`define MEMSIZE 255

module serializer(clk, reset, en, datai, datao);
	input 	clk;
	input 	reset;
	input 	en;
	
	input [`DACDATA-1:0]	datai;
	output 					datao;

	reg [1:0]				fsm=0;
	reg 					sdata=0;
	reg [`DACDATA-1:0]		datatmp;
	
	// Finite State Machine
	assign datao = sdata;
	always @ (posedge clk)
	begin
		if (reset == 1)
			fsm <= 0;
		else
		begin
			case(fsm)
				// IDLE
				0 : begin
						datatmp	<= datai;
						sdata 	<= 0;
						
						if (en == 1)
							fsm <= 1;
						else
							fsm <= 0;
						end

				// Serialize
				1 : begin
						datatmp[`DACDATA-1:1] 	<= datatmp[`DACDATA-2:0];
						sdata 					<= datatmp[`DACDATA-1];
						
						if (cnt > `DACDATA-2)
							fsm <= 0;
						else
							fsm <= 1;
						end
			endcase
		end
	end
	
	// Counter for acquisition
	reg [3:0]	cnt='b0000;
	always @ (posedge clk)
	begin
		if (reset == 1)
			cnt <= 'b0000;	
		else
			if (fsm == 1)
				cnt <= cnt + 1;
			else
				cnt <= 'b0000;
			end
	
endmodule