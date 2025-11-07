/*
 * Copyright (c) 2025 Michael Pichler
 * SPDX-License-Identifier: Apache-2.0
 */


/*
	Simple 0 to 9 up and down counter with limits (0 and 9).
*/


`default_nettype none
`ifndef __COUNTER_0_to_9__
`define __COUNTER_0_to_9__


module counter_0_to_9 (
	// define I/O's of the module
	input  wire       clk_i,         // clock
	input  wire       rst_i,         // reset
	input  wire       incr_i,        // increment button
	input  wire       decr_i,        // decrement button
	output wire [3:0] counter_val_o  // 4-bit counter output
);

	reg [3:0] counter_val;		// register to store the counter value
	reg incr_prev, decr_prev; 	// remember previous button states

	always @(posedge clk_i) begin
		if (rst_i) begin
			counter_val <= 4'd0;
			incr_prev   <= 1'b0;
			decr_prev   <= 1'b0;
		end else begin
			// store previous button states
			incr_prev <= incr_i;
			decr_prev <= decr_i;

			// detect rising edge on incr_i
			if (incr_i && !incr_prev && counter_val < 4'd9)			// max value = 9 (one digit at 7-seg-disp)
				counter_val <= counter_val + 4'b0001;				// Add 4'b0001 to the prev val

			// detect rising edge on decr_i
			else if (decr_i && !decr_prev && counter_val > 4'd0)	// min vlaue = 0 (overflow)
				counter_val <= counter_val - 4'b0001;				// Subtract 4'b0001
		end
	end

  assign counter_val_o = counter_val;

endmodule

`endif
`default_nettype wire
