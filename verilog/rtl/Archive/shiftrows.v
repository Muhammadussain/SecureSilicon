module shiftrows (
    input wire [127:0] state_in,
    output reg [127:0] state_out
);
    reg [127:0] temp;
    reg [31:0] row0,row1,row2,row3;
    reg [31:0] row1_shifted,row2_shifted,row3_shifted;
    
    always @(*)begin
       
        row0 = state_in[31:0];
        row1 = state_in[63:32];
        row2 = state_in[95:64];
        row3 = state_in[127:96];

        row1_shifted = {row1[7:0],row1[31:8]};
        row2_shifted = {row2[15:0],row2[31:16]};
        row3_shifted = {row3[23:0],row3[31:24]};

         
         temp = {row3_shifted,row2_shifted,row1_shifted,row0};
            
        state_out[31:0] ={temp[103:96],temp[71:64],temp[39:32],temp[7:0]};
        state_out[63:32]= {temp[31:24],temp[127:120],temp[95:88],temp[63:56]};
        state_out[95:64] = {temp[55:48],temp[23:16],temp[119:112],temp[87:80]};;
        state_out[127:96] = {temp[79:72],temp[47:40],temp[15:8],temp[111:104]};
    end
endmodule
