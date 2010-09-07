module AC97(
	input bitclk);
	
	wire [35:0] cs_control0;
	
	chipscope_icon cs_icon0(
	    .CONTROL0(cs_control0) // INOUT BUS [35:0]
	);
	
	chipscope_ila cs_ila0 (
	    .CONTROL(cs_control0), // INOUT BUS [35:0]
	    .CLK(bitclk), // IN
	    .TRIG0(256'b0) // IN BUS [255:0]
	);
endmodule

