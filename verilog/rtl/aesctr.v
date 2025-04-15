`include "/Users/azhar/test/verilog/rtl/encryptedctr.v"
module aesctr #(
    parameter   [31:0]  BASE_ADDRESS    = 32'h3000_0000,        
    parameter   [31:0]  IV_ADDR = BASE_ADDRESS,       
    parameter   [31:0]  KEY_ADDR        = BASE_ADDRESS + 16,  
    parameter   [31:0]  PLAINTEXT_ADDR         = BASE_ADDRESS + 48,  
    parameter   [31:0]  ENCRYPTEDTEXT_ADDR = BASE_ADDRESS + 176   
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

    output reg ctrenable_o,
    output reg [1023:0] plaintext_in,
    output reg [255:0]  key,
    output reg [127:0]  iv,
    input wire [1023:0] encryptedtext
);
 wire ctrenable_i;
    reg encryption_done;

    assign wbs_sta_o = 0;

    encryptedctr #(
        .PLAINTEXTIN(1024)
    ) uut (
        .plaintext_in(plaintext_in),
        .key(key),
        .iv(iv),
        .ctrenable_i(ctrenable_o),
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .encryptedtext(encryptedtext)
    );

      always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            plaintext_in <= 1024'h0;
            key <= 256'h0;
            iv  <= 128'h0;
        end else if (wbs_stb_i && wbs_cyc_i && wbs_we_i && !wbs_sta_o && !wbs_ack_o) begin
            case (wbs_adr_i)
                IV_ADDR: begin
                    iv[31:0] <= wbs_dat_i;
                end
                IV_ADDR + 4: begin
                    iv[63:32] <= wbs_dat_i;
                end
                IV_ADDR + 8: begin
                    iv[95:64] <= wbs_dat_i;
                end
                IV_ADDR + 12: begin
                    iv[127:96] <= wbs_dat_i;
                end
                KEY_ADDR: begin
                    key[31:0] <= wbs_dat_i;
                end
                KEY_ADDR + 4: begin
                    key[63:32] <= wbs_dat_i;
                end
                KEY_ADDR + 8: begin
                    key[95:64] <= wbs_dat_i;
                end
                KEY_ADDR + 12: begin
                    key[127:96] <= wbs_dat_i;
                end 
                KEY_ADDR + 16: begin
                    key[159:128] <= wbs_dat_i;
                end
                KEY_ADDR + 20: begin
                    key[191:160] <= wbs_dat_i;
                end
                KEY_ADDR + 24: begin
                    key[223:192] <= wbs_dat_i;
                end
                KEY_ADDR + 28: begin
                    key[255:224] <= wbs_dat_i;
                     ctrenable_o <= 1'b1;
                end
                PLAINTEXT_ADDR: begin
                    plaintext_in[31:0] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 4: begin
                    plaintext_in[63:32] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 8: begin
                    plaintext_in[95:64] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 12: begin
                    plaintext_in[127:96] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 16: begin
                    plaintext_in[159:128] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 20: begin
                    plaintext_in[191:160] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 24: begin
                    plaintext_in[223:192] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 28: begin
                    plaintext_in[255:224] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 32: begin
                    plaintext_in[287:256] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 36: begin
                    plaintext_in[319:288] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 40: begin
                    plaintext_in[351:320] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 44: begin
                    plaintext_in[383:352] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 48: begin
                    plaintext_in[415:384] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 52: begin
                    plaintext_in[447:416] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 56: begin
                    plaintext_in[479:448] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 60: begin
                    plaintext_in[511:480] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 64: begin
                    plaintext_in[543:512] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 68: begin
                    plaintext_in[575:544] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 72: begin
                    plaintext_in[607:576] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 76: begin
                    plaintext_in[639:608] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 80: begin
                    plaintext_in[671:640] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 84: begin
                    plaintext_in[703:672] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 88: begin
                    plaintext_in[735:704] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 92: begin
                    plaintext_in[767:736] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 96: begin
                    plaintext_in[799:768] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 100: begin
                    plaintext_in[831:800] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 104: begin
                    plaintext_in[863:832] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 108: begin
                    plaintext_in[895:864] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 112: begin
                    plaintext_in[927:896] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 116: begin
                    plaintext_in[959:928] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 120: begin
                    plaintext_in[991:960] <= wbs_dat_i;
                end
                PLAINTEXT_ADDR + 124: begin
                    plaintext_in[1023:992] <= wbs_dat_i;
               // ctrenable_o <= 1'b1;
                end
                // ENCRYPTEDTEXT_ADDR : begin
                //     wbs_dat_o <= encryptedtext[31:0];
                // end
                // ENCRYPTEDTEXT_ADDR + 4 : begin
                //     wbs_dat_o <= encryptedtext[63:32];
                // end
                 endcase
end
      end
always @(posedge wb_clk_i) begin
        if(wb_rst_i)
            wbs_ack_o <= 0;
else if (wbs_stb_i && !wbs_sta_o && (
    (wbs_adr_i >= IV_ADDR && wbs_adr_i < IV_ADDR + 16) ||         // IV (16 bytes = 4 words)
    (wbs_adr_i >= KEY_ADDR && wbs_adr_i < KEY_ADDR + 32) ||       // Key (32 bytes = 8 words)
    (wbs_adr_i >= PLAINTEXT_ADDR && wbs_adr_i < PLAINTEXT_ADDR + 128) // Plaintext (128 bytes = 32 words)
))
              wbs_ack_o <= 1;
            else
            // return ack immediately
         
                        wbs_ack_o <= 0;

    end
    endmodule