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

module acquisition#(NSAMPLE=10, ADDRSIZE = 7)(clk, reset, en_acquisition, en_write, RAM_addr);
	input 	clk;
	input 	reset;
	
	input 					en_acquisition;
	output 					en_write;
	output [ADDRSIZE-1:0]	RAM_addr;
	
	reg 					aqu_fsm=0;
	reg [ADDRSIZE-1:0]		acq_time='b0000;
	
	// Finite State Machine
	assign 		en_write = aqu_fsm;
	always @ (posedge clk)
	begin
		if (reset == 1)
			aqu_fsm <= 0;
		else
		begin
			case(aqu_fsm)
				// IDLE
				0 : begin
						if (en_acquisition == 1)
							aqu_fsm <= 1;
						else
							aqu_fsm <= 0;
						end

				// ACQUISITION
				1 : begin
						if (acq_time > NSAMPLE-2)
							aqu_fsm <= 0;
						else
							aqu_fsm <= 1;
						end
			endcase
		end
	end
		
	// Counter for acquisition
	assign RAM_addr = acq_time;
	always @ (posedge clk)
	begin
		if (reset == 1)
			acq_time <= 'b0000;	
		else
			if (aqu_fsm == 1)
				acq_time <= acq_time + 1;
			else
				acq_time <= 'b0000;
			end
	
endmodule