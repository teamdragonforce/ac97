module AC97(
	input ac97_bitclk,
	input ac97_sdata_in,
	output wire ac97_sdata_out,
	output wire ac97_sync,
	output wire ac97_reset_b);

	assign ac97_reset_b = 1;
	
	// We may want to make this into a state machine eventually.
	reg [7:0] curbit = 8'h0;	// Contains the bit currently on the bus.
	/* Bit order is reversed; msb of tag sent first. */
	wire [0:255] outbits = {16'b1110000000000000, /* TAG */
	                        20'b1_1111100_000000000000, /* codec command address */
	                        20'h00000, /* codec command data */
	                        20'h00000, /* pcm left */
	                        20'h00000, /* pcm right */
	                        20'h00000, /* modem line 1 */
	                        20'h00000, /* pcm center */
	                        20'h00000, /* pcm left surround */
	                        20'h00000, /* pcm right surround */
	                        20'h00000, /* pcm lfe */
	                        20'h00000, /* pcm left +1 */
	                        20'h00000, /* pcm right +1 */
	                        20'h00000  /* pcm center +1  */
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

	chipscope_icon cs_icon0(
	    .CONTROL0(cs_control0) // INOUT BUS [35:0]
	);
	
	chipscope_ila cs_ila0 (
	    .CONTROL(cs_control0), // INOUT BUS [35:0]
	    .CLK(ac97_bitclk), // IN
	    .TRIG0({'b0, ac97_sdata_out, inbits[curbit], ac97_sync, curbit[7:0]}) // IN BUS [255:0]
	);
endmodule

