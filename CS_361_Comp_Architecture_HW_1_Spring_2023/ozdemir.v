
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2023 14:45:53
// Design Name: 
// Module Name: ozdemir
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ozdemir(
    input saat, reset,
    input [31:0] buyruk,
    output [31:0] program_sayaci,
    output [1023:0]yazmaclar
    );
    
    reg [31:0] yazmaclar_T [31:0];
    reg [31:0] ps_sonraki;
    reg [31:0] buyruk_adresi;
    reg [31:0] buyruk_ters;
    reg [31:0] fark_sonuc;


    integer i;
    initial begin
        buyruk_adresi <= 0;
        ps_sonraki <= 32'b0;
        for(i = 0; i < 32; i = i + 1)
            yazmaclar_T[i] = 32'b111;  
    end
    
    integer j;
    integer k;

    always @(posedge saat) begin
        buyruk_adresi <= ps_sonraki;
        for(j = 0; j < 32; j = j + 1)
            buyruk_ters[j] <=buyruk[31-j];
        /*
        if(rst == 1'b1) begin
            for(k = 0; k < 32; k = k + 1)
                yazmaclar_T[k] <= 32'b0;
        end
        */
    end
    
   always @(*) begin
        //ps_sonraki = buyruk_adresi;
        if(reset == 1'b1) begin
            ps_sonraki = 32'b0;
        end
       
        else if (buyruk_ters[6:0] == 7'b1110111 && buyruk_ters[14:12] == 3'b000 ) begin // KAREAL_TOPLA
            yazmaclar_T[buyruk_ters[11:7]]=yazmaclar_T[buyruk_ters[19:15]]*yazmaclar_T[buyruk_ters[19:15]]+yazmaclar_T[buyruk_ters[24:20]]*yazmaclar_T[buyruk[24:20]];
            ps_sonraki = buyruk_adresi+4;
        end
        
        
        else if (buyruk_ters[6:0] == 7'b1110111 && buyruk_ters[14:12] == 3'b001 ) begin // CARP_CIKAR
            yazmaclar_T[ buyruk_ters[11:7]]= yazmaclar_T[buyruk_ters[19:15]]*yazmaclar_T[buyruk_ters[24:20]]-yazmaclar_T[buyruk_ters[19:15]];
            ps_sonraki = buyruk_adresi+4;
        end
        
        else if (buyruk_ters[6:0] == 7'b1110111 && buyruk_ters[14:12] == 3'b100 ) begin // SIFRELE
            yazmaclar_T[ buyruk_ters[11:7]]=yazmaclar_T[buyruk_ters[19:15]]^yazmaclar_T[buyruk_ters[31:20]];
            ps_sonraki = buyruk_adresi+4;
        end
        
        //BURADA rs1'in her zaman sifir olmasina gore debug'da degisiklik yapilabilir.
         else if (buyruk_ters[6:0] == 7'b1110111 && buyruk_ters[14:12] == 3'b101 ) begin // TASI
            yazmaclar_T[buyruk_ters[11:7]]=yazmaclar_T[buyruk_ters[19:15]]+yazmaclar_T[buyruk_ters[31:20]];
            ps_sonraki = buyruk_adresi+4;
        end
        
        else if (buyruk_ters[6:0] == 7'b1111111 && buyruk_ters[14:12] != 3'b111 ) begin // IKIKAT_ATLA
            yazmaclar_T[buyruk_ters[11:7]]=buyruk_adresi+4;
            ps_sonraki = buyruk_adresi+buyruk_ters[31]*2**20+buyruk_ters[30:21]*2+buyruk_ters[20]*2**11+buyruk_ters[19:12]*2**12;
        end
        
        else if (buyruk_ters[6:0] == 7'b1110111 && buyruk_ters[14:12] == 3'b010 ) begin // BITSAY
            if(buyruk_ters[31]==1)begin
                yazmaclar_T[buyruk_ters[11:7]] = yazmaclar_T[buyruk_ters[19:15]][31]+yazmaclar_T[buyruk_ters[19:15]][30]+yazmaclar_T[buyruk_ters[19:15]][29]+yazmaclar_T[buyruk_ters[19:15]][28]+yazmaclar_T[buyruk_ters[19:15]][27]+yazmaclar_T[buyruk_ters[19:15]][26]+yazmaclar_T[buyruk_ters[19:15]][25]+yazmaclar_T[buyruk_ters[19:15]][24]+yazmaclar_T[buyruk_ters[19:15]][23]+yazmaclar_T[buyruk_ters[19:15]][22]+yazmaclar_T[buyruk_ters[19:15]][21]+yazmaclar_T[buyruk_ters[19:15]][20]+yazmaclar_T[buyruk_ters[19:15]][19]+yazmaclar_T[buyruk_ters[19:15]][18]+yazmaclar_T[buyruk_ters[19:15]][17]+yazmaclar_T[buyruk_ters[19:15]][16]+yazmaclar_T[buyruk_ters[19:15]][15]+yazmaclar_T[buyruk_ters[19:15]][14]+yazmaclar_T[buyruk_ters[19:15]][13]+yazmaclar_T[buyruk_ters[19:15]][12]+yazmaclar_T[buyruk_ters[19:15]][11]+yazmaclar_T[buyruk_ters[19:15]][10]+yazmaclar_T[buyruk_ters[19:15]][9]+yazmaclar_T[buyruk_ters[19:15]][8]+yazmaclar_T[buyruk_ters[19:15]][7]+yazmaclar_T[buyruk_ters[19:15]][6]+yazmaclar_T[buyruk_ters[19:15]][5]+yazmaclar_T[buyruk_ters[19:15]][4]+yazmaclar_T[buyruk_ters[19:15]][3]+yazmaclar_T[buyruk_ters[19:15]][2]+yazmaclar_T[buyruk_ters[19:15]][1]+yazmaclar_T[buyruk_ters[19:15]][0];
            end
            else begin 
                yazmaclar_T[buyruk_ters[11:7]] = 32-(yazmaclar_T[buyruk_ters[19:15]][31]+yazmaclar_T[buyruk_ters[19:15]][30]+yazmaclar_T[buyruk_ters[19:15]][29]+yazmaclar_T[buyruk_ters[19:15]][28]+yazmaclar_T[buyruk_ters[19:15]][27]+yazmaclar_T[buyruk_ters[19:15]][26]+yazmaclar_T[buyruk_ters[19:15]][25]+yazmaclar_T[buyruk_ters[19:15]][24]+yazmaclar_T[buyruk_ters[19:15]][23]+yazmaclar_T[buyruk_ters[19:15]][22]+yazmaclar_T[buyruk_ters[19:15]][21]+yazmaclar_T[buyruk_ters[19:15]][20]+yazmaclar_T[buyruk_ters[19:15]][19]+yazmaclar_T[buyruk_ters[19:15]][18]+yazmaclar_T[buyruk_ters[19:15]][17]+yazmaclar_T[buyruk_ters[19:15]][16]+yazmaclar_T[buyruk_ters[19:15]][15]+yazmaclar_T[buyruk_ters[19:15]][14]+yazmaclar_T[buyruk_ters[19:15]][13]+yazmaclar_T[buyruk_ters[19:15]][12]+yazmaclar_T[buyruk_ters[19:15]][11]+yazmaclar_T[buyruk_ters[19:15]][10]+yazmaclar_T[buyruk_ters[19:15]][9]+yazmaclar_T[buyruk_ters[19:15]][8]+yazmaclar_T[buyruk_ters[19:15]][7]+yazmaclar_T[buyruk_ters[19:15]][6]+yazmaclar_T[buyruk_ters[19:15]][5]+yazmaclar_T[buyruk_ters[19:15]][4]+yazmaclar_T[buyruk_ters[19:15]][3]+yazmaclar_T[buyruk_ters[19:15]][2]+yazmaclar_T[buyruk_ters[19:15]][1]+yazmaclar_T[buyruk_ters[19:15]][0]);
            end
            ps_sonraki = buyruk_adresi+4;
        end
        
       else begin // SEC_DALLAN
            if(buyruk_ters[31:30]==0) begin
                ps_sonraki = buyruk_adresi+4;
            end
            else if(buyruk_ters[31:30]==1&&yazmaclar[buyruk_ters[19:15]]==yazmaclar[buyruk_ters[24:20]]) begin
                ps_sonraki = buyruk_adresi+buyruk_ters[29:25]*32+buyruk_ters[11:8]*2+buyruk_ters[7]*1024;
            end
            else if(buyruk_ters[31:30]==2&&yazmaclar[buyruk_ters[19:15]]<yazmaclar[buyruk_ters[24:20]]) begin
                ps_sonraki = buyruk_adresi+buyruk_ters[29:25]*32+buyruk_ters[11:8]*2+buyruk_ters[7]*1024;
            end
            else if(buyruk_ters[31:30]==3&&yazmaclar[buyruk_ters[19:15]]>yazmaclar[buyruk_ters[24:20]]) begin
                ps_sonraki = buyruk_adresi+buyruk_ters[29:25]*32+buyruk_ters[11:8]*2+buyruk_ters[7]*1024;
            end            
        end
    end

    assign  yazmaclar[0*32 +: 32] = yazmaclar_T[0];
    assign  yazmaclar[1*32 +: 32] = yazmaclar_T[1];
    assign  yazmaclar[2*32 +: 32] = yazmaclar_T[2];
    assign  yazmaclar[3*32 +: 32] = yazmaclar_T[3];
    assign  yazmaclar[4*32 +: 32] = yazmaclar_T[4];
    assign  yazmaclar[5*32 +: 32] = yazmaclar_T[5];
    assign  yazmaclar[6*32 +: 32] = yazmaclar_T[6];
    assign  yazmaclar[7*32 +: 32] = yazmaclar_T[7];
    assign  yazmaclar[8*32 +: 32] = yazmaclar_T[8];
    assign  yazmaclar[9*32 +: 32] = yazmaclar_T[9]; 
    assign  yazmaclar[10*32 +: 32] = yazmaclar_T[10];
    assign  yazmaclar[11*32 +: 32] = yazmaclar_T[11];
    assign  yazmaclar[12*32 +: 32] = yazmaclar_T[12];
    assign  yazmaclar[13*32 +: 32] = yazmaclar_T[13];
    assign  yazmaclar[14*32 +: 32] = yazmaclar_T[14];
    assign  yazmaclar[15*32 +: 32] = yazmaclar_T[15];
    assign  yazmaclar[16*32 +: 32] = yazmaclar_T[16];
    assign  yazmaclar[17*32 +: 32] = yazmaclar_T[17];
    assign  yazmaclar[18*32 +: 32] = yazmaclar_T[18];
    assign  yazmaclar[19*32 +: 32] = yazmaclar_T[19];
    assign  yazmaclar[20*32 +: 32] = yazmaclar_T[20];
    assign  yazmaclar[21*32 +: 32] = yazmaclar_T[21];
    assign  yazmaclar[22*32 +: 32] = yazmaclar_T[22];
    assign  yazmaclar[23*32 +: 32] = yazmaclar_T[23];
    assign  yazmaclar[24*32 +: 32] = yazmaclar_T[24];
    assign  yazmaclar[25*32 +: 32] = yazmaclar_T[25]; 
    assign  yazmaclar[26*32 +: 32] = yazmaclar_T[26];
    assign  yazmaclar[27*32 +: 32] = yazmaclar_T[27];
    assign  yazmaclar[28*32 +: 32] = yazmaclar_T[28];
    assign  yazmaclar[29*32 +: 32] = yazmaclar_T[29];
    assign  yazmaclar[30*32 +: 32] = yazmaclar_T[30];
    assign  yazmaclar[31*32 +: 32] = yazmaclar_T[31];
    assign program_sayaci = ps_sonraki;
endmodule



