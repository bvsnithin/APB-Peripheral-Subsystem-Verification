# APB-Peripheral-Subsystem-Verification
A comprehensive SystemVerilog/UVM testbench verifying an AMBA APB Subsystem containing UART, SPI, and I2C controllers.

# APB Peripheral Subsystem Verification

![Language](https://img.shields.io/badge/Language-SystemVerilog-blue)
![Methodology](https://img.shields.io/badge/Methodology-UVM-orange)

## 📖 Project Overview

This project is a complete **System-on-Chip (SoC) verification environment** built using **SystemVerilog** and **UVM**.

Instead of verifying protocols in isolation, this project verifies a **Peripheral Subsystem**. It simulates how a CPU interacts with low-speed peripherals (UART, SPI, I2C) through a standard bus interface (**AMBA APB**).

The goal is to validate that the APB Bridge correctly routes data to the specific controllers, and that the controllers correctly translate that data onto their respective physical interfaces.

---

## 🍕 The Concept

Here is a simple analogy used to design this testbench:

**Imagine a busy Pizza Restaurant:**

1.  **The Boss (The CPU/APB Master):** The Boss sits in the office. He is too busy to run to the door. When he wants to talk to a customer, he writes a note and drops it in the Hallway.
2.  **The Hallway (The AMBA APB Bus):** This is the path the notes travel. It connects the office to the front counter.
3.  **The Helpers (The Peripherals):** There are three specialists at the counter:
    * **Mr. UART:** Talks to customers one-on-one (Serial).
    * **Mrs. SPI:** Fast and efficient, moving boxes out and money in simultaneously.
    * **Mr. I2C:** Polite and checks addresses before delivering.
4.  **The Health Inspector (The UVM Testbench):** This is **YOU**.
    * You don't make the pizza. You create chaos to see if the restaurant breaks.
    * *Test:* "What happens if the Boss sends 100 notes really fast?" (FIFO Overflow).
    * *Test:* "What happens if the Hallway lights turn off?" (Bus Error).

**If the restaurant survives the chaos and delivers the right pizza, the design passes.**

---

## 📁 Directory Structure

This project is organized as follows:

```
APB-Peripheral-Subsystem-Verification/
├── README.md                    # Main project documentation
├── setupX.bash                  # Setup script for TAMU students
├── doc/                         # Detailed documentation
│   └── [Additional docs]        # Protocol specs, architecture docs, etc.
├── design/                      # RTL Design files
│   └── [SystemVerilog HDL]
├── tb/                          # UVM Testbench
│   ├── agents/                  # UVM Agents (UART, SPI, I2C)
│   ├── env/                     # UVM Environment configuration
│   ├── interfaces/              # SystemVerilog Interfaces
│   ├── sequences/               # Test sequences and stimulus
│   ├── tests/                   # Test cases
│   └── top/                     # Top-level testbench module
└── sim/                         # Simulation directory
    ├── file_list.f              # List of files to compile
    └── run.f                    # Simulation run commands
```

### Directory Descriptions

- **`doc/`** - Contains comprehensive documentation including protocol specifications, architecture diagrams, and verification plans. Start here for detailed information.
- **`design/`** - RTL design files for the APB peripheral subsystem (UART, SPI, I2C controllers).
- **`tb/`** - Complete UVM-based verification environment:
  - **`agents/`** - Reusable UVM agents for each peripheral protocol
  - **`env/`** - Environment configuration, scoreboards, and coverage
  - **`interfaces/`** - SystemVerilog interfaces for protocol transactions
  - **`sequences/`** - Pre-defined and random stimulus sequences
  - **`tests/`** - Specific test cases for different verification scenarios
  - **`top/`** - Top-level testbench hierarchy
- **`sim/`** - Simulation artifacts and configuration files

---

## 📚 Documentation

For detailed documentation on various aspects of this project, visit the **[`doc/`](doc/)** folder.

---

## 🚀 How to Run the Project

### For Texas A&M Students

If you are a **Texas A&M student** with access to the ECEN Linux servers, follow these steps:

1. **Clone the repository** on the ECEN Linux server:
   ```bash
   git clone <repository-url>
   cd APB-Peripheral-Subsystem-Verification
   ```

2. **Load the CSCE-616 environment**:
   ```bash
   load-csce-616
   ```
   This command sets up all necessary EDA tools, compilers, and simulators for the project.

3. **Run the setup script**:
   ```bash
   bash setupX.bash
   ```
   This script configures the environment and prepares the project for simulation.

4. **Navigate to the simulation directory and run the testbench**:
   ```bash
   cd sim
   xrun -f run.f
   ```
   This command compiles and runs the complete verification environment using the xrun simulator.

### For Other Users

If you are not on the TAMU ECEN server, you will need to:
- Install a compatible SystemVerilog simulator (e.g., Cadence Xcelium, Mentor Questa, or an open-source alternative)
- Ensure UVM libraries are properly configured
- Modify the simulation scripts as needed for your environment
- Run: `xrun -f sim/run.f` (or equivalent command for your simulator)

---
