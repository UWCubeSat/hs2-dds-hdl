module debouncer(button_in, button_out, clk_in);

	input logic button_in, clk_in;
	output logic button_out;
	
	wire counter_reset;
	reg [14:0] count_reg;
	
	reg butstate;
	reg prevstate;
	
	always @(posedge clk_in) begin
		prevstate = butstate;
		butstate = button_in;
	end
	
	assign counter_reset = (prevstate != butstate);
	
	always  @(posedge clk_in) begin
		if(counter_reset) count_reg <= 15'b0;
		else if(count_reg == 15'b111111111111111) begin
			count_reg = 15'b111111111111111;
			button_out = prevstate;
		end
		else count_reg  <= count_reg + 1'b1;
	end
	
endmodule