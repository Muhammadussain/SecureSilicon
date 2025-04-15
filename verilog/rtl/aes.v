`include "/Users/azhar/test/verilog/rtl/encryptiontop.v"

module aes #(
    parameter   [31:0]  BASE_ADDRESS    = 32'h3000_0000,        
    parameter   [31:0]  PLAINTEXT_ADDR  = BASE_ADDRESS,       
    parameter   [31:0]  KEY_ADDR        = BASE_ADDRESS + 16,  
    parameter   [31:0]  CIPHERTEXT_ADDR = BASE_ADDRESS + 48,  
    parameter   [31:0]  BUTTON_ADDR     = BASE_ADDRESS + 64   
) (
    input wire          wb_clk_i,
    input wire          wb_rst_i,

    // Wishbone signals
    input wire          wbs_cyc_i,  
    input wire          wbs_stb_i,  
    input wire          wbs_we_i,   
    input wire  [31:0]  wbs_adr_i,  
    input wire  [31:0]  wbs_dat_i,  
    output reg          wbs_ack_o,  
    output wire         wbs_sta_o,  
    output reg  [31:0]  wbs_dat_o,
   
     output reg enable_o,
    output reg [127:0]  plaintext,  
    output reg [255:0]  key_i,       
    input wire [127:0]  ciphertext   
);
    
    reg enable;
    
//yahan per wahan jo plaintext adress hai wo iv hai key same rahayga aur ciphertext ki jagah plaintexxt aaiga 
    assign wbs_sta_o = 0;

    encryptiontop uut (
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .plaintext(plaintext),
        .key_i(key_i),
        .enable(enable_o),
        .ciphertext(ciphertext)
    );

   
    always @(posedge wb_clk_i) begin
       if (wb_rst_i) begin
         plaintext <= 128'h0;
         key_i <= 256'h0;
         enable_o <= 1'b0; 
        end

     
        else if (wbs_stb_i && wbs_cyc_i && wbs_we_i && !wbs_sta_o && !wbs_ack_o) begin
    case (wbs_adr_i)
        PLAINTEXT_ADDR: begin
            plaintext[31:0] <= wbs_dat_i;
        end
        PLAINTEXT_ADDR+4: begin
            plaintext[63:32] <= wbs_dat_i;
        end
        PLAINTEXT_ADDR+8: begin
            plaintext[95:64] <= wbs_dat_i;
        end
        PLAINTEXT_ADDR+12: begin
            plaintext[127:96] <= wbs_dat_i;
        end
        KEY_ADDR: begin
            key_i[31:0] <= wbs_dat_i;
        end
        KEY_ADDR+4: begin
            key_i[63:32] <= wbs_dat_i;
        end
        KEY_ADDR+8: begin
            key_i[95:64] <= wbs_dat_i;
        end
        KEY_ADDR+12: begin
            key_i[127:96] <= wbs_dat_i;
        end
        KEY_ADDR+16: begin
            key_i[159:128] <= wbs_dat_i;
        end
        KEY_ADDR+20: begin
            key_i[191:160] <= wbs_dat_i;
        end
        KEY_ADDR+24: begin
            key_i[223:192] <= wbs_dat_i;
        end
        KEY_ADDR+28: begin
            key_i[255:224] <= wbs_dat_i;
          
        end
        BUTTON_ADDR: begin
    enable_o <= 1'b1;
end

        
    endcase
end

    end
         always @(posedge wb_clk_i) begin
        if(wb_rst_i)
            wbs_ack_o <= 0;
        else if (wbs_stb_i && !wbs_sta_o && (wbs_adr_i == PLAINTEXT_ADDR || wbs_adr_i == PLAINTEXT_ADDR+4 || wbs_adr_i == PLAINTEXT_ADDR+8 || wbs_adr_i == PLAINTEXT_ADDR+12 || wbs_adr_i == KEY_ADDR || wbs_adr_i == KEY_ADDR+4 || wbs_adr_i == KEY_ADDR+8 || wbs_adr_i == KEY_ADDR+12 || wbs_adr_i == KEY_ADDR+16 || wbs_adr_i == KEY_ADDR+20 || wbs_adr_i == KEY_ADDR+24 || wbs_adr_i == KEY_ADDR+28))
              wbs_ack_o <= 1;
            else
           
         
                        wbs_ack_o <= 0;

    end
          
   

endmodule
