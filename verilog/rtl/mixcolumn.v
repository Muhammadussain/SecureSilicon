module mixcolumn (
    input wire [127:0] mixcolumn_i,
    output reg [127:0] mixcolumn_o
);
   reg [31:0] col0,col1,col2,col3;
   reg [31:0] col0_out,col1_out,col2_out,col3_out;
   reg [7:0] s0,s1,s2,s3;
   reg [7:0] s0_out,s1_out,s2_out,s3_out;
   reg [7:0] x_s0,x_s1,x_s2,x_s3;

   always @(*) begin


     col0 = mixcolumn_i [31:0];
     col1 = mixcolumn_i [63:32];
     col2 = mixcolumn_i [95:64];
     col3 = mixcolumn_i [127:96];



     s0 = col0[7:0]; s1 = col0[15:8]; s2 = col0[23:16]; s3 = col0[31:24];

     x_s0 = {s0[6:0],1'b0} ^ (8'h1b & {8{s0[7]}});
     x_s1 = {s1[6:0],1'b0} ^ (8'h1b & {8{s1[7]}});
     x_s2 = {s2[6:0],1'b0} ^ (8'h1b & {8{s2[7]}}); 
     x_s3 = {s3[6:0],1'b0} ^ (8'h1b & {8{s3[7]}});

     s0_out = x_s0 ^ (x_s1 ^ s1) ^ s2 ^ s3; 
     s1_out = s0 ^ x_s1 ^ (x_s2 ^ s2) ^ s3;
     s2_out = s0 ^ s1 ^ x_s2 ^ (x_s3 ^ s3);  
     s3_out = (x_s0 ^ s0) ^ s1 ^ s2 ^ x_s3; 

     col0_out = {s3_out,s2_out,s1_out,s0_out};

   
     s0 = col1[7:0]; s1 = col1[15:8]; s2 = col1[23:16]; s3 = col1[31:24];

     x_s0 = {s0[6:0],1'b0} ^ (8'h1b & {8{s0[7]}});
     x_s1 = {s1[6:0],1'b0} ^ (8'h1b & {8{s1[7]}});
     x_s2 = {s2[6:0],1'b0} ^ (8'h1b & {8{s2[7]}}); 
     x_s3 = {s3[6:0],1'b0} ^ (8'h1b & {8{s3[7]}});

     s0_out = x_s0 ^ (x_s1 ^ s1) ^ s2 ^ s3; 
     s1_out = s0 ^ x_s1 ^ (x_s2 ^ s2) ^ s3; 
     s2_out = s0 ^ s1 ^ x_s2 ^ (x_s3 ^ s3); 
     s3_out = (x_s0 ^ s0) ^ s1 ^ s2 ^ x_s3; 

     col1_out = {s3_out,s2_out,s1_out,s0_out};

    
     s0 = col2[7:0]; s1 = col2[15:8]; s2 = col2[23:16]; s3 = col2[31:24];

     x_s0 = {s0[6:0],1'b0} ^ (8'h1b & {8{s0[7]}});
     x_s1 = {s1[6:0],1'b0} ^ (8'h1b & {8{s1[7]}});
     x_s2 = {s2[6:0],1'b0} ^ (8'h1b & {8{s2[7]}}); 
     x_s3 = {s3[6:0],1'b0} ^ (8'h1b & {8{s3[7]}});

     s0_out = x_s0 ^ (x_s1 ^ s1) ^ s2 ^ s3; 
     s1_out = s0 ^ x_s1 ^ (x_s2 ^ s2) ^ s3; 
     s2_out = s0 ^ s1 ^ x_s2 ^ (x_s3 ^ s3);  
     s3_out = (x_s0 ^ s0) ^ s1 ^ s2 ^ x_s3;

     col2_out = {s3_out,s2_out,s1_out,s0_out};


     s0 = col3[7:0]; s1 = col3[15:8]; s2 = col3[23:16]; s3 = col3[31:24];

     x_s0 = {s0[6:0],1'b0} ^ (8'h1b & {8{s0[7]}});
     x_s1 = {s1[6:0],1'b0} ^ (8'h1b & {8{s1[7]}});
     x_s2 = {s2[6:0],1'b0} ^ (8'h1b & {8{s2[7]}}); 
     x_s3 = {s3[6:0],1'b0} ^ (8'h1b & {8{s3[7]}});

     s0_out = x_s0 ^ (x_s1 ^ s1) ^ s2 ^ s3;
     s1_out = s0 ^ x_s1 ^ (x_s2 ^ s2) ^ s3;
     s2_out = s0 ^ s1 ^ x_s2 ^ (x_s3 ^ s3);  
     s3_out = (x_s0 ^ s0) ^ s1 ^ s2 ^ x_s3; 

     col3_out = {s3_out,s2_out,s1_out,s0_out};

     mixcolumn_o = {col3_out, col2_out, col1_out, col0_out};


    
   end
    
endmodule
