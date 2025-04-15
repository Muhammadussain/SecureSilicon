`include "/Users/azhar/test/verilog/rtl/SHA3_256.v"
// `include "/Users/azhar/test/verilog/rtl/encryptiontop.v"
`include "/Users/azhar/test/verilog/rtl/encryptedctr.v"
// `include "/Users/azhar/test/verilog/rtl/decryptedctr.v"

module cryptotop #(
    parameter [31:0] BASE_ADDRESS        = 32'h3000_0000,        
    parameter [31:0] IV_ADDR             = BASE_ADDRESS,                 // 0x3000_0000 (16 bytes)
    parameter [31:0] KEY_ADDR            = BASE_ADDRESS + 16,           // 0x3000_0010 (32 bytes)
    parameter [31:0] PLAINTEXT_ADDR      = BASE_ADDRESS + 48,           // 0x3000_0030 (128 bytes)
    parameter [31:0] CIPHERTEXT_ADDR     = BASE_ADDRESS + 176,          // 0x3000_00B0 (128 bytes)
    parameter [31:0] AES_BUTTON_ADDR     = BASE_ADDRESS + 304,          // 0x3000_0130 (4 bytes)
    parameter [31:0] SHA_BUTTON_ADDR     = BASE_ADDRESS + 308,          // 0x3000_0134 (4 bytes)
    parameter [31:0] DIGEST_ADDR         = BASE_ADDRESS + 312,          // 0x3000_0138 (32 bytes)
    parameter [31:0] DATA_ADDR           = BASE_ADDRESS + 344,          // 0x3000_0158 (64 bytes)
    parameter integer DATAIN             = 64
) (
    input wire          wb_clk_i,
    input wire          wb_rst_i,

    input wire          wbs_cyc_i,
    input wire          wbs_stb_i,
    input wire          wbs_we_i,
    input wire  [31:0]  wbs_adr_i,
    input wire  [31:0]  wbs_dat_i,
    output reg          wbs_ack_o,
    output wire         wbs_sta_o,
    output reg  [31:0]  wbs_dat_o,

    output reg enable_o,
    output reg [1023:0] plaintext_in,
    output reg [1023:0] ciphertext,
    output reg [255:0]  key,
    output reg [127:0]  iv,
    input wire [1023:0] encryptedtext,
    input wire [1023:0] decryptedtext,

    output reg sha_enable_o,
    output reg [DATAIN - 1 :0] datain,
    input wire [255:0] digest
);

assign wbs_sta_o = 0;

 encryptedctr #(
        .PLAINTEXTIN(1024)
    ) uut (
        .plaintext_in(plaintext_in),
        .key(key),
        .iv(iv),
        .ctrenable_i(enable_o),
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .encryptedtext(encryptedtext)
    );
//  decryptedctr #(
//         .CIPHERTEXTIN(1024)
//     ) uutdecryption (
//         .ciphertext_in(ciphertext),
//         .key(key),
//         .iv(iv),
//         .ctrenable_i(enable_o),
//         .clk(wb_clk_i),
//         .rst(wb_rst_i),
//         .decryptedtext(decryptedtext)
//     );

    Sha3_256 sha3_uut (
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .en(sha_enable_o),
        .datain(datain),
        .digest(digest)
    );

   always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
        iv <= 0;
        key <= 0;
        plaintext_in <= 0;
        ciphertext <= 0;
        enable_o <= 0;
        sha_enable_o <= 0;
        datain <= 0;
        wbs_dat_o <= 0;
        // end else if (wbs_stb_i && wbs_cyc_i && wbs_we_i && !wbs_sta_o && !wbs_ack_o) begin
    end else if (wbs_stb_i && wbs_cyc_i && !wbs_ack_o) begin
         if (wbs_we_i) begin
            case (wbs_adr_i)
            AES_BUTTON_ADDR:       enable_o <= wbs_dat_i[0];
                SHA_BUTTON_ADDR:       sha_enable_o <= wbs_dat_i[0];
                DATA_ADDR:             datain[31:0] <= wbs_dat_i;
                DATA_ADDR + 4:         datain[63:32] <= wbs_dat_i;
                DATA_ADDR + 8:         datain[95:64] <= wbs_dat_i;
                DATA_ADDR + 12:        datain[127:96] <= wbs_dat_i;
                DATA_ADDR + 16:        datain[159:128] <= wbs_dat_i;
                DATA_ADDR + 20:        datain[191:160] <= wbs_dat_i;
                DATA_ADDR + 24:        datain[223:192] <= wbs_dat_i;
                DATA_ADDR + 28:        datain[255:224] <= wbs_dat_i;
                DATA_ADDR + 32:        datain[287:256] <= wbs_dat_i;
                DATA_ADDR + 36:        datain[319:288] <= wbs_dat_i;
                DATA_ADDR + 40:        datain[351:320] <= wbs_dat_i;
                DATA_ADDR + 44:        datain[383:352] <= wbs_dat_i;
                DATA_ADDR + 48:        datain[415:384] <= wbs_dat_i;
                DATA_ADDR + 52:        datain[447:416] <= wbs_dat_i;
                DATA_ADDR + 56:        datain[479:448] <= wbs_dat_i;
                DATA_ADDR + 60:        datain[511:480] <= wbs_dat_i;
                DATA_ADDR + 64:        datain[543:512] <= wbs_dat_i;
                DATA_ADDR + 68:        datain[575:544] <= wbs_dat_i;
                DATA_ADDR + 72:        datain[607:576] <= wbs_dat_i;
                DATA_ADDR + 76:        datain[639:608] <= wbs_dat_i;
                DATA_ADDR + 80:        datain[671:640] <= wbs_dat_i;
                DATA_ADDR + 84:        datain[703:672] <= wbs_dat_i;
                DATA_ADDR + 88:        datain[735:704] <= wbs_dat_i;
                DATA_ADDR + 92:        datain[767:736] <= wbs_dat_i;
                DATA_ADDR + 96:        datain[799:768] <= wbs_dat_i;
                DATA_ADDR + 100:       datain[831:800] <= wbs_dat_i;
                DATA_ADDR + 104:       datain[863:832] <= wbs_dat_i;
                DATA_ADDR + 108:       datain[895:864] <= wbs_dat_i;
                DATA_ADDR + 112:       datain[927:896] <= wbs_dat_i;
                DATA_ADDR + 116:       datain[959:928] <= wbs_dat_i;
                DATA_ADDR + 120:       datain[991:960] <= wbs_dat_i;
                DATA_ADDR + 124:       datain[1023:992] <= wbs_dat_i;
                DATA_ADDR + 128:       datain[1055:1024] <= wbs_dat_i;
                DATA_ADDR + 132:       datain[1087:1056] <= wbs_dat_i;
                DATA_ADDR + 136:       datain[1119:1088] <= wbs_dat_i;
                DATA_ADDR + 140:       datain[1151:1120] <= wbs_dat_i;
                DATA_ADDR + 144:       datain[1183:1152] <= wbs_dat_i;
                DATA_ADDR + 148:       datain[1215:1184] <= wbs_dat_i;
                DATA_ADDR + 152:       datain[1247:1216] <= wbs_dat_i;
                DATA_ADDR + 156:       datain[1279:1248] <= wbs_dat_i;
                DATA_ADDR + 160:       datain[1311:1280] <= wbs_dat_i;
                DATA_ADDR + 164:       datain[1343:1312] <= wbs_dat_i;
                DATA_ADDR + 168:       datain[1375:1344] <= wbs_dat_i;
                DATA_ADDR + 172:       datain[1407:1376] <= wbs_dat_i;
                DATA_ADDR + 176:       datain[1439:1408] <= wbs_dat_i;
                DATA_ADDR + 180:       datain[1471:1440] <= wbs_dat_i;
                DATA_ADDR + 184:       datain[1503:1472] <= wbs_dat_i;
                DATA_ADDR + 188:       datain[1535:1504] <= wbs_dat_i;
                DATA_ADDR + 192:       datain[1567:1536] <= wbs_dat_i;
                DATA_ADDR + 196:       datain[1599:1568] <= wbs_dat_i;
                DATA_ADDR + 200:       datain[1631:1600] <= wbs_dat_i;
                DATA_ADDR + 204:       datain[1663:1632] <= wbs_dat_i;
                DATA_ADDR + 208:       datain[1695:1664] <= wbs_dat_i;
                DATA_ADDR + 212:       datain[1727:1696] <= wbs_dat_i;
                DATA_ADDR + 216:       datain[1759:1728] <= wbs_dat_i;
                DATA_ADDR + 220:       datain[1791:1760] <= wbs_dat_i;
                DATA_ADDR + 224:       datain[1823:1792] <= wbs_dat_i;
                DATA_ADDR + 228:       datain[1855:1824] <= wbs_dat_i;
                DATA_ADDR + 232:       datain[1887:1856] <= wbs_dat_i;
                DATA_ADDR + 236:       datain[1919:1888] <= wbs_dat_i;
                DATA_ADDR + 240:       datain[1951:1920] <= wbs_dat_i;
                DATA_ADDR + 244:       datain[1983:1952] <= wbs_dat_i;
                DATA_ADDR + 248:       datain[2015:1984] <= wbs_dat_i;
                DATA_ADDR + 252:       datain[2047:2016] <= wbs_dat_i;
                PLAINTEXT_ADDR + 0:    plaintext_in[31:0] <= wbs_dat_i;
                PLAINTEXT_ADDR + 4:    plaintext_in[63:32] <= wbs_dat_i;
                PLAINTEXT_ADDR + 8:    plaintext_in[95:64] <= wbs_dat_i;
                PLAINTEXT_ADDR + 12:   plaintext_in[127:96] <= wbs_dat_i;
                PLAINTEXT_ADDR + 16:   plaintext_in[159:128] <= wbs_dat_i;
                PLAINTEXT_ADDR + 20:   plaintext_in[191:160] <= wbs_dat_i;
                PLAINTEXT_ADDR + 24:   plaintext_in[223:192] <= wbs_dat_i;
                PLAINTEXT_ADDR + 28:   plaintext_in[255:224] <= wbs_dat_i;
                PLAINTEXT_ADDR + 32:   plaintext_in[287:256] <= wbs_dat_i;
                PLAINTEXT_ADDR + 36:   plaintext_in[319:288] <= wbs_dat_i;
                PLAINTEXT_ADDR + 40:   plaintext_in[351:320] <= wbs_dat_i;
                PLAINTEXT_ADDR + 44:   plaintext_in[383:352] <= wbs_dat_i;
                PLAINTEXT_ADDR + 48:   plaintext_in[415:384] <= wbs_dat_i;
                PLAINTEXT_ADDR + 52:   plaintext_in[447:416] <= wbs_dat_i;
                PLAINTEXT_ADDR + 56:   plaintext_in[479:448] <= wbs_dat_i;
                PLAINTEXT_ADDR + 60:   plaintext_in[511:480] <= wbs_dat_i;
                PLAINTEXT_ADDR + 64:   plaintext_in[543:512] <= wbs_dat_i;
                PLAINTEXT_ADDR + 68:   plaintext_in[575:544] <= wbs_dat_i;
                PLAINTEXT_ADDR + 72:   plaintext_in[607:576] <= wbs_dat_i;
                PLAINTEXT_ADDR + 76:   plaintext_in[639:608] <= wbs_dat_i;
                PLAINTEXT_ADDR + 80:   plaintext_in[671:640] <= wbs_dat_i;
                PLAINTEXT_ADDR + 84:   plaintext_in[703:672] <= wbs_dat_i;
                PLAINTEXT_ADDR + 88:   plaintext_in[735:704] <= wbs_dat_i;
                PLAINTEXT_ADDR + 92:   plaintext_in[767:736] <= wbs_dat_i;
                PLAINTEXT_ADDR + 96:   plaintext_in[799:768] <= wbs_dat_i;
                PLAINTEXT_ADDR + 100:  plaintext_in[831:800] <= wbs_dat_i;
                PLAINTEXT_ADDR + 104:  plaintext_in[863:832] <= wbs_dat_i;
                PLAINTEXT_ADDR + 108:  plaintext_in[895:864] <= wbs_dat_i;
                PLAINTEXT_ADDR + 112:  plaintext_in[927:896] <= wbs_dat_i;
                PLAINTEXT_ADDR + 116:  plaintext_in[959:928] <= wbs_dat_i;
                PLAINTEXT_ADDR + 120:  plaintext_in[991:960] <= wbs_dat_i;
                PLAINTEXT_ADDR + 124:  plaintext_in[1023:992] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 0:  ciphertext[31:0] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 4:  ciphertext[63:32] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 8:  ciphertext[95:64] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 12: ciphertext[127:96] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 16: ciphertext[159:128] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 20: ciphertext[191:160] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 24: ciphertext[223:192] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 28: ciphertext[255:224] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 32: ciphertext[287:256] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 36: ciphertext[319:288] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 40: ciphertext[351:320] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 44: ciphertext[383:352] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 48: ciphertext[415:384] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 52: ciphertext[447:416] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 56: ciphertext[479:448] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 60: ciphertext[511:480] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 64: ciphertext[543:512] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 68: ciphertext[575:544] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 72: ciphertext[607:576] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 76: ciphertext[639:608] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 80: ciphertext[671:640] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 84: ciphertext[703:672] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 88: ciphertext[735:704] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 92: ciphertext[767:736] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 96: ciphertext[799:768] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 100: ciphertext[831:800] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 104: ciphertext[863:832] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 108: ciphertext[895:864] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 112: ciphertext[927:896] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 116: ciphertext[959:928] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 120: ciphertext[991:960] <= wbs_dat_i;
                CIPHERTEXT_ADDR + 124: ciphertext[1023:992] <= wbs_dat_i;

                IV_ADDR + 0:           iv[31:0] <= wbs_dat_i;
                IV_ADDR + 4:           iv[63:32] <= wbs_dat_i;
                IV_ADDR + 8:           iv[95:64] <= wbs_dat_i;
                IV_ADDR + 12:          iv[127:96] <= wbs_dat_i;
                KEY_ADDR + 0:          key[31:0] <= wbs_dat_i;
                KEY_ADDR + 4:          key[63:32] <= wbs_dat_i;
                KEY_ADDR + 8:          key[95:64] <= wbs_dat_i;
                KEY_ADDR + 12:         key[127:96] <= wbs_dat_i;
                KEY_ADDR + 16:         key[159:128] <= wbs_dat_i;
                KEY_ADDR + 20:         key[191:160] <= wbs_dat_i;
                KEY_ADDR + 24:         key[223:192] <= wbs_dat_i;
                KEY_ADDR + 28:         key[255:224] <= wbs_dat_i;

        endcase
   
         end
         end
   end
          
     always @(posedge wb_clk_i) begin
          if(wb_rst_i)
                wbs_ack_o <= 0;
       else if (wbs_stb_i && !wbs_sta_o &&
    (
        (wbs_adr_i >= DATA_ADDR && wbs_adr_i < DATA_ADDR + 312) || 
        (wbs_adr_i >= IV_ADDR && wbs_adr_i < IV_ADDR + 16) ||  
        (wbs_adr_i >= KEY_ADDR && wbs_adr_i < KEY_ADDR + 32) ||       
        (wbs_adr_i >= PLAINTEXT_ADDR && wbs_adr_i < PLAINTEXT_ADDR + 128) ||
        (wbs_adr_i >= CIPHERTEXT_ADDR && wbs_adr_i < CIPHERTEXT_ADDR + 128) 
    )
) begin
    wbs_ack_o <= 1'b1;
end
 else begin
                wbs_ack_o <= 1'b0;
          end
    end

endmodule
