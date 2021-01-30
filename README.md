# RISC-V
Pipelined RISC-V core made as a learning exercise in Verilog, SystemVerilog and UVM. Targeted for FPGAs; no specific platform required. Vivado was chosen for its free and easy UVM support. Until 3rd-party IP is required, the design is for all intents and purposes platform-agnostic.
The design is based off of Figure C.18+C.19 in *Computer Architecture - A Quantitative Approach, 6th ed.*

## File Structure
```
riscv
│   .gitignore
│   README.md
│   LICENSE
│
└───sim  <----- Testbench files only.
│   │   modulename1_tb.v
│   │   modulename2_tb.v
│   │       ...
│   │
│   └───pipeline  <----- UVM components go into a single folder per testbench.
│       │   pip_agent.sv
│       │   pip_monitor.sv
│       │   ...
│   
└───src <----- Design and top modules. All files must be syhtesizable.
│   │   design_module1.v
│   │       ...
│
└───doc  <----- Final documents and their assets (soon).
│   │   SBucur_riscv_userdoc.docx
│   │   SBucur_riscv_engdoc.docx
│   │   id_tb.png
│   │       ...
```

## How to load the project
Launch `riscv/vivado_riscv/vivado_riscv.xpr` with Xilinx Vivado.