module clk_divider(clk_in, clk_out);

	input wire clk_in;
	output wire clk_out;

	reg [17:0] count_reg;

	always @(posedge clk_in) begin
		count_reg <= count_reg + 1'b1;
	end

	assign clk_out = count_reg[17];

endmodule
