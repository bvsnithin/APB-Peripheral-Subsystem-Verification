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
