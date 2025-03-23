module keyexpansion (
    input wire [255:0] key,
    input wire clk,
    input wire rst,
    output reg [127:0] round1,round2,round3,round4,round5,round6,round7,round8,round9,round10,round11,round12,round13,round14,round15



);  reg [255:0] key_in;
    reg [127:0] expansion1,expansion2,expansion3,expansion4=128'h0;
    reg [31:0] temp,temp2,rot,round_constant=32'b0;
    reg [7:0] sub;
    reg [3:0] state,nextstate =4'b0000;
    reg [3:0] word_counter,sub_roundcounter=4'b0000;
	reg [3:0] rounds_counter=4'b0000;
	 reg [7:0] sbox_mem [0:255]; // S-Box memory
       reg [3:0] byte_counter; 

   localparam  IDLE=4'b0001 ;
   localparam  START=4'b0010 ;
   localparam  EXPANSION_1=4'b0011 ;
   localparam  EXPANSION_2=4'b0100 ;
   localparam  EXPANSION_3=4'b0101 ;
   localparam  EXPANSION_4=4'b0110 ;
   localparam  ROT_BYTE=4'b0111 ;
   localparam  SUB_BYTE=4'b1000 ;
   localparam  RC_CON=4'b1001 ;
   localparam  DONE=4'b1011 ;

always @(*) begin
        sbox_mem[8'h00] = 8'h63; sbox_mem[8'h01] = 8'h7c; sbox_mem[8'h02] = 8'h77; sbox_mem[8'h03] = 8'h7b;
        sbox_mem[8'h04] = 8'hf2; sbox_mem[8'h05] = 8'h6b; sbox_mem[8'h06] = 8'h6f; sbox_mem[8'h07] = 8'hc5;
        sbox_mem[8'h08] = 8'h30; sbox_mem[8'h09] = 8'h01; sbox_mem[8'h0a] = 8'h67; sbox_mem[8'h0b] = 8'h2b;
        sbox_mem[8'h0c] = 8'hfe; sbox_mem[8'h0d] = 8'hd7; sbox_mem[8'h0e] = 8'hab; sbox_mem[8'h0f] = 8'h76;
    
        sbox_mem[8'h10] = 8'hca; sbox_mem[8'h11] = 8'h82; sbox_mem[8'h12] = 8'hc9; sbox_mem[8'h13] = 8'h7d;
        sbox_mem[8'h14] = 8'hfa; sbox_mem[8'h15] = 8'h59; sbox_mem[8'h16] = 8'h47; sbox_mem[8'h17] = 8'hf0;
        sbox_mem[8'h18] = 8'had; sbox_mem[8'h19] = 8'hd4; sbox_mem[8'h1a] = 8'ha2; sbox_mem[8'h1b] = 8'haf;
        sbox_mem[8'h1c] = 8'h9c; sbox_mem[8'h1d] = 8'ha4; sbox_mem[8'h1e] = 8'h72; sbox_mem[8'h1f] = 8'hc0;
    
        sbox_mem[8'h20] = 8'hb7; sbox_mem[8'h21] = 8'hfd; sbox_mem[8'h22] = 8'h93; sbox_mem[8'h23] = 8'h26;
        sbox_mem[8'h24] = 8'h36; sbox_mem[8'h25] = 8'h3f; sbox_mem[8'h26] = 8'hf7; sbox_mem[8'h27] = 8'hcc;
        sbox_mem[8'h28] = 8'h34; sbox_mem[8'h29] = 8'ha5; sbox_mem[8'h2a] = 8'he5; sbox_mem[8'h2b] = 8'hf1;
        sbox_mem[8'h2c] = 8'h71; sbox_mem[8'h2d] = 8'hd8; sbox_mem[8'h2e] = 8'h31; sbox_mem[8'h2f] = 8'h15;
    
        sbox_mem[8'h30] = 8'h04; sbox_mem[8'h31] = 8'hc7; sbox_mem[8'h32] = 8'h23; sbox_mem[8'h33] = 8'hc3;
        sbox_mem[8'h34] = 8'h18; sbox_mem[8'h35] = 8'h96; sbox_mem[8'h36] = 8'h05; sbox_mem[8'h37] = 8'h9a;
        sbox_mem[8'h38] = 8'h07; sbox_mem[8'h39] = 8'h12; sbox_mem[8'h3a] = 8'h80; sbox_mem[8'h3b] = 8'he2;
        sbox_mem[8'h3c] = 8'heb; sbox_mem[8'h3d] = 8'h27; sbox_mem[8'h3e] = 8'hb2; sbox_mem[8'h3f] = 8'h75;
    
        sbox_mem[8'h40] = 8'h09; sbox_mem[8'h41] = 8'h83; sbox_mem[8'h42] = 8'h2c; sbox_mem[8'h43] = 8'h1a;
        sbox_mem[8'h44] = 8'h1b; sbox_mem[8'h45] = 8'h6e; sbox_mem[8'h46] = 8'h5a; sbox_mem[8'h47] = 8'ha0;
        sbox_mem[8'h48] = 8'h52; sbox_mem[8'h49] = 8'h3b; sbox_mem[8'h4a] = 8'hd6; sbox_mem[8'h4b] = 8'hb3;
        sbox_mem[8'h4c] = 8'h29; sbox_mem[8'h4d] = 8'he3; sbox_mem[8'h4e] = 8'h2f; sbox_mem[8'h4f] = 8'h84;
    
        sbox_mem[8'h50] = 8'h53; sbox_mem[8'h51] = 8'hd1; sbox_mem[8'h52] = 8'h00; sbox_mem[8'h53] = 8'hed;
        sbox_mem[8'h54] = 8'h20; sbox_mem[8'h55] = 8'hfc; sbox_mem[8'h56] = 8'hb1; sbox_mem[8'h57] = 8'h5b;
        sbox_mem[8'h58] = 8'h6a; sbox_mem[8'h59] = 8'hcb; sbox_mem[8'h5a] = 8'hbe; sbox_mem[8'h5b] = 8'h39;
        sbox_mem[8'h5c] = 8'h4a; sbox_mem[8'h5d] = 8'h4c; sbox_mem[8'h5e] = 8'h58; sbox_mem[8'h5f] = 8'hcf;
    
        sbox_mem[8'h60] = 8'hd0; sbox_mem[8'h61] = 8'hef; sbox_mem[8'h62] = 8'haa; sbox_mem[8'h63] = 8'hfb;
        sbox_mem[8'h64] = 8'h43; sbox_mem[8'h65] = 8'h4d; sbox_mem[8'h66] = 8'h33; sbox_mem[8'h67] = 8'h85;
        sbox_mem[8'h68] = 8'h45; sbox_mem[8'h69] = 8'hf9; sbox_mem[8'h6a] = 8'h02; sbox_mem[8'h6b] = 8'h7f;
        sbox_mem[8'h6c] = 8'h50; sbox_mem[8'h6d] = 8'h3c; sbox_mem[8'h6e] = 8'h9f; sbox_mem[8'h6f] = 8'ha8;
    
        sbox_mem[8'h70] = 8'h51; sbox_mem[8'h71] = 8'ha3; sbox_mem[8'h72] = 8'h40; sbox_mem[8'h73] = 8'h8f;
        sbox_mem[8'h74] = 8'h92; sbox_mem[8'h75] = 8'h9d; sbox_mem[8'h76] = 8'h38; sbox_mem[8'h77] = 8'hf5;
        sbox_mem[8'h78] = 8'hbc; sbox_mem[8'h79] = 8'hb6; sbox_mem[8'h7a] = 8'hda; sbox_mem[8'h7b] = 8'h21;
        sbox_mem[8'h7c] = 8'h10; sbox_mem[8'h7d] = 8'hff; sbox_mem[8'h7e] = 8'hf3; sbox_mem[8'h7f] = 8'hd2;
    
        sbox_mem[8'h80] = 8'hcd; sbox_mem[8'h81] = 8'h0c; sbox_mem[8'h82] = 8'h13; sbox_mem[8'h83] = 8'hec;
        sbox_mem[8'h84] = 8'h5f; sbox_mem[8'h85] = 8'h97; sbox_mem[8'h86] = 8'h44; sbox_mem[8'h87] = 8'h17;
        sbox_mem[8'h88] = 8'hc4; sbox_mem[8'h89] = 8'ha7; sbox_mem[8'h8a] = 8'h7e; sbox_mem[8'h8b] = 8'h3d;
        sbox_mem[8'h8c] = 8'h64; sbox_mem[8'h8d] = 8'h5d; sbox_mem[8'h8e] = 8'h19; sbox_mem[8'h8f] = 8'h73;
    
        sbox_mem[8'h90] = 8'h60; sbox_mem[8'h91] = 8'h81; sbox_mem[8'h92] = 8'h4f; sbox_mem[8'h93] = 8'hdc;
        sbox_mem[8'h94] = 8'h22; sbox_mem[8'h95] = 8'h2a; sbox_mem[8'h96] = 8'h90; sbox_mem[8'h97] = 8'h88;
        sbox_mem[8'h98] = 8'h46; sbox_mem[8'h99] = 8'hee; sbox_mem[8'h9a] = 8'hb8; sbox_mem[8'h9b] = 8'h14;
        sbox_mem[8'h9c] = 8'hde; sbox_mem[8'h9d] = 8'h5e; sbox_mem[8'h9e] = 8'h0b; sbox_mem[8'h9f] = 8'hdb;
    
        sbox_mem[8'ha0] = 8'he0; sbox_mem[8'ha1] = 8'h32; sbox_mem[8'ha2] = 8'h3a; sbox_mem[8'ha3] = 8'h0a;
        sbox_mem[8'ha4] = 8'h49; sbox_mem[8'ha5] = 8'h06; sbox_mem[8'ha6] = 8'h24; sbox_mem[8'ha7] = 8'h5c;
        sbox_mem[8'ha8] = 8'hc2; sbox_mem[8'ha9] = 8'hd3; sbox_mem[8'haa] = 8'hac; sbox_mem[8'hab] = 8'h62;
        sbox_mem[8'hac] = 8'h91; sbox_mem[8'had] = 8'h95; sbox_mem[8'hae] = 8'he4; sbox_mem[8'haf] = 8'h79;
    
        sbox_mem[8'hb0] = 8'he7; sbox_mem[8'hb1] = 8'hc8; sbox_mem[8'hb2] = 8'h37; sbox_mem[8'hb3] = 8'h6d;
        sbox_mem[8'hb4] = 8'h8d; sbox_mem[8'hb5] = 8'hd5; sbox_mem[8'hb6] = 8'h4e; sbox_mem[8'hb7] = 8'ha9;
        sbox_mem[8'hb8] = 8'h6c; sbox_mem[8'hb9] = 8'h56; sbox_mem[8'hba] = 8'hf4; sbox_mem[8'hbb] = 8'hea;
        sbox_mem[8'hbc] = 8'h65; sbox_mem[8'hbd] = 8'h7a; sbox_mem[8'hbe] = 8'hae; sbox_mem[8'hbf] = 8'h08;
    
        sbox_mem[8'hc0] = 8'hba; sbox_mem[8'hc1] = 8'h78; sbox_mem[8'hc2] = 8'h25; sbox_mem[8'hc3] = 8'h2e;
        sbox_mem[8'hc4] = 8'h1c; sbox_mem[8'hc5] = 8'ha6; sbox_mem[8'hc6] = 8'hb4; sbox_mem[8'hc7] = 8'hc6;
        sbox_mem[8'hc8] = 8'he8; sbox_mem[8'hc9] = 8'hdd; sbox_mem[8'hca] = 8'h74; sbox_mem[8'hcb] = 8'h1f;
        sbox_mem[8'hcc] = 8'h4b; sbox_mem[8'hcd] = 8'hbd; sbox_mem[8'hce] = 8'h8b; sbox_mem[8'hcf] = 8'h8a;
    
        sbox_mem[8'hd0] = 8'h70; sbox_mem[8'hd1] = 8'h3e; sbox_mem[8'hd2] = 8'hb5; sbox_mem[8'hd3] = 8'h66;
        sbox_mem[8'hd4] = 8'h48; sbox_mem[8'hd5] = 8'h03; sbox_mem[8'hd6] = 8'hf6; sbox_mem[8'hd7] = 8'h0e;
        sbox_mem[8'hd8] = 8'h61; sbox_mem[8'hd9] = 8'h35; sbox_mem[8'hda] = 8'h57; sbox_mem[8'hdb] = 8'hb9;
        sbox_mem[8'hdc] = 8'h86; sbox_mem[8'hdd] = 8'hc1; sbox_mem[8'hde] = 8'h1d; sbox_mem[8'hdf] = 8'h9e;
    
        sbox_mem[8'he0] = 8'he1; sbox_mem[8'he1] = 8'hf8; sbox_mem[8'he2] = 8'h98; sbox_mem[8'he3] = 8'h11;
        sbox_mem[8'he4] = 8'h69; sbox_mem[8'he5] = 8'hd9; sbox_mem[8'he6] = 8'h8e; sbox_mem[8'he7] = 8'h94;
        sbox_mem[8'he8] = 8'h9b; sbox_mem[8'he9] = 8'h1e; sbox_mem[8'hea] = 8'h87; sbox_mem[8'heb] = 8'he9;
        sbox_mem[8'hec] = 8'hce; sbox_mem[8'hed] = 8'h55; sbox_mem[8'hee] = 8'h28; sbox_mem[8'hef] = 8'hdf;
    
        sbox_mem[8'hf0] = 8'h8c; sbox_mem[8'hf1] = 8'ha1; sbox_mem[8'hf2] = 8'h89; sbox_mem[8'hf3] = 8'h0d;
        sbox_mem[8'hf4] = 8'hbf; sbox_mem[8'hf5] = 8'he6; sbox_mem[8'hf6] = 8'h42; sbox_mem[8'hf7] = 8'h68;
        sbox_mem[8'hf8] = 8'h41; sbox_mem[8'hf9] = 8'h99; sbox_mem[8'hfa] = 8'h2d; sbox_mem[8'hfb] = 8'h0f;
        sbox_mem[8'hfc] = 8'hb0; sbox_mem[8'hfd] = 8'h54; sbox_mem[8'hfe] = 8'hbb; sbox_mem[8'hff] = 8'h16;
    end
    always  @(posedge clk ) begin

        if (rst) begin
            state <= IDLE;
            word_counter <= 4'b0000;
             byte_counter <= 4'd0; 
          
        end 
		else begin


        
            state <= nextstate;
            byte_counter<=0;
            word_counter <= word_counter + 1;
            
           case (state)
        IDLE: begin
            
                 key_in <= key;
       
        round1 <= key[127:0];
     
        round2 <=key[255:128];
         nextstate<=START;
         
        end

        START: begin
            key_in <= key;
            if(word_counter==4'h3 && state ==4'h2) begin
                nextstate <= EXPANSION_1;
            end
            
        end

       EXPANSION_1: begin
    



    if (rounds_counter == 4'h0 ) begin
        expansion1 <= key_in[127:0];
       
        sub_roundcounter <= sub_roundcounter + 1;
        nextstate <= EXPANSION_2;
    end 
    else if(sub_roundcounter == 4'h5) begin
        expansion1[31:0]   <= expansion3[31:0] ^ round_constant;
        expansion1[63:32]  <= expansion3[63:32] ^ expansion1[31:0]       ;
        expansion1[95:64]  <= expansion3[95:64] ^ expansion1[63:32];
        expansion1[127:96] <= expansion3[127:96] ^ expansion1[95:64];
        if(word_counter==4'hc)begin
        round5 <= expansion1;

   
        end
        if(word_counter==4'hD)begin
            rot <= expansion1[127:96];
            sub_roundcounter <= sub_roundcounter + 1;
        nextstate <= SUB_BYTE;
        end
       
    end
   
    else if(sub_roundcounter == 4'h9) begin
        expansion1[31:0]   <= round7[31:0] ^ round_constant;
        expansion1[63:32]  <= round7[63:32] ^ expansion1[31:0];
        expansion1[95:64]  <= round7[95:64] ^ expansion1[63:32];
        expansion1[127:96] <= round7[127:96] ^ expansion1[95:64];
         if(word_counter==4'hf)begin
        
        round9 <= expansion1;
        end
         if(word_counter==4'h1)begin
        rot <= round9[127:96];
        sub_roundcounter <= sub_roundcounter + 1;
        nextstate <= SUB_BYTE;
        end
    end
  else if (sub_roundcounter == 4'hD) begin
    expansion1[31:0]   <= round11[31:0] ^ round_constant;
    expansion1[63:32]  <= round11[63:32] ^ expansion1[31:0];
    expansion1[95:64]  <= round11[95:64] ^ expansion1[63:32];
    expansion1[127:96] <= round11[127:96] ^ expansion1[95:64];
       if(word_counter==4'h2)begin
   
    round13 <= expansion1;
    end
        if(word_counter==4'h3)begin
    rot <= round13[127:96];
      sub_roundcounter <= sub_roundcounter + 1;
    nextstate <= SUB_BYTE;
end
end



end

        
		EXPANSION_2: begin 	
            if (sub_roundcounter == 4'h2) begin
                expansion2 <= key_in[255:128];
                temp <= expansion2[127:96];
                sub_roundcounter<=4'd2;
                nextstate <= ROT_BYTE;
          
            end
                else begin
            if(sub_roundcounter==4'h6)begin

                 expansion2[31:0]   <= round4[31:0] ^ temp2;
                expansion2[63:32]  <= round4[63:32] ^ expansion2[31:0];
                expansion2[95:64]  <= round4[95:64] ^ expansion2[63:32];
                expansion2[127:96] <= round4[127:96] ^ expansion2[95:64];
				
                if(word_counter==4'h7)begin
               
                round6 <=expansion2;
                end
                if(word_counter==4'h8)begin
                nextstate <= ROT_BYTE;
                temp<=round6[127:96];
                sub_roundcounter<=sub_roundcounter+1;
                end
            end
            else if(sub_roundcounter==4'hA)begin

                 expansion2[31:0]   <= round8[31:0] ^ temp2;
                expansion2[63:32]  <= round8[63:32] ^ expansion2[31:0];
                expansion2[95:64]  <= round8[95:64] ^ expansion2[63:32];
                expansion2[127:96] <= round8[127:96] ^ expansion2[95:64];
				if(word_counter==4'hb)begin
               
                round10 <=expansion2;
                end
                if(word_counter==4'hc)begin
               nextstate <= ROT_BYTE;
               sub_roundcounter<=sub_roundcounter+1;
                temp<=round10[127:96];
            end
            end
            else begin
              if(sub_roundcounter==4'hE)begin

                 expansion2[31:0]   <= round12[31:0] ^ temp2;
                expansion2[63:32]  <= round12[63:32] ^ expansion2[31:0];
                expansion2[95:64]  <= round12[95:64] ^ expansion2[63:32];
                expansion2[127:96] <= round12[127:96] ^ expansion2[95:64];
				if(word_counter==4'hd)begin
               
                round14 <=expansion2;
                end 
                if(word_counter==4'he)begin
                  nextstate <= ROT_BYTE;
                   sub_roundcounter<=sub_roundcounter+1;
                temp<=round14[127:96];
                end
            end
                end
                end

        end

        ROT_BYTE: begin
            
            rot <= {temp[7:0], temp[31:8]};
            nextstate <= SUB_BYTE;
        end
       SUB_BYTE: begin
       
           temp2[byte_counter * 8 +: 8] <= sbox_mem[rot[byte_counter * 8 +: 8]];
      
                  // Increment counter, wrapping around after 16 bytes
                  if (byte_counter == 4'd5) 
                      byte_counter <= 4'd0;
                  else 
                      byte_counter <= byte_counter + 1;
//        rot <= rot >> 8;
//        temp2 <= {sub[7:0], temp2[31:8]};
//        temp <= temp << 8;
    

    if (word_counter == 4'hD && sub_roundcounter ==4'h2 && rounds_counter==4'h0) begin
        nextstate <= RC_CON;
    end
    else if (word_counter == 4'h9 && rounds_counter ==4'h0 && sub_roundcounter==4'h4) begin
        nextstate <= EXPANSION_4;
    end 
    else if (word_counter == 4'h4 && rounds_counter == 4'h1 &&sub_roundcounter==4'h5) begin
			  nextstate<=RC_CON;
			
		end
     else if (word_counter == 4'h1 && rounds_counter == 4'h1 && sub_roundcounter==4'h6) begin
			
			  nextstate<=EXPANSION_2;
		end
		
	 else if (word_counter == 4'he && rounds_counter == 4'h1 && sub_roundcounter==4'h7) begin
			 nextstate<=RC_CON;
		end
       
    else if(word_counter ==4'ha && rounds_counter ==4'h1 && sub_roundcounter==4'h8)begin
            nextstate<=EXPANSION_4;
 end

    else if(word_counter ==4'h7 && rounds_counter ==4'h2 && sub_roundcounter==4'h9)begin
            nextstate<=RC_CON;
 end

    else if(word_counter ==4'h5 && rounds_counter ==4'h2 && sub_roundcounter==4'hA)begin
            nextstate<=EXPANSION_2;
 end

 
    else if(word_counter ==4'h2 && rounds_counter ==4'h2 && sub_roundcounter==4'hB)begin
            nextstate<=RC_CON;
 end

    else if(word_counter ==4'hE && rounds_counter ==4'h2 && sub_roundcounter==4'hC)begin
            nextstate<=EXPANSION_4;

  end
 else if(word_counter ==4'ha && rounds_counter ==4'h3 && sub_roundcounter==4'hD)begin
            nextstate<=RC_CON;
 end
 else if(word_counter ==4'h7 && rounds_counter ==4'h3 && sub_roundcounter==4'he)begin
            nextstate<=EXPANSION_2;
 end
 else if(word_counter ==4'h4 && rounds_counter ==4'h3 && sub_roundcounter==4'hF)begin
            nextstate<=RC_CON;
 end

 
       end  
		RC_CON: begin
   		 case (sub_roundcounter)
        4'h2: round_constant <= {temp2[31:8],temp2[7:0] ^ 8'h01};
        4'h5: round_constant <= {temp2[31:8],temp2[7:0] ^ 8'h02};
        4'h7: round_constant <= {temp2[31:8],temp2[7:0] ^ 8'h04};
        4'h9: round_constant <= {temp2[31:8],temp2[7:0] ^ 8'h08};
        4'hB: round_constant <= {temp2[31:8],temp2[7:0] ^ 8'h10};
        4'hd: round_constant <= {temp2[31:8],temp2[7:0] ^ 8'h20};
        4'hF: round_constant <= {temp2[31:8],temp2[7:0] ^ 8'h40};
    endcase

    if (sub_roundcounter == 4'h5 ||sub_roundcounter==4'h9||sub_roundcounter==4'hd) begin
        nextstate <= EXPANSION_1;
    end else begin
        nextstate <= EXPANSION_3;
        if(sub_roundcounter==4'h8 ||sub_roundcounter==4'HB ||sub_roundcounter==4'hf) begin
            sub_roundcounter<=sub_roundcounter;
        end
        else
        sub_roundcounter <=sub_roundcounter+1;
    end
end

	EXPANSION_3: begin
    expansion3[31:0]  <= expansion1[31:0] ^ round_constant;
    expansion3[63:32] <= expansion1[63:32] ^ expansion3[31:0];
    expansion3[95:64] <= expansion1[95:64] ^ expansion3[63:32];
    expansion3[127:96] <= expansion1[127:96] ^ expansion3[95:64];
    
 
    rot <= expansion3[127:96];
   
 
    
	if (sub_roundcounter ==4'h4 &&word_counter ==4'h5) begin
    
   
        round3 <=expansion3;
        nextstate <= SUB_BYTE;
     
        
    end
   
    if (sub_roundcounter==4'h8 && word_counter==4'h6 ) begin
       
         

        round7 <=expansion3;
        nextstate <= SUB_BYTE;
end
     if (sub_roundcounter==4'hB &&word_counter ==4'HA) begin
       
        round11 <=expansion3;
        nextstate <= SUB_BYTE;
         sub_roundcounter <=sub_roundcounter+1;
    end
    if (sub_roundcounter==4'hF && word_counter==4'hc) begin
       
        round15 <=expansion3;
        
        nextstate<=DONE;
    end

    
    end
    
 


	EXPANSION_4: begin
		    

    if (rounds_counter == 4'h0 ) begin
    expansion4[31:0]  <= round2[31:0] ^ temp2;
    expansion4[63:32] <= round2[63:32] ^ expansion4[31:0];
    expansion4[95:64] <= round2[95:64] ^ expansion4[63:32];
    expansion4[127:96] <= round2[127:96] ^ expansion4[95:64];
    round4 <=expansion4;
    if(word_counter==4'he)begin
        
       
        sub_roundcounter <= sub_roundcounter + 1;

         nextstate <= ROT_BYTE;
     
    end
    end
    else if (rounds_counter==4'h1 ) begin
        expansion4[31:0]  <= round6[31:0] ^ temp2;
    expansion4[63:32] <= round6[63:32] ^ expansion4[31:0];
    expansion4[95:64] <= round6[95:64] ^ expansion4[63:32];
    expansion4[127:96] <= round6[127:96] ^ expansion4[95:64];
    round8 <=expansion4;

           if(word_counter==4'h1)begin
       
        round8 <=expansion4;
         sub_roundcounter <= sub_roundcounter + 1;
         nextstate <= ROT_BYTE;
          end
    end
    else begin
    if (rounds_counter==4'h2) begin
              expansion4[31:0]  <= round10[31:0] ^ temp2;
    expansion4[63:32] <= round10[63:32] ^ expansion4[31:0];
    expansion4[95:64] <= round10[95:64] ^ expansion4[63:32];
    expansion4[127:96] <= round10[127:96] ^ expansion4[95:64];
    round12 <=expansion4;
     if(word_counter==4'h4)begin
       
        round12 <=expansion4;
          sub_roundcounter <= sub_roundcounter + 1;
         nextstate <= ROT_BYTE;
         end
     
    end
    end


    if (sub_roundcounter == 4'h5 ||sub_roundcounter ==4'h9||sub_roundcounter==4'hd) begin
        rounds_counter <= rounds_counter + 1;
    end

     temp <= expansion4[127:96];
   
end


	
	
	
        endcase
        end
    end


endmodule
