`include "/Users/azhar/test/verilog/rtl/SHA3_256.v"

module sha # (
     parameter   [31:0]  BASE_ADDRESS    = 32'h3000_0000,   
     parameter   [31:0]  DIGEST_ADDR  = BASE_ADDRESS,
     parameter   [31:0]  DATA_ADDR = BASE_ADDRESS + 32 ,
     parameter  integer DATAIN =64 
)(
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

    output reg [DATAIN - 1 :0] datain,
    input wire [255:0] digest
);

    assign wbs_sta_o = 0;

 Sha3_256   uut (
       .clk(wb_clk_i),
       .rst(wb_rst_i),
       .datain(datain),
       .digest(digest)
   );
   always @(posedge wb_clk_i ) begin
    
    if(wb_rst_i) begin
        datain <= 1088'h0;
    end else if (wbs_stb_i && wbs_cyc_i && wbs_we_i && !wbs_sta_o && !wbs_ack_o) begin
        case (wbs_adr_i)
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
        endcase
   end
   end
    always @(posedge wb_clk_i) begin
          if(wb_rst_i)
                wbs_ack_o <= 0;
          else if (wbs_stb_i && !wbs_sta_o && 
          (wbs_adr_i >= DATA_ADDR && wbs_adr_i < DATA_ADDR + 252)) begin
                wbs_ack_o <= 1'b1;
          
          end else begin
                wbs_ack_o <= 1'b0;
          end
    end
    endmodule