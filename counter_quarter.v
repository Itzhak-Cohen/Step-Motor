module counter_quarter(
    start_count,
    end_count,
    enable,
    clk,
    resetb,
    en_counter_check,        // to delete
    enable_check,            // to delete
    prev_enable_check,       // to delete
    counter_check            // to delete
);

// input and output declarations
input wire start_count;
input wire enable;
input wire clk;
input wire resetb;
output wire end_count;

// internal signals
reg [6:0] counter;  // should count to 100
reg [6:0] prev_counter; // used to check if counter is in negedge - then output end_count.
reg en_counter;
reg prev_enable;  // used to check if enable is rising
reg prev_start_count; // used to check if start_count is rising
wire end_count_internal;

// default parameter value
parameter TIME_TO_COUNT = 7'd100;

assign end_count_internal = (counter >= TIME_TO_COUNT);

// debugging checks: to delete
output wire en_counter_check;
output wire enable_check;
output wire prev_enable_check;
output wire [6:0] counter_check;

assign en_counter_check = en_counter;
assign enable_check = enable;
assign prev_enable_check = prev_enable;
assign counter_check = counter;

// counter enable logic
always @(posedge clk or negedge resetb)
    begin
        if (~resetb)
            begin
                en_counter <= 1'b0;
            end
        else
            begin
                if (start_count && ~prev_start_count)
                    begin
                        en_counter <= 1'b1;
                    end
                else if (end_count_internal)
                    begin
                        en_counter <= 1'b0;
                    end
                else
                    begin
                        en_counter <= en_counter;
                    end
            end
    end

// counter logic
always @(posedge clk or negedge resetb)
    begin
        if (~resetb)
            begin
                counter <= 7'd0;
            end
        else 
            begin
                if (en_counter && enable)  // deleted the prev_enable to check
                    begin
                        if (counter < TIME_TO_COUNT)
                            begin
                                counter <= counter + 7'd1;
                            end
                    end
                else if (end_count_internal && enable)  // deleted the prev_enable to check.
                    begin
                        counter <= 7'd0;
                    end
            end
    end

// prev_start_count, prev_enable, prev_counter logic
always @(posedge clk or negedge resetb)
    begin
        if (~resetb)
            begin
					prev_counter <= 7'd0;
					prev_start_count <= 1'b0;
					prev_enable <= 1'b0;
            end
        else
            begin
					prev_start_count <= start_count;
					prev_enable <= enable;
					prev_counter <= counter;
            end
    end
 
 assign end_count = end_count_internal;
 
//// end count signal logic
//always @(posedge clk or negedge resetb)
//    begin
//        if (~resetb)
//            begin
//                end_count <= 1'b0;
//            end
//        else if (prev_counter > counter)
//            begin
//                end_count <= 1'b1;
//            end
//        else
//            begin
//                end_count <= 1'b0;
//            end
//    end
     
endmodule // counter_quarter
