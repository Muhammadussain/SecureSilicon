`include "/Users/azhar/test/verilog/rtl/sbox.v"
`include "/Users/azhar/test/verilog/rtl/key_expansion.v"
`include "/Users/azhar/test/verilog/rtl/mixcolumn.v"
`include "/Users/azhar/test/verilog/rtl/shiftrows.v"
`include "/Users/azhar/test/verilog/rtl/addroundkey.v"

module encryptiontop (
    input wire clk,
    input wire rst,
    input wire [127:0] plaintext,
    input wire enable,
    input wire [255:0] key_i,
   output reg cipher_counter_o,
    output reg [127:0] ciphertext
   
);

   
    reg [127:0] rk,rk_temp,rk_temp2,rk_temp3,rk_temp4,rk_temp5,rk_temp6,rk_temp7,rk_temp8,rk_temp9,rk_temp10,rk_temp11,rk_temp12,rk_temp13;
    reg [127:0] temp, temp2;
   reg en;
    wire [127:0] sub_bytes_temp_out, shift_rows_out, mix_columns_out, out, round1,round2,round3,round4,round5,round6,round7,round8,round9,round10,round11,round12,round13,round14,round15;

    reg [4:0] state, next_state; 
    reg [4:0] new_counter; 
    reg [3:0] rounds_counter ;
    localparam IDLE = 5'b00000;
    localparam INITIAL_ADD_ROUND_KEY = 5'b00001;
    localparam ROUND1 = 5'b00010;
    localparam ROUND2 = 5'b00011;
    localparam ROUND3 = 5'b00100;
    localparam ROUND4 = 5'b00101;
    localparam ROUND5 = 5'b00110;
    localparam ROUND6 = 5'b00111;
    localparam ROUND7 = 5'b01000;
    localparam ROUND8 = 5'b01001;
    localparam ROUND9 = 5'b01010;
    localparam ROUND10 = 5'b01011;
    localparam ROUND11 = 5'b01100;
    localparam ROUND12 = 5'b01101;
    localparam ROUND13 = 5'b01110;
    localparam FINAL_ROUND = 5'b01111;
    localparam DONE = 5'b10000;

    
    keyexpansion key_expansion (
        .key(key_i),
        .clk(clk),
        .rst(rst),
        .key_enable(enable),
        .round1(round1),
        .round2(round2),
        .round3(round3),
        .round4(round4),
        .round5(round5),
        .round6(round6),
        .round7(round7),
        .round8(round8),
        .round9(round9),
        .round10(round10),
        .round11(round11),
        .round12(round12),
        .round13(round13),
        .round14(round14),
        .round15(round15)
       
    );

  sbox uut (
        .s_in(rk),
        .clk(clk),
        .en(en),
     
         .rst(rst),
        .s_o(sub_bytes_temp_out) 
    );

  
 
    shiftrows shift_rows (
        .state_in(sub_bytes_temp_out),
        .state_out(shift_rows_out)
    );

    
    mixcolumn mix_columns (
        .mixcolumn_i(shift_rows_out),
        .mixcolumn_o(mix_columns_out)
    ); 

    
    addroundkey addroundKey (
        .data(temp),
        .rkey(temp2),
        .out(out)
    );

   
      always @(posedge clk ) begin
    
                if (rst) begin

            state <= IDLE;
            new_counter <= 5'h0;
               rk<=128'h0;  
               temp<=128'h0;
          
        end else begin
            if (enable) begin
                 state <= next_state;
            
            new_counter <= new_counter + 1;
            end else begin
                state <= IDLE;
                new_counter <= 5'h0;
            end
           




                case (state)
            IDLE: begin
               
                   cipher_counter_o<=1'h0;
                next_state <= INITIAL_ADD_ROUND_KEY;
                rounds_counter <= 4'h0;
    
            end
            INITIAL_ADD_ROUND_KEY: begin
                 rounds_counter <= 4'h1;
                
               
             
                   temp <= plaintext;
                   temp2 <= round1;
                   rk <= out;
                 
                  if (rounds_counter==4'h1 && new_counter == 5'h6 ) begin
                  en<=1'b1;
                   rk <= out;
                   en<=1'b1;
                    next_state <= ROUND1;
                      
                end
               
            end
            ROUND1: begin
           
              rounds_counter <= 4'h2;

                if (sub_bytes_temp_out && new_counter==5'd28 &&rounds_counter==4'h2) begin
                    temp <= mix_columns_out;
                    temp2 <= round2;
              

                end
                 if (sub_bytes_temp_out && new_counter==5'd29 &&rounds_counter==4'h2) begin
                    en<=1'b1;
                    rk_temp<=out;
                    next_state <=ROUND2;
                    new_counter<=5'h0;
                    
                end
                 
          
            end
            ROUND2: begin
                   
             
                rounds_counter <= 4'h3;
                 rk <= rk_temp;

                if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'h3) begin
                    temp <= mix_columns_out;
                    temp2 <= round3;
                   
                end
                        if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'h3) begin
                       en<=1'b1;
                      rk_temp2<=out;
                      new_counter<=5'h0;
                      next_state <=ROUND3;
                   
                    
                end
                

            end
            ROUND3: begin
                rounds_counter <= 4'h4;
                rk <=rk_temp2;

                 if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'h4) begin
                    temp <= mix_columns_out;
                    temp2 <= round4;
                   
                end
               if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'h4) begin
                    en<=1'b1;
                    rk_temp3<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND4;
                    
                    
                end
                
            end
            ROUND4: begin
                rounds_counter <= 4'h5;
                rk <=rk_temp3;

                  if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'h5) begin
                    temp <= mix_columns_out;
                    temp2 <= round5;
                   
                end
                   if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'h5) begin
                   
                    rk_temp4<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND5;
                    
                    
                end
         
            end
             
              ROUND5: begin
                rounds_counter <= 4'h6;
                rk <=rk_temp4;

                 if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'h6) begin
                    temp <= mix_columns_out;
                    temp2 <= round6;
                   
                end
                   if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'h6) begin
                   
                    rk_temp5<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND6;
                    
                    
                end
    
             end
              ROUND6: begin
                rounds_counter <= 4'h7;
                rk <=rk_temp5;
                

                 if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'h7) begin
                    temp <= mix_columns_out;
                    temp2 <= round7;
                   
                end
                   if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'h7) begin
                   
                    rk_temp6<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND7;
                    
                    
                end
   
             end
              ROUND7: begin
                rounds_counter <= 4'h8;
                rk <=rk_temp6;


                if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'h8) begin
                    temp <= mix_columns_out;
                    temp2 <= round8;
                   
                end
                   if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'h8) begin
                   
                    rk_temp7<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND8;
                    
                    
                end
   

              end
              ROUND8: begin
                rounds_counter <= 4'h9;
                rk <=rk_temp7;
 
                if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'h9) begin
                    temp <= mix_columns_out;
                    temp2 <= round9;
                   
                end
                 if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'h9) begin
                   
                    rk_temp8<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND9;
                    
                    
                end
             
            end
              ROUND9: begin
                rounds_counter <= 4'hA;
                rk <=rk_temp8;
            

                 if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'hA) begin
                    temp <= mix_columns_out;
                    temp2 <= round10;
                   
                end
                 if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'hA) begin
                   
                    rk_temp9<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND10;
                    
                    
                end
               
            end
              ROUND10: begin
                rounds_counter <= 4'hB;
                rk <=rk_temp9;
            

                   
                 if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'hB) begin
                    temp <= mix_columns_out;
                    temp2 <= round11;
                   
                end
                 if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'hB) begin
                   
                    rk_temp10<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND11;
                    
                    
                end
       
            end
              ROUND11: begin
                rounds_counter <= 4'hC;
                rk <=rk_temp10;
               

                if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'hC) begin
                    temp <= mix_columns_out;
                    temp2 <= round12;
                   
                end
                 if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'hC) begin
                   
                    rk_temp11<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND12;
                    
                    
                end
           
             end
              ROUND12: begin
                rounds_counter <= 4'hD;
                rk <=rk_temp11;
              


                  if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'hD) begin
                    temp <= mix_columns_out;
                    temp2 <= round13;
                   
                end
                 if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'hD) begin
                   
                    rk_temp12<=out;
                    new_counter<=5'h0;
                    next_state <=ROUND13;
                    
                    
                end
           
            end
              ROUND13: begin
                rounds_counter <= 4'hE;
                rk <=rk_temp12;
             


                  if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'hE) begin
                    temp <= mix_columns_out;
                    temp2 <= round14;
                   
                end
                 if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'hE) begin
                   
                    rk_temp13<=out;
                    new_counter<=5'h0;
                    next_state <=FINAL_ROUND;
                    
                    
                end
      
            end
              FINAL_ROUND: begin
                rounds_counter <= 4'hF;
                rk <=rk_temp13;
                cipher_counter_o<=1'h0;

               
                if (sub_bytes_temp_out && new_counter==5'h16 &&rounds_counter==4'hF) begin
          
                   temp <= shift_rows_out;
                    temp2 <= round15;
                   
                end
                 if (sub_bytes_temp_out && new_counter==5'h17 &&rounds_counter==4'hF) begin
                   
                   
                   cipher_counter_o<=1'h1;
                    ciphertext<=out;
                    new_counter<=5'h0;
                     next_state<= DONE;
                
               end
         end
            DONE: begin
            cipher_counter_o<=1'h0;
              
                next_state<=IDLE;
            end
        default: begin
          
            next_state<=IDLE;
        end
        endcase
            
        end
    end


endmodule