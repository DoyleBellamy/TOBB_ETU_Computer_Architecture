`timescale 1ns / 1ps


module kasirgabp(
	input saat,
	input reset, 
	input [31:0] buyruk_adresi, 
	input onceki_buyruk_atladi,
	output ongoru 
);
    
    
    reg [2:0] genel_gecmis_yazmaci; 
    reg [1:0] cift_kutuplu_sayac_tablosu [7:0]; 
    // 00 -> G.T, 01 -> Z.T, 10 -> Z.A, 11 -> G.A
    reg ongoruicin;

    integer i;
    initial begin
        ongoruicin=0;
        genel_gecmis_yazmaci = 3'b0;
        for(i = 0; i < 8; i = i + 1)
            cift_kutuplu_sayac_tablosu[i] = 2'b0;  
    end
    wire [2:0] ongoru_tablo_adresi; 
    assign ongoru_tablo_adresi = genel_gecmis_yazmaci ^ buyruk_adresi[4:2];

    always@* begin
        case (cift_kutuplu_sayac_tablosu[ongoru_tablo_adresi])
        0: ongoruicin=0;
        1: ongoruicin=0;
        2: ongoruicin=1;
        3: ongoruicin=1;
        endcase
    end
    
    always@(posedge saat) begin
        //reg degerlerimizi 0'lýyoruz
        if(reset) begin
             genel_gecmis_yazmaci <= 3'b0;
             for(i = 0; i < 8; i = i + 1)
                cift_kutuplu_sayac_tablosu[i] <= 2'b0; 
        end
        //Sola kaydýrýp son bitini en son buyruðun dallanýp dallanmadýðýný koyuyoruz
        else begin
            genel_gecmis_yazmaci[2:1]<=genel_gecmis_yazmaci[1:0];
            genel_gecmis_yazmaci[0]<=onceki_buyruk_atladi;   
            case (cift_kutuplu_sayac_tablosu[ongoru_tablo_adresi])
            0: begin
                if (onceki_buyruk_atladi) begin
                    cift_kutuplu_sayac_tablosu[ongoru_tablo_adresi]<=1;
                end
            end
            1: begin
                if (onceki_buyruk_atladi) begin
                    cift_kutuplu_sayac_tablosu[ongoru_tablo_adresi]<=2;
                end
                else  begin
                    cift_kutuplu_sayac_tablosu[ongoru_tablo_adresi]<=0;
                end
            end
            2: begin
                if (onceki_buyruk_atladi) begin
                    cift_kutuplu_sayac_tablosu[ongoru_tablo_adresi]<=3;
                end
                else  begin
                    cift_kutuplu_sayac_tablosu[ongoru_tablo_adresi]<=1;
                end
            end
            3: begin
                if (!onceki_buyruk_atladi) begin
                    cift_kutuplu_sayac_tablosu[ongoru_tablo_adresi]<=2;
                end
                
            end
            endcase 
        end
    end
    
    assign  ongoru = ongoruicin;

    
    
endmodule
