module AC97(
	input       ac97_bitclk,
	input       ac97_sdata_in,
	output wire ac97_sdata_out,
	output wire ac97_sync,
	output wire ac97_reset_b);

	wire        ac97_out_slot1_valid = 1;
        wire [19:0] ac97_out_slot1 = {1'b1 /* read */, 7'h7C /* address */, 12'b0 /* reserved */};
        wire        ac97_out_slot2_valid = 1;
        wire [19:0] ac97_out_slot2 = 'h0;
        wire        ac97_out_slot3_valid = 0;
        wire [19:0] ac97_out_slot3 = 'h0;
        wire        ac97_out_slot4_valid = 0;
        wire [19:0] ac97_out_slot4 = 'h0;
        wire        ac97_out_slot5_valid = 0;
        wire [19:0] ac97_out_slot5 = 'h0;
        wire        ac97_out_slot6_valid = 0;
        wire [19:0] ac97_out_slot6 = 'h0;
        wire        ac97_out_slot7_valid = 0;
        wire [19:0] ac97_out_slot7 = 'h0;
        wire        ac97_out_slot8_valid = 0;
        wire [19:0] ac97_out_slot8 = 'h0;
        wire        ac97_out_slot9_valid = 0;
        wire [19:0] ac97_out_slot9 = 'h0;
        wire        ac97_out_slot10_valid = 0;
        wire [19:0] ac97_out_slot10 = 'h0;
        wire        ac97_out_slot11_valid = 0;
        wire [19:0] ac97_out_slot11 = 'h0;
        wire        ac97_out_slot12_valid = 0;
        wire [19:0] ac97_out_slot12 = 'h0;
        
	ACLink link(
		/*AUTOINST*/
		    // Outputs
		    .ac97_sdata_out	(ac97_sdata_out),
		    .ac97_sync		(ac97_sync),
		    .ac97_reset_b	(ac97_reset_b),
		    // Inputs
		    .ac97_bitclk	(ac97_bitclk),
		    .ac97_sdata_in	(ac97_sdata_in),
		    .ac97_out_slot1	(ac97_out_slot1[19:0]),
		    .ac97_out_slot1_valid(ac97_out_slot1_valid),
		    .ac97_out_slot2	(ac97_out_slot2[19:0]),
		    .ac97_out_slot2_valid(ac97_out_slot2_valid),
		    .ac97_out_slot3	(ac97_out_slot3[19:0]),
		    .ac97_out_slot3_valid(ac97_out_slot3_valid),
		    .ac97_out_slot4	(ac97_out_slot4[19:0]),
		    .ac97_out_slot4_valid(ac97_out_slot4_valid),
		    .ac97_out_slot5	(ac97_out_slot5[19:0]),
		    .ac97_out_slot5_valid(ac97_out_slot5_valid),
		    .ac97_out_slot6	(ac97_out_slot6[19:0]),
		    .ac97_out_slot6_valid(ac97_out_slot6_valid),
		    .ac97_out_slot7	(ac97_out_slot7[19:0]),
		    .ac97_out_slot7_valid(ac97_out_slot7_valid),
		    .ac97_out_slot8	(ac97_out_slot8[19:0]),
		    .ac97_out_slot8_valid(ac97_out_slot8_valid),
		    .ac97_out_slot9	(ac97_out_slot9[19:0]),
		    .ac97_out_slot9_valid(ac97_out_slot9_valid),
		    .ac97_out_slot10	(ac97_out_slot10[19:0]),
		    .ac97_out_slot10_valid(ac97_out_slot10_valid),
		    .ac97_out_slot11	(ac97_out_slot11[19:0]),
		    .ac97_out_slot11_valid(ac97_out_slot11_valid),
		    .ac97_out_slot12	(ac97_out_slot12[19:0]),
		    .ac97_out_slot12_valid(ac97_out_slot12_valid));
	
endmodule

module ACLink(
	input ac97_bitclk,
	input ac97_sdata_in,
	output wire ac97_sdata_out,
	output wire ac97_sync,
	output wire ac97_reset_b,
	
	input [19:0] ac97_out_slot1,
	input        ac97_out_slot1_valid,
	input [19:0] ac97_out_slot2,
	input        ac97_out_slot2_valid,
	input [19:0] ac97_out_slot3,
	input        ac97_out_slot3_valid,
	input [19:0] ac97_out_slot4,
	input        ac97_out_slot4_valid,
	input [19:0] ac97_out_slot5,
	input        ac97_out_slot5_valid,
	input [19:0] ac97_out_slot6,
	input        ac97_out_slot6_valid,
	input [19:0] ac97_out_slot7,
	input        ac97_out_slot7_valid,
	input [19:0] ac97_out_slot8,
	input        ac97_out_slot8_valid,
	input [19:0] ac97_out_slot9,
	input        ac97_out_slot9_valid,
	input [19:0] ac97_out_slot10,
	input        ac97_out_slot10_valid,
	input [19:0] ac97_out_slot11,
	input        ac97_out_slot11_valid,
	input [19:0] ac97_out_slot12,
	input        ac97_out_slot12_valid
	);
	
	assign ac97_reset_b = 1;
	
	// We may want to make this into a state machine eventually.
	reg [7:0] curbit = 8'h0;	// Contains the bit currently on the bus.
	/* Bit order is reversed; msb of tag sent first. */
	wire [0:255] outbits = { /* TAG */
	                         1'b1,
	                         ac97_out_slot1_valid,
	                         ac97_out_slot2_valid,
	                         ac97_out_slot3_valid,
	                         ac97_out_slot4_valid,
	                         ac97_out_slot5_valid,
	                         ac97_out_slot6_valid,
	                         ac97_out_slot7_valid,
	                         ac97_out_slot8_valid,
	                         ac97_out_slot9_valid,
	                         ac97_out_slot10_valid,
	                         ac97_out_slot11_valid,
	                         ac97_out_slot12_valid,
	                         3'b000,
	                         ac97_out_slot1_valid ? ac97_out_slot1 : 20'h0,
	                         ac97_out_slot2_valid ? ac97_out_slot2 : 20'h0,
	                         ac97_out_slot3_valid ? ac97_out_slot3 : 20'h0,
	                         ac97_out_slot4_valid ? ac97_out_slot4 : 20'h0,
	                         ac97_out_slot5_valid ? ac97_out_slot5 : 20'h0,
	                         ac97_out_slot6_valid ? ac97_out_slot6 : 20'h0,
	                         ac97_out_slot7_valid ? ac97_out_slot7 : 20'h0,
	                         ac97_out_slot8_valid ? ac97_out_slot8 : 20'h0,
	                         ac97_out_slot9_valid ? ac97_out_slot9 : 20'h0,
	                         ac97_out_slot10_valid ? ac97_out_slot10 : 20'h0,
	                         ac97_out_slot11_valid ? ac97_out_slot11 : 20'h0,
	                         ac97_out_slot12_valid ? ac97_out_slot12 : 20'h0
	                         };
	reg [255:0] inbits = 256'h0;
	
	always @(posedge ac97_bitclk)
		curbit <= curbit + 1;
	
	always @(negedge ac97_bitclk)
		inbits[curbit] <= ac97_sdata_in;
	
	/* Spec sez: rising edge should be in the middle of the final bit of
	 * the last slot, and the falling edge should be in the middle of
	 * the final bit of the TAG slot.
	 */
	assign ac97_sync = (curbit == 255) || (curbit < 15); 
	
	/* Spec sez: should transition shortly after the rising edge.  In
	 * the end, we probably want to flop this to guarantee that.  Sample
	 * on the falling edge.
	 */
	assign ac97_sdata_out = outbits[curbit];

	wire [35:0] cs_control0;

	chipscope_icon icon0(
		.CONTROL0(cs_control0) // INOUT BUS [35:0]
	);
	
	chipscope_ila ila0 (
		.CONTROL(cs_control0), // INOUT BUS [35:0]
		.CLK(ac97_bitclk), // IN
		.TRIG0({'b0, ac97_sdata_out, inbits[curbit], ac97_sync, curbit[7:0]}) // IN BUS [255:0]
	);
	
endmodule
