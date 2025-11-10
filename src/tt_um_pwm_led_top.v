/*
 * Copyright (c) 2025 Michael Pichler
 * SPDX-License-Identifier: Apache-2.0
 */

/*
	Generates PWM-signal
	Displays current duty-cycle-level at 7seg-disp
	DutyCycle-Level can be increased and decreased with button 0 and 1
	Brightnes of the dot on the 7seg display is controlled by the PWM-signal
*/

`default_nettype none

`include "counter_0_to_9.v"
`include "counter_to_7seg.v"
`include "pwm_generator.v"

module tt_um_pwm_led_top (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
	
	// Declare wire to hold counter output
	wire [3:0] 	counter_val;
	wire [6:0] 	seg7;
	wire 		pwm_sig;

	// Instantiate the counter module
	counter_0_to_9 cnt9(
		.incr_i(ui_in[0]),              // Connect button 0 to increase counter
		.decr_i(ui_in[1]),              // Connect button 1 to decrease counter
		.clk_i(clk),                    // Connect clock
		.rst_i(~rst_n),                 // Connect reset (inverted since rst_n is active low)
		.counter_val_o(counter_val)     // Connect counter output
	);


  counter_to_7seg display_driver(
    .count_i(counter_val),  	// connect input
    .seg_o(seg7)      		 	// connect output
  );

  pwm_generator pwm_gen(
    .duty_level_i(counter_val),
    .clk_i(clk),
    .rst_i(~rst_n),
    .pwm_sig_o(pwm_sig)
  );
  
	// All output pins must be assigned. If not used, assign to 0.
	assign uo_out[6:0] = seg7;     	// Output the 7-seg values (decimal representation of the counter value)
	assign uo_out[7] = pwm_sig;
	assign uio_out = 0;
	assign uio_oe  = 0;

	// List all unused inputs to prevent warnings
	wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule
