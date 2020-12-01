// This module shows the logic for 7-segment active low display
// Note: active low means that a 0 bit will turn on the corresponding led,
// therefore we inverse all 7 bit codes before outputing them

module seg7 (in, led1, led0);

	input logic [3:0] in;  // 4 bit binary input
	output logic [6:0] led1, led0;  // output is 2 sets of 7 bits that correspond to leds within two different HEX displays
	always_comb begin
		case (in)  // try all different cases of input (0-15)
			4'b0000: begin led1 = ~7'b0111111; led0 = ~7'b0111111; end // 00
			4'b0001: begin led1 = ~7'b0111111; led0 = ~7'b0000110; end // 01
			4'b0010: begin led1 = ~7'b0111111; led0 = ~7'b1011011; end // 02
			4'b0011: begin led1 = ~7'b0111111; led0 = ~7'b1001111; end // 03
			4'b0100: begin led1 = ~7'b0111111; led0 = ~7'b1100110; end // 04
			4'b0101: begin led1 = ~7'b0111111; led0 = ~7'b1101101; end // 05
			4'b0110: begin led1 = ~7'b0111111; led0 = ~7'b1111101; end // 06
			4'b0111: begin led1 = ~7'b0111111; led0 = ~7'b0000111; end // 07
			4'b1000: begin led1 = ~7'b0111111; led0 = ~7'b1111111; end // 08
			4'b1001: begin led1 = ~7'b0111111; led0 = ~7'b1101111; end // 09
			4'b1010: begin led1 = ~7'b0000110; led0 = ~7'b0111111; end // 10
			4'b1011: begin led1 = ~7'b0000110; led0 = ~7'b0000110; end // 11
			4'b1100: begin led1 = ~7'b0000110; led0 = ~7'b1011011; end // 12
			4'b1101: begin led1 = ~7'b0000110; led0 = ~7'b1001111; end // 13
			4'b1110: begin led1 = ~7'b0000110; led0 = ~7'b1100110; end // 14
			4'b1111: begin led1 = ~7'b0000110; led0 = ~7'b1101101; end // 15
			default: begin led1 = 7'bX; led0 = 7'bx; end  // other cases that have not been covered in the cases above
		endcase
	end

endmodule

module seg7_testbench();  // simulation code for seg7
	logic [3:0] in;
	logic [6:0] led1, led0;

	seg7 dut (in, led1, led0);

	integer i;
	initial begin
		for (i = 0; i < 2**4; i++) begin
			in = i; #10;  // try all combinations of inputs
		end
	end
endmodule
