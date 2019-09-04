module acquisition_TB;
	reg clk;
	reg reset;
	
	reg en_acquisiton;
	wire en_write;
	
	parameter p = 2;
	acquisition acq(clk, reset, en_acquisiton, en_write);
	
	initial
	begin
		en_acquisiton 	= 0;
		reset 			= 0;
		#p 		en_acquisiton 	= 1;
		#(p*6)	en_acquisiton	= 0;
	end
	
	initial
	begin
		clk = 0;
		#(p/4) forever #(p/2) clk = ~clk;
	end

endmodule