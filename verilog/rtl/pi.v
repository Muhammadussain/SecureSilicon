module Pi (
	rho_in,
	pi
);
	reg _sv2v_0;
	input wire [1599:0] rho_in;
	output reg [1599:0] pi;
	always @(*) begin
		if (_sv2v_0)
			;
		pi[1536+:64] = rho_in[1536+:64];
		pi[1472+:64] = rho_in[576+:64];
		pi[1408+:64] = rho_in[1216+:64];
		pi[1344+:64] = rho_in[256+:64];
		pi[1280+:64] = rho_in[896+:64];
		pi[1216+:64] = rho_in[1152+:64];
		pi[1152+:64] = rho_in[192+:64];
		pi[1088+:64] = rho_in[832+:64];
		pi[1024+:64] = rho_in[1472+:64];
		pi[960+:64] = rho_in[512+:64];
		pi[896+:64] = rho_in[768+:64];
		pi[832+:64] = rho_in[1408+:64];
		pi[768+:64] = rho_in[448+:64];
		pi[704+:64] = rho_in[1088+:64];
		pi[640+:64] = rho_in[128+:64];
		pi[576+:64] = rho_in[384+:64];
		pi[512+:64] = rho_in[1024+:64];
		pi[448+:64] = rho_in[64+:64];
		pi[384+:64] = rho_in[704+:64];
		pi[320+:64] = rho_in[1344+:64];
		pi[256+:64] = rho_in[0+:64];
		pi[192+:64] = rho_in[640+:64];
		pi[128+:64] = rho_in[1280+:64];
		pi[64+:64] = rho_in[320+:64];
		pi[0+:64] = rho_in[960+:64];
	end
	initial _sv2v_0 = 0;
endmodule
