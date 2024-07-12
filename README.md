# SynchronousStack

## Overview

This repository contains the implementation of a synchronous stack as part of a lab assignment for the Computer Architecture course. The stack has a 4-bit width per cell and supports several commands. The project includes both a Logisim schematic and a SystemVerilog description.

## Project Structure

- `logisim/`: Contains the Logisim project files.
- `systemverilog/`: Contains the SystemVerilog files.

## Commands

The stack supports the following commands, issued through the `COMMAND` input:

- `0` - `nop`: No operation.
- `1` - `push`: Push a value onto the stack.
- `2` - `pop`: Pop a value from the stack.
- `3` - `get`: Get a value from a specific stack index relative to the top.

## Logisim Implementation

### File: `stack_logical.circ`

The Logisim implementation is divided into several sub-circuits:
- **Main Circuit (`main`)**: Contains only one instance of the `stack` sub-circuit and I/O elements for testing.
- **Stack Circuit (`stack`)**: Implements the stack logic using sub-circuits for memory cells and control logic.

#### Elements Used
- Logic gates: NOT, OR, AND, NOR, NAND, XOR, XNOR
- Additional elements: Splitter, Probe, Tunnel, Transmission Gate (CMOS)

### Usage
1. Open the `.circ` file in Logisim-evolution.
2. Simulate the circuit and test it using the input pins and probes.

## SystemVerilog Implementation

### Structural Model
- **File: `stack_structural.sv`**
- **Module: `stack_structural`**

### Behavioral Model
- **File: `stack_behaviour.sv`**
- **Module: `stack_behaviour`**

### Primitives Used
- Structural: PMOS, NMOS, CMOS, and basic logic gates (NOT, AND, NAND, OR, NOR, XOR, XNOR)
- Behavioral: Always blocks, initial blocks, assign statements, case statements, if statements

### Usage
1. Compile the SystemVerilog files using Icarus Verilog.
2. Run the testbenches to verify the functionality of the stack.

## Tools Required

- **Logisim-evolution**: Version 3.8.0 or later.
- **Icarus Verilog**: Version 10 or later (preferably 12).

## How to Run

### Logisim
1. Install [Logisim-evolution](https://github.com/logisim-evolution/logisim-evolution/releases/tag/v3.8.0).
2. Open the `.circ` file in Logisim-evolution.
3. Simulate the circuit.

### SystemVerilog
1. Install [Icarus Verilog](http://iverilog.icarus.com/).
2. Compile the SystemVerilog files:
   ```bash
   iverilog -o stack_behaviour_tb stack_behaviour_tb.sv stack_behaviour.sv
   vvp stack_behaviour_tb
# Synchronous Stack Implementation

## Overview

This repository contains the implementation of a synchronous stack as part of a lab assignment for the Computer Architecture course. The stack has a 4-bit width per cell and supports several commands. The project includes both a Logisim schematic and a SystemVerilog description.

## Project Structure

- `logisim/`: Contains the Logisim project files.
- `systemverilog/`: Contains the SystemVerilog files.
- `testbench/`: Contains the testbenches for SystemVerilog modules.

## Commands

The stack supports the following commands, issued through the `COMMAND` input:

- `0` - `nop`: No operation.
- `1` - `push`: Push a value onto the stack.
- `2` - `pop`: Pop a value from the stack.
- `3` - `get`: Get a value from a specific stack index relative to the top.

## Logisim Implementation

### File: `stack_logical_lite.circ` / `stack_logical_normal.circ`

The Logisim implementation is divided into several sub-circuits:
- **Main Circuit (`main`)**: Contains only one instance of the `stack` sub-circuit and I/O elements for testing.
- **Stack Circuit (`stack`)**: Implements the stack logic using sub-circuits for memory cells and control logic.

#### Elements Used
- Logic gates: NOT, OR, AND, NOR, NAND, XOR, XNOR
- Additional elements: Splitter, Probe, Tunnel, Transmission Gate (CMOS)

### Usage
1. Open the `.circ` file in Logisim-evolution.
2. Simulate the circuit and test it using the input pins and probes.

## SystemVerilog Implementation

### Structural Model
- **File: `stack_structural.sv`**
- **Module: `stack_structural_[lite/normal]`**
- **Testbench: `stack_structural_tb.sv`**

### Behavioral Model
- **File: `stack_behaviour.sv`**
- **Module: `stack_behaviour_[lite/normal]`**
- **Testbench: `stack_behaviour_tb.sv`**

### Primitives Used
- Structural: PMOS, NMOS, CMOS, and basic logic gates (NOT, AND, NAND, OR, NOR, XOR, XNOR)
- Behavioral: Always blocks, initial blocks, assign statements, case statements, if statements

### Usage
1. Compile the SystemVerilog files using Icarus Verilog.
2. Run the testbenches to verify the functionality of the stack.

## Tools Required

- **Logisim-evolution**: Version 3.8.0 or later.
- **Icarus Verilog**: Version 10 or later (preferably 12).

## How to Run

### Logisim
1. Install [Logisim-evolution](https://github.com/logisim-evolution/logisim-evolution/releases/tag/v3.8.0).
2. Open the `.circ` file in Logisim-evolution.
3. Simulate the circuit.

### SystemVerilog
1. Install [Icarus Verilog](http://iverilog.icarus.com/).
2. Compile the SystemVerilog files:
   ```bash
   iverilog -o stack_behaviour_tb stack_behaviour_tb.sv stack_behaviour.sv
   vvp stack_behaviour_tb
