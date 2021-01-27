/*
RISC-V random instruction generator

- the rand_instr class uses multiple parameters to generate a random instruction
- currently only works for the RV32I ISA


*/


class rand_instr;

    rand bit [6:0] opcode;

    constraint opcode_constr {
      opcode ==   
    };

    function  print_all();
                
    endfunction

endclass //rand_instr