module DevBoardGPIO_Top(GPIO, CLOCK_50);
	inout logic [35:0] GPIO;
	input wire CLOCK_50;
	
	wire clk;
	
	clk_divider div(
		.clk_in(CLOCK_50), 
		.clk_out(clk)
	);
	
	burst_dds fred(	
		.ADDR({GPIO[12:0], 4'b0}),      //addresses        //SRAM Signals
		.DATA({GPIO[20:13],24'bZ}),      //data
		.SRAM_CLK(GPIO[29]),  //gated clock
		.ADSC(GPIO[21]),      //address statuses
		.ADSP(GPIO[27]),
		.ADV(GPIO[28]),       //address advance
		.BWE(GPIO[23]),       //byte write enable
		.CE({GPIO[26],1'b0,GPIO[25]}),        //chip enables
		.DATA_P(4'bZ),    //parity data
		.GW(GPIO[24]),        //global write enable
		.MODE(1'bZ),      //Burst Sequence Mode Select
		.OE(GPIO[22]),        //output enable
		.ZZ(1'bZ),        //snooze enable
		.MOSI(GPIO[33]),      //MOSI               //SPI Signals
		.MISO(1'bZ),      //MISO
		.SCK(GPIO[30]),    //SCK
		.SPI_CE(GPIO[32]),    //CPLD chip enable
		.TRIG(GPIO[31]),      //Trigger burst
		.HS_CLK(clk)     //100MHz CLK
	);


endmodule


module DevBoardGPIO_Top_tb();
	logic [35:0] GPIO;
	logic CLOCK_50;
	
	initial begin
		CLOCK_50 <= 1'b0;
	end
	
	DevBoardGPIO_Top DUT(GPIO, CLOCK_50);


endmodule