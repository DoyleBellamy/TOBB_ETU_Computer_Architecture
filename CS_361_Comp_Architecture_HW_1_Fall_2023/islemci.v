`timescale 1ns/1ps

`define BELLEK_ADRES    32'h8000_0000
`define VERI_BIT        32
`define ADRES_BIT       32
`define YAZMAC_SAYISI   32

module islemci (
    input                       clk,
    input                       rst,
    output  [`ADRES_BIT-1:0]    bellek_adres,
    input   [`VERI_BIT-1:0]     bellek_oku_veri,
    output  [`VERI_BIT-1:0]     bellek_yaz_veri,
    output                      bellek_yaz
);

localparam GETIR        = 2'd0;
localparam COZYAZMACOKU = 2'd1;
localparam YURUTGERIYAZ = 2'd2;

localparam LUI  = 4'd0;
localparam AUIPC= 4'd1;
localparam JAL  = 4'd2;
localparam JALR = 4'd3;
localparam BEQ  = 4'd4;
localparam BNE  = 4'd5;
localparam BLT  = 4'd6;
localparam LW   = 4'd7;
localparam SW   = 4'd8;
localparam ADDI = 4'd9;
localparam ADD  = 4'd10;
localparam SUB  = 4'd11;
localparam OR   = 4'd12;
localparam AND  = 4'd13;
localparam XOR  = 4'd14;

reg [1:0] simdiki_asama_r;
reg [`VERI_BIT-1:0] yazmac_obegi [0:`YAZMAC_SAYISI-1];
reg [`ADRES_BIT-1:0] ps_r;
reg [`ADRES_BIT-1:0] program_sayaci_r_temporary ;
reg [`VERI_BIT-1:0] bellek_yaz_veri_reg;
reg [31:0] buyruk;
reg [3:0] durum;
reg [6:0] opcode;
reg bellek_yaz_r;
integer i;
initial begin
    bellek_yaz_r = 0;
    simdiki_asama_r = 0;
    for(i = 0; i<32 ; i = i+1)begin
        yazmac_obegi[i] = 0;
    end
    ps_r = 32'h8000_0000;
    program_sayaci_r_temporary = 0;
    bellek_yaz_veri_reg = 0;
    bellek_yaz_r = 0;
    buyruk = 0;
    durum = 0;
    opcode = 0;
end


always @(posedge clk) begin
    if (rst) begin
        ps_r <= `BELLEK_ADRES;
        simdiki_asama_r <= GETIR;
    end
    
    else begin   
            if(simdiki_asama_r == GETIR) begin
                simdiki_asama_r <= COZYAZMACOKU;
                bellek_yaz_r <= 0;
            end
            else if(simdiki_asama_r == COZYAZMACOKU) begin    
                simdiki_asama_r <= YURUTGERIYAZ;
            end
            else if(simdiki_asama_r == YURUTGERIYAZ) begin 
                simdiki_asama_r <= GETIR;
                case(durum)
                LUI : begin 
                    ps_r = ps_r +4;
                end
                AUIPC : begin 
                     ps_r = ps_r +4;
                end
                JAL : begin
                    yazmac_obegi[buyruk[11:7]] = ps_r + 4;
                    ps_r = ps_r + {buyruk[31], buyruk[19:12], buyruk[20], buyruk[30:21]};
                end
                JALR : begin
                    yazmac_obegi[buyruk[11:7]] = ps_r + 4;
                    ps_r = yazmac_obegi[buyruk[19:15]] + buyruk[31:20];
                end
                BEQ : begin
                    ps_r = (yazmac_obegi[buyruk[24:20]] == yazmac_obegi[buyruk[19:15]])
                    ? ps_r + ({buyruk[31], buyruk[7], buyruk[30:25], buyruk[11:8]} * 4)
                    : ps_r + 4; 
                end
                BNE : begin
                    ps_r = (yazmac_obegi[buyruk[24:20]] >= yazmac_obegi[buyruk[19:15]])
                    ? ps_r + ({buyruk[31], buyruk[7], buyruk[30:25], buyruk[11:8]} * 4)
                    : ps_r + 4;
                end
                BLT : begin
                    ps_r = (yazmac_obegi[buyruk[24:20]] < yazmac_obegi[buyruk[19:15]])
                    ? ps_r + ({buyruk[31], buyruk[7], buyruk[30:25], buyruk[11:8]} * 4)
                    : ps_r + 4;
                end
                LW : begin
                    ps_r = ps_r +4;
                end
                SW : begin
                    ps_r = ps_r +4;
                end
                ADDI : begin
                    ps_r = ps_r +4;
                end
                ADD : begin
                    ps_r = ps_r +4;
                end
                SUB : begin
                    ps_r = ps_r +4;
                end
                OR : begin
                    ps_r = ps_r +4;
    
                end
                AND : begin
                    ps_r = ps_r +4;
                end
                XOR : begin
                    ps_r = ps_r +4;
                end
                endcase
            end
     end
end

always @(*) begin
    // ASAMA 1
    if (simdiki_asama_r == GETIR) begin
        buyruk = bellek_oku_veri;
    end
    
    //ASAMA 2
    else if(simdiki_asama_r == COZYAZMACOKU) begin
         opcode = buyruk[6:0]; 

        //ADD SUB OR AND XOR    
        if(opcode==7'b0110011) begin
            if(buyruk[31:25]==7'b0000000) begin //ADD
                durum = ADD;       
            end
            else if(buyruk[14:12]==3'b000) begin //SUB
                durum = SUB;                
            end
            else if(buyruk[14:12]==3'b110) begin // OR
                durum = OR;         
            end
            else if(buyruk[14:12]==3'b111) begin // AND
                durum = AND;        
            end
            else if(buyruk[14:12]==3'b100) begin //XOR
                durum = XOR;         
            end
        end
        
        if(opcode==7'b1100011) begin
            if(buyruk[14:12]==3'b000) begin //BEQ
                durum = BEQ;                      
            end
            else if(buyruk[14:12]==3'b001) begin //BNE
                durum = BNE;  
            end
            else if(buyruk[14:12]==3'b100) begin //BLT
                durum = BLT;  
            end
        end
        
        // LUI 
        if(opcode==7'b0110111) begin
            durum = LUI;          
        end
        
        // AUIPC 
        if(opcode==7'b0010111) begin
            durum = AUIPC;        
        end
        
        // JAL 
        if(opcode==7'b1101111) begin
            durum = JAL;
        end
        
        // JALR 
        if(opcode==7'b1100111) begin
            durum = JALR;
        end
        
        // LW
        if(opcode==7'b0000011) begin
            program_sayaci_r_temporary  = ps_r;
            ps_r = yazmac_obegi[buyruk[19:15]] + { {20{buyruk[31]}} , buyruk[31:20] } ;
            yazmac_obegi[buyruk[11:7]] = bellek_oku_veri ;
            durum = LW;
        end
        
        // SW
        if(opcode==7'b0100011) begin
            bellek_yaz_r = 1'b1;
            program_sayaci_r_temporary = ps_r ;
            ps_r = yazmac_obegi[buyruk[19:15]] + { {20{buyruk[31]}} , buyruk[31:25] , buyruk[11:7] } ;
            bellek_yaz_veri_reg = yazmac_obegi[buyruk[24:20]];
            durum = SW;
         end
        
        // ADDI 
        if(opcode==7'b0010011) begin
            durum = ADDI;
        end

    end
    
    // ASAMA 3
    else if(simdiki_asama_r == YURUTGERIYAZ) begin
        case(durum)
            LUI : begin 
                yazmac_obegi[buyruk[11:7]] = {buyruk[31:12], 12'b0 };
            end
            AUIPC : begin 
                 yazmac_obegi[buyruk[11:7]] = ps_r + {buyruk[31:12], 12'b0 };
            end
            LW : begin
                ps_r = program_sayaci_r_temporary;
            end
            SW : begin
                ps_r = program_sayaci_r_temporary;
            end
            ADDI : begin
                yazmac_obegi[buyruk[11:7]] = yazmac_obegi[buyruk[19:15]] + $signed(buyruk[31:20]);
            end
            ADD : begin
                yazmac_obegi[buyruk[11:7]] = yazmac_obegi[buyruk[24:20]] + yazmac_obegi[buyruk[19:15]];
            end
            SUB : begin
                yazmac_obegi[buyruk[11:7]] = yazmac_obegi[buyruk[24:20]] - yazmac_obegi[buyruk[19:15]];
            end
            OR : begin
                yazmac_obegi[buyruk[11:7]] = yazmac_obegi[buyruk[24:20]] | yazmac_obegi[buyruk[19:15]]; 
            end
            AND : begin
                yazmac_obegi[buyruk[11:7]] = yazmac_obegi[buyruk[24:20]] &  yazmac_obegi[buyruk[19:15]];  
            end
            XOR : begin
                yazmac_obegi[buyruk[11:7]] = yazmac_obegi[buyruk[24:20]] ^ yazmac_obegi[buyruk[19:15]];  
            end
        endcase
    end
end


assign bellek_adres = ps_r;
assign bellek_yaz_veri = bellek_yaz_veri_reg;
assign bellek_yaz = bellek_yaz_r;

endmodule