`include "/Users/azhar/test/verilog/rtl/top.v"
module fn_top (
	clk,
	rst,
	en,
	round_start,
	A,
	X,
	round_done
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire en;
	input wire round_start;
	input wire [1599:0] A;
	output wire [1599:0] X;
	output wire round_done;
	wire [1599:0] temp_out;
	reg [63:0] RC [0:23];
	reg [1599:0] temp_in;
	reg r_temp;
	reg [63:0] rc_temp;
	always @(*) begin
		if (_sv2v_0)
			;
		RC[0] = 64'h0000000000000001;
		RC[1] = 64'h0000000000008082;
		RC[2] = 64'h800000000000808a;
		RC[3] = 64'h8000000080008000;
		RC[4] = 64'h000000000000808b;
		RC[5] = 64'h0000000080000001;
		RC[6] = 64'h8000000080008081;
		RC[7] = 64'h8000000000008009;
		RC[8] = 64'h000000000000008a;
		RC[9] = 64'h0000000000000088;
		RC[10] = 64'h0000000080008009;
		RC[11] = 64'h000000008000000a;
		RC[12] = 64'h000000008000808b;
		RC[13] = 64'h800000000000008b;
		RC[14] = 64'h8000000000008089;
		RC[15] = 64'h8000000000008003;
		RC[16] = 64'h8000000000008002;
		RC[17] = 64'h8000000000000080;
		RC[18] = 64'h000000000000800a;
		RC[19] = 64'h800000008000000a;
		RC[20] = 64'h8000000080008081;
		RC[21] = 64'h8000000000008080;
		RC[22] = 64'h0000000080000001;
		RC[23] = 64'h8000000080008008;
	end
	reg [4:0] count;
	always @(posedge clk or posedge rst)
		if (!en) begin
			count <= 0;
			r_temp <= 0;
			rc_temp <= 64'h0000000000000000;
			temp_in <= {5 {320'b0}};
		end
		else begin
			if ((count >= 0) && (count < 24))
				rc_temp <= RC[count];
			if (count == 24)
				r_temp <= 1;
			else
				r_temp <= 0;
			if (count == 0)
				temp_in <= A;
			else if ((count >= 1) && (count < 24))
				temp_in <= temp_out;
			if (round_start) begin
				if (count == 25)
					count <= 0;
				else
					count <= count + 1;
			end
			else
				count <= count;
		end
	fn u_fn_78(
		.rc(rc_temp),
		.A(temp_in),
		.X(temp_out)
	);
	assign X[63:0] = temp_out[1536+:64];
	assign X[127:64] = temp_out[1216+:64];
	assign X[191:128] = temp_out[896+:64];
	assign X[255:192] = temp_out[576+:64];
	assign X[319:256] = temp_out[256+:64];
	assign X[383:320] = temp_out[1472+:64];
	assign X[447:384] = temp_out[1152+:64];
	assign X[511:448] = temp_out[832+:64];
	assign X[575:512] = temp_out[512+:64];
	assign X[639:576] = temp_out[192+:64];
	assign X[703:640] = temp_out[1408+:64];
	assign X[767:704] = temp_out[1088+:64];
	assign X[831:768] = temp_out[768+:64];
	assign X[895:832] = temp_out[448+:64];
	assign X[959:896] = temp_out[128+:64];
	assign X[1023:960] = temp_out[1344+:64];
	assign X[1087:1024] = temp_out[1024+:64];
	assign X[1151:1088] = temp_out[704+:64];
	assign X[1215:1152] = temp_out[384+:64];
	assign X[1279:1216] = temp_out[64+:64];
	assign X[1343:1280] = temp_out[1280+:64];
	assign X[1407:1344] = temp_out[960+:64];
	assign X[1471:1408] = temp_out[640+:64];
	assign X[1535:1472] = temp_out[320+:64];
	assign X[1599:1536] = temp_out[0+:64];
	assign round_done = r_temp;
	initial _sv2v_0 = 0;
endmodule
