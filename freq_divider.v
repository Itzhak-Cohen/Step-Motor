module freq_divider(
	input wire [2:0] speed_in,    	// 3-bit input
	output reg [31:0] cycles     	// 32-bit output to accommodate large numbers
);

always @(*)
	begin
		case (speed_in)
			3'b000: cycles = 0;
			3'b001: cycles = 750000;   // Input 10 -> Output 750000
			3'b010: cycles = 375000;   // Input 20 -> Output 375000
			3'b011: cycles = 250000;   // Input 30 -> Output 250000
			3'b100: cycles = 187500;  // Input 40 -> Output 187500
			3'b101: cycles = 150000;  // Input 50 -> Output 150000
			3'b110: cycles = 125000;  // Input 60 -> Output 125000
			default: cycles = 750000;       // Default is for 10 cycles per minute
		endcase
	end
	
endmodule
// note - for full step we just step twice on the same motor-output with the same freq.
