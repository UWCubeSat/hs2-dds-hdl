
module devboard (CLOCK_50, KEY, LEDR);
	
	input wire CLOCK_50; // 50MHz clock.
	
	//inputs and outputs
	output wire [9:0] LEDR;
	input wire [3:0] KEY;
	
	assign LEDR = 10'b1111111111;
	
	
endmodule
