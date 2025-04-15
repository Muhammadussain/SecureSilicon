module Rho (
	theta_in,
	rho
);
	reg _sv2v_0;
	input wire [1599:0] theta_in;
	output reg [1599:0] rho;
	always @(*) begin
		if (_sv2v_0)
			;
		rho[1536+:64] = theta_in[1536+:64];
		rho[1472+:64] = {theta_in[1499-:28], theta_in[1535-:36]};
		rho[1408+:64] = {theta_in[1468-:61], theta_in[1471-:3]};
		rho[1344+:64] = {theta_in[1366-:23], theta_in[1407-:41]};
		rho[1280+:64] = {theta_in[1325-:46], theta_in[1343-:18]};
		rho[1216+:64] = {theta_in[1278-:63], theta_in[1279]};
		rho[1152+:64] = {theta_in[1171-:20], theta_in[1215-:44]};
		rho[1088+:64] = {theta_in[1141-:54], theta_in[1151-:10]};
		rho[1024+:64] = {theta_in[1042-:19], theta_in[1087-:45]};
		rho[960+:64] = {theta_in[1021-:62], theta_in[1023-:2]};
		rho[896+:64] = {theta_in[897-:2], theta_in[959-:62]};
		rho[832+:64] = {theta_in[889-:58], theta_in[895-:6]};
		rho[768+:64] = {theta_in[788-:21], theta_in[831-:43]};
		rho[704+:64] = {theta_in[752-:49], theta_in[767-:15]};
		rho[640+:64] = {theta_in[642-:3], theta_in[703-:61]};
		rho[576+:64] = {theta_in[611-:36], theta_in[639-:28]};
		rho[512+:64] = {theta_in[520-:9], theta_in[575-:55]};
		rho[448+:64] = {theta_in[486-:39], theta_in[511-:25]};
		rho[384+:64] = {theta_in[426-:43], theta_in[447-:21]};
		rho[320+:64] = {theta_in[327-:8], theta_in[383-:56]};
		rho[256+:64] = {theta_in[292-:37], theta_in[319-:27]};
		rho[192+:64] = {theta_in[235-:44], theta_in[255-:20]};
		rho[128+:64] = {theta_in[152-:25], theta_in[191-:39]};
		rho[64+:64] = {theta_in[119-:56], theta_in[127-:8]};
		rho[0+:64] = {theta_in[49-:50], theta_in[63-:14]};
	end
	initial _sv2v_0 = 0;
endmodule
