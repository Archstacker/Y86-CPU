`include "defines.v"

module f(
    input   wire                rst,
    input   wire[`WORD]         f_pc_i,
    input   wire[`INSTBUS]      inst_i,

    //output  reg         instr_valid,
    //output  reg         need_regids,
    //output  reg         need_valC,

    output  reg[`NIBBLE]        f_icode_o,
    output  reg[`NIBBLE]        f_ifun_o,
    output  reg[`NIBBLE]        f_rA_o,
    output  reg[`NIBBLE]        f_rB_o,
    output  reg[`WORD]          f_valC_o,
    output  reg[`WORD]          f_valP_o,
    output  reg[`NIBBLE]        f_dstE_o,
    output  reg[`NIBBLE]        f_dstM_o
);

    always @ (*) begin
            f_icode_o   <=      4'h0;
            f_ifun_o    <=      4'h0;
            f_rA_o      <=      4'hf;
            f_rB_o      <=      4'hf;
            f_valC_o    <=      32'h00000000;
            f_valP_o    <=      32'h00000000;
            f_dstE_o    <=      4'hf;
            f_dstM_o    <=      4'hf;
        if (rst == `DISABLE) begin
            f_icode_o   <=      inst_i[`ICODE];
            f_ifun_o    <=      inst_i[`IFUN];
            case ( f_icode_o )
                `IHALT:     begin
                    f_valP_o    <=      f_pc_i+4'h1;
                end
                `INOP:      begin
                    f_valP_o    <=      f_pc_i+4'h1;
                end
                `ICMOVXX:   begin
                    f_rA_o      <=      inst_i[`RA];
                    f_rB_o      <=      inst_i[`RB];
                    f_valP_o    <=      f_pc_i+4'h2;
                    f_dstE_o    <=      inst_i[`RB];
                end
                `IIRMOVL:   begin
                    f_rA_o      <=      inst_i[`RA];
                    f_rB_o      <=      inst_i[`RB];
                    f_valC_o    <=      {inst_i[`BYTE5],inst_i[`BYTE4],inst_i[`BYTE3],inst_i[`BYTE2]};
                    f_valP_o    <=      f_pc_i+4'h6;
                    f_dstE_o    <=      inst_i[`RB];
                end
                `IRMMOVL:   begin
                    f_rA_o      <=      inst_i[`RA];
                    f_rB_o      <=      inst_i[`RB];
                    f_valC_o    <=      {inst_i[`BYTE5],inst_i[`BYTE4],inst_i[`BYTE3],inst_i[`BYTE2]};
                    f_valP_o    <=      f_pc_i+4'h6;
                end
                `IMRMOVL:   begin
                    f_rA_o      <=      inst_i[`RA];
                    f_rB_o      <=      inst_i[`RB];
                    f_valC_o    <=      {inst_i[`BYTE5],inst_i[`BYTE4],inst_i[`BYTE3],inst_i[`BYTE2]};
                    f_valP_o    <=      f_pc_i+4'h6;
                    f_dstM_o    <=      inst_i[`RA];
                end
                `IOPL:      begin
                    f_rA_o      <=      inst_i[`RA];
                    f_rB_o      <=      inst_i[`RB];
                    f_valP_o    <=      f_pc_i+4'h2;
                    f_dstE_o    <=      inst_i[`RB];
                end
                `IJXX:      begin
                    f_valC_o    <=      {inst_i[`BYTE4],inst_i[`BYTE3],inst_i[`BYTE2],inst_i[`BYTE1]};
                    f_valP_o    <=      f_pc_i+4'h5;
                end
                `ICALL:     begin
                    f_rA_o      <=      `RESP;
                    f_rB_o      <=      `RESP;
                    f_valC_o    <=      {inst_i[`BYTE4],inst_i[`BYTE3],inst_i[`BYTE2],inst_i[`BYTE1]};
                    f_valP_o    <=      f_pc_i+4'h5;
                    f_dstE_o    <=      `RESP;
                end
                `IRET:      begin
                    f_rA_o      <=      `RESP;
                    f_rB_o      <=      `RESP;
                    f_valP_o    <=      f_pc_i+4'h1;
                    f_dstE_o    <=      `RESP;
                end
                `IPUSHL:    begin
                    f_rA_o      <=      inst_i[`RA];
                    f_rB_o      <=      `RESP;
                    f_valP_o    <=      f_pc_i+4'h2;
                    f_dstE_o    <=      `RESP;
                end
                `IPOPL:     begin
                    f_rA_o      <=      `RESP;
                    f_rB_o      <=      `RESP;
                    f_valP_o    <=      f_pc_i+4'h2;
                    f_dstE_o    <=      `RESP;
                    f_dstM_o    <=      inst_i[`RA];
                end
            endcase
        end
    end
endmodule
