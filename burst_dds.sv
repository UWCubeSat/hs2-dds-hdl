/*///////////////////////////////////////////////////////////////////////////////////
 * Burst DDS
 * Hans Gaensbauer
 * 11-14-2020
 * Husky Satellite Lab
 *
 * This design receives data from an MCP2210 USB-SPI Converter, and writes it into 
 * an external SRAM. It can also empty the SRAM into a DAC at 100MHz.
*////////////////////////////////////////////////////////////////////////////////////

module burst_dds(
	ADDR,      //addresses        //SRAM Signals
	DATA,      //data
	SRAM_CLK,  //gated clock
	ADSC,      //address statuses
	ADSP,
	ADV,       //address advance
	BWE,       //byte write enable
	CE,        //chip enables
	DATA_P,    //parity data
	GW,        //global write enable
	MODE,      //Burst Sequence Mode Select
	OE,        //output enable
	ZZ,        //snooze enable
	MOSI,      //MOSI               //SPI Signals
	MISO,      //MISO
	SCKe,       //SCK
	SPI_CE,    //CPLD chip enable
	TRIG,      //Trigger burst
	HS_CLK,     //100MHz CLK
	CLOCK_50
	);
	
	
	output wire [16:0] ADDR;  //SRAM Signals
	output logic [31:0] DATA;
	output logic SRAM_CLK, ADSC, ADSP, ADV, BWE, GW, MODE, ZZ;
	output logic OE;
	output logic [2:0] CE;
	output logic [3:0] DATA_P;
	
	input wire MOSI, SCKe, SPI_CE;  //SPI Signals
	output logic MISO;
	
	input wire TRIG, HS_CLK, CLOCK_50;     //external signals
	
	//statics
	assign DATA_P = 4'bZ;
	assign ADSP = 1'b1;
	assign ADV = 1'b1;
	assign BWE = 1'b1;	
	assign MODE = 1'b0;
	assign MISO = 1'b1;
	assign ZZ = 1'b0; //not snoozing
	
	//internal registers
	logic [16:0] addr_spi = 12'b0; //internal address from SPI
	logic [16:0] addr_burst = 12'b0; //internal address from SPI
	logic [31:0] spi_shift_reg = 31'b0;
	logic [4:0] shift_counter = 5'b0;
	logic [16:0] addr_counter = 12'b0;
	logic trig_last;
	wire clk;
	wire SCK;
	
//	debouncer james(SCKe, SCK, CLOCK_50);
	assign SCK = SCKe;
	
	//tri-states
	assign ADDR = trig_last ? addr_burst : addr_spi; //burst or pulse
	assign SRAM_CLK = TRIG ? HS_CLK : SCK;
	assign OE = (TRIG) ? 1'b0 : 1'b1;
	assign DATA = GW ? 32'bZ : addr_spi;
	
	//SPI Shiftin
	always @(posedge SCK) begin
		if(!SPI_CE && !(shift_counter == 5'b0)) begin
			spi_shift_reg[31:1] <= spi_shift_reg[30:0];
			spi_shift_reg[0] <= MOSI;
		end
	end
	
	//Count
	always @(negedge SCK) begin
		if(SPI_CE) begin
			shift_counter <= 32'b0;
		end else begin
			shift_counter <= (shift_counter + 1'b1);
		end
		case(shift_counter) //31 shifts
			5'b11110: begin
				addr_spi <= addr_counter; //update address
				ADSC <= 1'b0;         //Controller address ready
				CE <= 3'b010;         //
			end
			5'b11111: begin //32 shifts
				addr_counter <= (addr_counter + 1'b1);
				GW <= 1'b0;           //Global Write
			end
			default: begin
				GW <= 1'b1;
			end
		endcase
	end
	
	always @(posedge HS_CLK) begin
		if(~trig_last && TRIG) begin
			addr_burst <= 17'b0;
		end else begin
			addr_burst <= addr_burst + 1'b1;
		end
		trig_last <= TRIG;
	end
		
endmodule

module burst_dds_tb();

	wire [11:0] ADDR;  //SRAM Signals
	wire [31:0] DATA;
	wire SRAM_CLK, ADSC, ADSP, ADV, BWE, GW, MODE, OE, ZZ;
	wire [2:0] CE;
	wire [3:0] DATA_P;
	
	logic MOSI, SCK, SPI_CE, TRIG, HS_CLK;  //SPI Signals
	wire MISO;

	burst_dds DUT(
		ADDR,      //addresses        //SRAM Signals
		DATA,      //data
		SRAM_CLK,  //gated clock
		ADSC,      //address statuses
		ADSP,
		ADV,       //address advance
		BWE,       //byte write enable
		CE,        //chip enables
		DATA_P,    //parity data
		GW,        //global write enable
		MODE,      //Burst Sequence Mode Select
		OE,        //output enable
		ZZ,        //snooze enable
		MOSI,      //MOSI               //SPI Signals
		MISO,      //MISO
		SCK,       //SCK
		SPI_CE,    //CPLD chip enable
		TRIG,      //Trigger burst
		HS_CLK     //100MHz CLK
		);
	
	initial begin
		MOSI <= 1'b1;
		SPI_CE <= 1'b0;
		SCK <= 1'b0;
		TRIG <= 1'b0;
		#5;
		for (int i = 0; i < 360; i++) begin
			SCK <= ~SCK;
			#10;
		end
		SPI_CE <= 1'b1;
		#5;
		TRIG <= 1'b1;
	end
	
	initial begin
		HS_CLK <= 1'b0;
		forever begin
			#1;
			HS_CLK <= ~HS_CLK;
		end
	end
	
endmodule
	
	