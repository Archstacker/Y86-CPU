`include "defines.v"

module m(
    input   wire                rst,
    input   wire[`NIBBLE]       M_icode_i,
    input   wire[`WORD]         M_valA_i,
    input   wire[`WORD]         M_valP_i,
    input   wire[`WORD]         M_valE_i,
    input   wire[`WORD]         valM_i,

    output  reg                 mem_read,
    output  reg                 mem_write,
    output  reg[`WORD]          mem_addr,
    output  reg[`WORD]          mem_data,
    output  reg[`WORD]          m_valM_o
);

    always @ (*) begin
        mem_read    <=      `DISABLE;
        mem_write   <=      `DISABLE;
        case ( M_icode_i )
            `IRMMOVL:   begin
                mem_write   <=      `ENABLE;
                mem_addr    <=      M_valE_i;
                mem_data    <=      M_valA_i;
            end
            `IMRMOVL:   begin
                mem_read    <=      `ENABLE;
                mem_addr    <=      M_valE_i;
            end
            `ICALL:     begin
                mem_write   <=      `ENABLE;
                mem_addr    <=      M_valE_i;
                mem_data    <=      M_valP_i;
            end
            `IRET:      begin
                mem_read    <=      `ENABLE;
                mem_addr    <=      M_valA_i;
            end
            `IPUSHL:    begin
                mem_write   <=      `ENABLE;
                mem_addr    <=      M_valE_i;
                mem_data    <=      M_valA_i;
            end
            `IPOPL:     begin
                mem_read    <=      `ENABLE;
                mem_addr    <=      M_valA_i;
            end
        endcase
        m_valM_o    <=      valM_i;
    end

endmodule
