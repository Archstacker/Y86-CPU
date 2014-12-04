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
        mem_read    <=      `READDISABLE;
        mem_write   <=      `WRITEDISABLE;
        case ( M_icode_i )
            `RMMOVL:    begin
                mem_write   <=      `WRITEENABLE;
                mem_addr    <=      M_valE_i;
                mem_data    <=      M_valA_i;
            end
            `MRMOVL:    begin
                mem_read    <=      `READENABLE;
                mem_addr    <=      M_valE_i;
            end
            `CALL:      begin
                mem_write   <=      `WRITEENABLE;
                mem_addr    <=      M_valE_i;
                mem_data    <=      M_valP_i;
            end
            `RET:       begin
                mem_read    <=      `ENABLE;
                mem_addr    <=      M_valA_i;
            end
            `PUSHL:     begin
                mem_write   <=      `WRITEENABLE;
                mem_addr    <=      M_valE_i;
                mem_data    <=      M_valA_i;
            end
            `POPL:      begin
                mem_read    <=      `READENABLE;
                mem_addr    <=      M_valA_i;
            end
        endcase
        m_valM_o    <=      valM_i;
    end

endmodule
