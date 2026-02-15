//-----------------------------------------------------------------------------
// File: apb_scoreboard.sv
// Description: APB Scoreboard
//              Maintains a reference model (shadow memory) and compares
//              DUT read data against expected values.
//-----------------------------------------------------------------------------

class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  //-------------------------------------------------------------------------
  // Analysis Import
  // Receives transactions from monitor via analysis port
  // Note: uvm_analysis_imp requires item type AND this class type
  //-------------------------------------------------------------------------
  uvm_analysis_imp #(apb_seq_item, apb_scoreboard) item_collected_export;

  //-------------------------------------------------------------------------
  // Reference Model
  // Associative array to mirror DUT memory contents
  //-------------------------------------------------------------------------
  bit [31:0] ref_mem [int];

  // Statistics counters
  int num_writes = 0;
  int num_reads  = 0;
  int num_passes = 0;
  int num_fails  = 0;

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_export = new("item_collected_export", this);
  endfunction: new

  //-------------------------------------------------------------------------
  // Write Function
  // Called automatically when monitor broadcasts a transaction
  //-------------------------------------------------------------------------
  virtual function void write(apb_seq_item trans);

    if (trans.pwrite) begin
      // WRITE OPERATION: Update reference model
      `uvm_info("SCB", $sformatf("WRITE: Addr=0x%0h Data=0x%0h", 
                                  trans.paddr, trans.pwdata), UVM_LOW)
      ref_mem[trans.paddr] = trans.pwdata;
      num_writes++;

    end else begin
      // READ OPERATION: Compare DUT data against reference model
      num_reads++;

      // Check if address was previously written
      if (!ref_mem.exists(trans.paddr)) begin
        `uvm_warning("SCB", $sformatf("Reading uninitialized addr=0x%0h, expecting 0", 
                                       trans.paddr))
        ref_mem[trans.paddr] = 0;
      end

      // Compare actual vs expected
      if (trans.prdata !== ref_mem[trans.paddr]) begin
        // MISMATCH
        `uvm_error("SCB", $sformatf("MISMATCH! Addr=0x%0h Exp=0x%0h Act=0x%0h",
                                     trans.paddr, ref_mem[trans.paddr], trans.prdata))
        num_fails++;
      end else begin
        // MATCH
        `uvm_info("SCB", $sformatf("MATCH! Addr=0x%0h Data=0x%0h", 
                                    trans.paddr, trans.prdata), UVM_LOW)
        num_passes++;
      end
    end
  endfunction: write

  //-------------------------------------------------------------------------
  // Report Phase
  // Print summary statistics at end of simulation
  //-------------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCB", "========== Scoreboard Summary ==========", UVM_LOW)
    `uvm_info("SCB", $sformatf("  Total Writes: %0d", num_writes), UVM_LOW)
    `uvm_info("SCB", $sformatf("  Total Reads:  %0d", num_reads), UVM_LOW)
    `uvm_info("SCB", $sformatf("  Passes:       %0d", num_passes), UVM_LOW)
    `uvm_info("SCB", $sformatf("  Fails:        %0d", num_fails), UVM_LOW)
    `uvm_info("SCB", "=========================================", UVM_LOW)
  endfunction: report_phase

endclass: apb_scoreboard