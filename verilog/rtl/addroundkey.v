module addroundkey(
    input wire [127:0] data,
input wire [127:0] rkey,
output reg [127:0] out
);


always @(*) begin
    
 out = rkey ^ data;
end
endmodule
