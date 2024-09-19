module counter_cycle(
    input wire clk,             // 50 MHz clock signal
    input wire [31:0] cycles,      // Target count value
    output reg carry_out        // Carry out signal when count is done
);

 reg [31:0] count;           // Current count value

 always @(posedge clk)
	begin
		if (count < cycles)
			begin
				count <= count + 32'b1;
				carry_out <= 1'b0;
		end else begin
			count <= 32'b0;      // Reset count to 0 after reaching the target
			carry_out <= 1'b1;  // Assert carry out signal
		end
	end

endmodule
