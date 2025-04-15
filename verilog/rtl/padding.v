module padding (
	en,
	check,
	datain,
	state,
	A
);
	reg _sv2v_0;
	parameter DATAIN = 64;
	parameter RATE = 1088;
	input wire en;
	input wire check;
	input wire [1087:0] datain;
	input wire [1599:0] state;
	output reg [1599:0] A;
	reg [1087:0] temp1;
	reg [1087:0] temp2;
	reg [1599:0] temp3;
	always @(*) begin
		if (_sv2v_0)
			;
		if (check == 1'b0)
			temp1 = datain;
		else if (DATAIN > RATE)
			temp1 = {1'b1, {(RATE - (DATAIN % RATE)) - 4 {1'b0}}, 3'b110, datain[(DATAIN % RATE) - 1:0]};
		else
			temp1 = {1'b1, {(RATE - DATAIN) - 4 {1'b0}}, 3'b110, datain[(DATAIN % RATE) - 1:0]};
		temp2 = temp1 ^ state[1087:0];
		temp3 = {state[1599:1088], temp2};
		A[1536+:64] <= temp3[63:0];
		A[1216+:64] <= temp3[127:64];
		A[896+:64] <= temp3[191:128];
		A[576+:64] <= temp3[255:192];
		A[256+:64] <= temp3[319:256];
		A[1472+:64] <= temp3[383:320];
		A[1152+:64] <= temp3[447:384];
		A[832+:64] <= temp3[511:448];
		A[512+:64] <= temp3[575:512];
		A[192+:64] <= temp3[639:576];
		A[1408+:64] <= temp3[703:640];
		A[1088+:64] <= temp3[767:704];
		A[768+:64] <= temp3[831:768];
		A[448+:64] <= temp3[895:832];
		A[128+:64] <= temp3[959:896];
		A[1344+:64] <= temp3[1023:960];
		A[1024+:64] <= temp3[1087:1024];
		A[704+:64] <= temp3[1151:1088];
		A[384+:64] <= temp3[1215:1152];
		A[64+:64] <= temp3[1279:1216];
		A[1280+:64] <= temp3[1343:1280];
		A[960+:64] <= temp3[1407:1344];
		A[640+:64] <= temp3[1471:1408];
		A[320+:64] <= temp3[1535:1472];
		A[0+:64] <= temp3[1599:1536];
	end
	initial _sv2v_0 = 0;
endmodule
