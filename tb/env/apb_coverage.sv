//-----------------------------------------------------------------------------
// File: apb_coverage.sv
// Description: Functional coverage collector for APB transactions.
//              Collects coverage on address ranges, data patterns, and
//              transaction types to ensure thorough verification.
//-----------------------------------------------------------------------------

class apb_coverage extends uvm_subscriber #(apb_seq_item);
  `uvm_component_utils(apb_coverage)

  //-------------------------------------------------------------------------
  // Coverage Group: apb_cg
  // Purpose: Define coverage points and crosses for APB transactions
  //-------------------------------------------------------------------------
  covergroup apb_cg;

    // Coverage Point: Transaction Type (Read vs Write)
    // Ensures both read and write operations are exercised
    cp_pwrite: coverpoint trans.pwrite {
      bins write = {1};
      bins read  = {0};
    }

    // Coverage Point: Address Ranges
    // Divides address space into bins to ensure various regions are accessed
    cp_paddr: coverpoint trans.paddr {
      bins low_addr    = {[0:255]};       // Lower address range
      bins mid_addr    = {[256:511]};     // Middle address range
      bins high_addr   = {[512:1023]};    // Upper address range
    }

    // Coverage Point: Write Data Patterns
    // Checks for interesting data patterns during writes
    cp_pwdata: coverpoint trans.pwdata {
      bins zero        = {32'h0000_0000};           // All zeros
      bins all_ones    = {32'hFFFF_FFFF};           // All ones
      bins walking_one = {32'h0000_0001, 32'h0000_0002, 32'h0000_0004, 
                          32'h0000_0008, 32'h0000_0010, 32'h0000_0020,
                          32'h0000_0040, 32'h0000_0080};  // Walking ones
      bins other       = default;                   // All other values
    }

    // Cross Coverage: Address Range x Transaction Type
    // Ensures all address ranges are accessed with both read and write
    cx_addr_type: cross cp_paddr, cp_pwrite;

  endgroup: apb_cg

  // Transaction handle for coverage sampling
  apb_seq_item trans;

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Create the covergroup instance
    apb_cg = new();
  endfunction: new

  //-------------------------------------------------------------------------
  // Write Function (from uvm_subscriber)
  // Called automatically when monitor broadcasts a transaction
  //-------------------------------------------------------------------------
  virtual function void write(apb_seq_item t);
    // Store the transaction for coverage sampling
    trans = t;
    // Sample the coverage
    apb_cg.sample();
    `uvm_info("COV", $sformatf("Coverage sampled: pwrite=%0b paddr=0x%0h", 
                               t.pwrite, t.paddr), UVM_HIGH)
  endfunction: write

  //-------------------------------------------------------------------------
  // Report Phase
  // Print coverage summary at end of simulation
  //-------------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV", $sformatf("APB Coverage = %0.2f%%", apb_cg.get_coverage()), UVM_LOW)
  endfunction: report_phase

endclass: apb_coverage
