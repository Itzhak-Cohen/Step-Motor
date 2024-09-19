module freq_sm(
    input en,           // from counter and freq divider
    input clk,
    input step_size,    // 0 = half step
    input dir,          // direction
    input on_switch,
    input quarter,      // 0 = do a quarter
    input resetb,
    output reg [3:0] motor,
	 output wire en_counter_check,  	// delete
	 output wire enable_check,			// delete
	 output wire prev_enable_check,	// delete
	 output wire [6:0] counter_check,			// delete
	 output wire count_ended_check 	// delete
);

parameter first = 4'b0001,
    second = 4'b0011,
    third = 4'b0010,
    fourth = 4'b0110,
    fifth = 4'b0100,
    sixth = 4'b1100,
    seventh = 4'b1000,
    eighth = 4'b1001;

reg [3:0] cs, ns;
reg prev_en;  // Register to store the previous value of enable.
reg restep;   // In full step - we step each state twice. therefore 0 = stepped once, 1 = stepped twice

// quarter staff:
wire count_ended;  // Change to wire
reg quarter_clicked;
reg quarter_on;

counter_quarter counter_quarter_inst
(
    .start_count(quarter_clicked),  // input start_count_sig
    .end_count(count_ended),        // output end_count_sig
    .enable(en),                    // input enable_sig
    .clk(clk),                      // input clk_sig
    .resetb(resetb),                // input resetb_sig
	 .en_counter_check(en_counter_check),		// output  en_counter_check_sig   	delete
	.enable_check(enable_check) ,				// output  enable_check_sig			delete
	.prev_enable_check(prev_enable_check), 	// output  prev_enable_check_sig		delete
	.counter_check(counter_check) 	// output [6:0] counter_check_sig					delete
);

// handling quarter_on
always @(posedge clk or negedge resetb)
    begin
        if (~resetb)
            begin
                quarter_on <= 1'b0;
            end
        else if (count_ended)   // was && en
            begin
                quarter_on <= 1'b0;
            end
        else if (quarter_clicked)
            begin
                quarter_on <= 1'b1;
            end
        else
            begin
                quarter_on <= 1'b0;
            end
    end

// handling quarter_clicked
always @(posedge clk or negedge resetb)
    begin
        if (~resetb)
            begin
                quarter_clicked <= 1'b0;
            end
        else if (count_ended)
            begin
                quarter_clicked <= 1'b0;
            end
        else if (~quarter)
            begin
                quarter_clicked <= 1'b1;
            end
        else
            begin
                quarter_clicked <= quarter_clicked;
            end
    end

assign motor_on = on_switch || quarter_on;
assign count_ended_check = count_ended;

// handle prev_en
always @(posedge clk or negedge resetb)
	begin
		if (~resetb)
			begin
				 prev_en <= 1'b0;
			end
		else
			prev_en <= en; // Store the current value of enable every cycle
	end


always @(posedge clk or negedge resetb)
    begin
        if (~resetb)
            begin
                cs <= 4'b0000;
                restep <= 1'b0;
            end
        else if (motor_on == 1'b1)  // motor_on is on
            begin
                if (step_size == 1'b0) // half step
                    begin
                        if (en && !prev_en) // Rising edge of enable
                            cs <= ns;
                    end
                else if (step_size == 1'b1) // full step
                    begin
                        if (restep == 1'b0) // if we didn't restep
                            begin
                                if (en && !prev_en) // Rising edge of enable
                                    begin
													 cs <= cs;
													 restep <= 1'b1;
                                    end
                            end
                        else // if we did restep
                            begin
                                if (en && !prev_en) // Rising edge of enable
                                    begin
                                        cs <= ns;
                                        restep <= 1'b0;
                                    end
                            end
                    end
            end     
        else  // motor_on is off
            begin
					cs <= cs; // cs <= 4'b0000;
            end
    end

// Next state logic
always @(cs or dir or step_size or restep)
    begin
        if (dir == 1'b1)  // clockwise
            begin
                if (step_size == 1'b0) // half step
                    begin
                        case(cs)
                            first:    ns = second;
                            second:   ns = third;
                            third:    ns = fourth;
                            fourth:   ns = fifth;
                            fifth:    ns = sixth;
                            sixth:    ns = seventh;
                            seventh:  ns = eighth;
                            eighth:   ns = first;
                            default:  ns = first; 
                        endcase // case (cs)
                    end 
                else // full step
                    begin
                        case(cs)
                            first:    ns = third;
                            third:    ns = fifth;
                            fifth:    ns = seventh;
                            seventh:  ns = first;
                            default:  ns = first; 
                        endcase // case (cs)
                    end // end of full step
            end  // end of direction
        else // counter-clockwise
            begin
                if (step_size == 1'b0) // half step
                    begin
                        case(cs)
                            first:    ns = eighth;
                            eighth:   ns = seventh;
                            seventh:  ns = sixth;
                            sixth:    ns = fifth;
                            fifth:    ns = fourth;
                            fourth:   ns = third;
                            third:    ns = second;
                            second:   ns = first;
                            default:  ns = first; 
                        endcase // case (cs)
                    end 
                else // full step
                    begin
                        case(cs)
                            first:    ns = seventh;
                            seventh:  ns = fifth;
                            fifth:    ns = third;
                            third:    ns = first;
                            default:  ns = first; 
                        endcase // case (cs)
                    end // end of full step
            end  // end of direction
    end // end of always

// Output logic
always @(cs)
    begin
        motor = cs;
    end

endmodule