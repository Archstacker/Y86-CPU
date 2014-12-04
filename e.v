`include "defines.v"

module e(
    input   wire                rst,
    input   wire[`NIBBLE]       E_icode_i,
    input   wire[`NIBBLE]       E_ifun_i,
    input   wire[`WORD]         E_valA_i,
    input   wire[`WORD]         E_valB_i,
    input   wire[`WORD]         E_valC_i,
    input   wire[`NIBBLE]       E_dstE_i,
    output  reg signed[`WORD]   e_valE_o,
    output  reg[`NIBBLE]        e_dstE_o,
    output  reg                 e_Cnd_o
);

    reg zf;
    reg sf;
    reg of;
    initial e_valE_o <= 32'H00000000;
    always @ (*) begin
        e_dstE_o    <=      E_dstE_i;
        case ( E_icode_i )
            `ICMOVXX:   begin
                case ( E_ifun_i )
                    `FRRMOVL:   begin
                        e_valE_o    <=      E_valA_i;
                    end
                endcase
            end

            `IIRMOVL:   begin
                e_valE_o    <=      E_valC_i;
            end

            `IRMMOVL:   begin
                e_valE_o    <=      E_valB_i + E_valC_i;
            end

            `IMRMOVL:   begin
                e_valE_o    <=      E_valB_i + E_valC_i;
            end

            `IOPL:      begin
                case ( E_ifun_i )
                    `FADDL:     begin
                        e_valE_o    <=      E_valB_i + E_valA_i;
                    end
                    `FSUBL:     begin
                        e_valE_o    <=      E_valB_i - E_valA_i;
                    end
                    `FANDL:     begin
                        e_valE_o    <=      E_valB_i & E_valA_i;
                    end
                    `FXORL:     begin
                        e_valE_o    <=      E_valB_i ^ E_valA_i;
                    end
                endcase
                zf      <=      e_valE_o == 0 ;
                sf      <=      e_valE_o < 0 ;
                of      <=      (E_valA_i<0 == E_valB_i<0) && (e_valE_o<0 != E_valA_i<0) ;
            end

            `IJXX:      begin
                case ( E_ifun_i )
                    `FJMP:      begin
                        e_Cnd_o <=      1;
                    end
                    `FJLE:      begin
                        e_Cnd_o <=      (sf ^ of) | zf;
                    end
                    `FJL:       begin
                        e_Cnd_o <=      (sf ^ of);
                    end
                    `FJE:       begin
                        e_Cnd_o <=      zf;
                    end
                    `FJNE:      begin
                        e_Cnd_o <=      ~zf;
                    end
                    `FJGE:      begin
                        e_Cnd_o <=      ~(sf ^ of);
                    end
                    `FJG:       begin
                        e_Cnd_o <=      ~(sf ^ of) & ~zf;
                    end
                endcase
            end

            `ICALL:     begin
                e_valE_o    <=      E_valB_i - 4;
            end

            `IRET:      begin
                e_valE_o    <=      E_valB_i + 4;
            end

            `IPUSHL:    begin
                e_valE_o    <=      E_valB_i - 4;
            end

            `IPOPL:     begin
                e_valE_o    <=      E_valB_i + 4;
            end
        endcase
    end

endmodule
