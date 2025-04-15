`include "/Users/azhar/test/verilog/rtl/Theta.v"
`include "/Users/azhar/test/verilog/rtl/Rho.v"
`include "/Users/azhar/test/verilog/rtl/Pi.v"
`include "/Users/azhar/test/verilog/rtl/Chi.v"
`include "/Users/azhar/test/verilog/rtl/Iota.v"
module fn (
	rc,
	A,
	X
);
	input wire [63:0] rc;
	input wire [1599:0] A;
	output wire [1599:0] X;
	wire [1599:0] T;
	wire [1599:0] R;
	wire [1599:0] P;
	wire [1599:0] C;
	Theta u_theta(
		.A(A),
		.theta(T)
	);
	Rho u_rho(
		.theta_in(T),
		.rho(R)
	);
	Pi u_pi(
		.rho_in(R),
		.pi(P)
	);
	Chi u_chi(
		.B(P),
		.chi(C)
	);
	Iota u_iota(
		.rc(rc),
		.chi(C),
		.iota(X)
	);
endmodule
