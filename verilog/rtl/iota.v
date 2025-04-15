module Iota (
	rc,
	chi,
	iota
);
	reg _sv2v_0;
	input wire [63:0] rc;
	input wire [1599:0] chi;
	output reg [1599:0] iota;
	always @(*) begin
		if (_sv2v_0)
			;
		iota[1536+:64] = chi[1536+:64] ^ rc;
		iota[1472+:64] = chi[1472+:64];
		iota[1408+:64] = chi[1408+:64];
		iota[1344+:64] = chi[1344+:64];
		iota[1280+:64] = chi[1280+:64];
		iota[1216+:64] = chi[1216+:64];
		iota[1152+:64] = chi[1152+:64];
		iota[1088+:64] = chi[1088+:64];
		iota[1024+:64] = chi[1024+:64];
		iota[960+:64] = chi[960+:64];
		iota[896+:64] = chi[896+:64];
		iota[832+:64] = chi[832+:64];
		iota[768+:64] = chi[768+:64];
		iota[704+:64] = chi[704+:64];
		iota[640+:64] = chi[640+:64];
		iota[576+:64] = chi[576+:64];
		iota[512+:64] = chi[512+:64];
		iota[448+:64] = chi[448+:64];
		iota[384+:64] = chi[384+:64];
		iota[320+:64] = chi[320+:64];
		iota[256+:64] = chi[256+:64];
		iota[192+:64] = chi[192+:64];
		iota[128+:64] = chi[128+:64];
		iota[64+:64] = chi[64+:64];
		iota[0+:64] = chi[0+:64];
	end
	initial _sv2v_0 = 0;
endmodule
