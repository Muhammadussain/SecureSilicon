`include "/Users/azhar/test/verilog/rtl/padding.v"
`include "/Users/azhar/test/verilog/rtl/fn_top.v"
module Sha3_256 (
	clk,
	rst,
	en,
	datain,
	digest
);
	reg _sv2v_0;
	parameter DATAIN = 64;
	parameter RATE = 1088;
	input wire clk;
	input wire rst;
	input wire en;
	input wire [DATAIN - 1:0] datain;
	output wire [0:255] digest;
	reg chk;
	wire [1599:0] A_temp;
	wire [1599:0] X_temp;
	reg [1599:0] state_temp;
	reg [1087:0] datain_temp;
	reg [3:0] round_count;
	reg [3:0] mul_count;
	wire r_done;
	reg r_start;
	reg [1:0] state;
	reg [1:0] next_state;
	reg [0:255] digest_reg;
	always @(posedge clk or posedge rst)
		if (!en) begin
			state <= 2'd0;
			mul_count <= 4'b0000;
			round_count <= 4'b0000;
			digest_reg <= 256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
		end
		else begin
			if (r_done == 1'b1) begin
				mul_count <= mul_count + 1;
				round_count <= round_count + 1;
			end
			if (en)
				state <= next_state;
			if ((state == 2'd2) && (r_done == 1'b1))
				digest_reg <= {X_temp[7:0], X_temp[15:8], X_temp[23:16], X_temp[31:24], X_temp[39:32], X_temp[47:40], X_temp[55:48], X_temp[63:56], X_temp[71:64], X_temp[79:72], X_temp[87:80], X_temp[95:88], X_temp[103:96], X_temp[111:104], X_temp[119:112], X_temp[127:120], X_temp[135:128], X_temp[143:136], X_temp[151:144], X_temp[159:152], X_temp[167:160], X_temp[175:168], X_temp[183:176], X_temp[191:184], X_temp[199:192], X_temp[207:200], X_temp[215:208], X_temp[223:216], X_temp[231:224], X_temp[239:232], X_temp[247:240], X_temp[255:248]};
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if (DATAIN > RATE) begin
			chk = 1'b0;
			datain_temp = datain[1087:0];
			state_temp = 1600'b0;
			r_start = 1'b0;
			case (state)
				2'd0: begin
					r_start = 1'b1;
					if (r_done == 1'b0)
						next_state = 2'd0;
					else if ((DATAIN / RATE) == 1'b1)
						next_state = 2'd2;
					else
						next_state = 2'd1;
				end
				2'd1: begin
					r_start = 1'b1;
					if (r_done == 1'b0) begin
						chk = 1'b0;
						state_temp = X_temp;
						datain_temp = datain >> (mul_count * 1088);
						next_state = 2'd1;
					end
					else if (round_count < ({DATAIN / RATE} - 1))
						next_state = 2'd1;
					else
						next_state = 2'd2;
				end
				2'd2: begin
					r_start = 1'b1;
					chk = 1'b1;
					state_temp = X_temp;
					datain_temp = datain >> (mul_count * 1088);
					if (r_done == 1'b0)
						next_state = 2'd2;
					else
						next_state = 2'd3;
				end
				2'd3: next_state = 2'd3;
			endcase
		end
		else begin
			chk = 1'b1;
			r_start = 1'b1;
			datain_temp = datain;
			state_temp = 1600'b0;
			case (state)
				2'd0: next_state = 2'd2;
				2'd2: begin
					chk = 1'b1;
					r_start = 1'b1;
					if (r_done == 1'b1)
						next_state = 2'd3;
					else
						next_state = 2'd2;
				end
				2'd3: begin
					r_start = 1'b0;
					next_state = 2'd3;
				end
			endcase
		end
	end
	padding #(
		.DATAIN(DATAIN),
		.RATE(RATE)
	) u_padding(
		.check(chk),
		.en(en),
		.datain(datain_temp),
		.state(state_temp),
		.A(A_temp)
	);
	fn_top u_fn_top(
		.clk(clk),
		.rst(rst),
		.en(en),
		.round_start(r_start),
		.A(A_temp),
		.X(X_temp),
		.round_done(r_done)
	);
	assign digest = digest_reg;
	initial _sv2v_0 = 0;
endmodule
