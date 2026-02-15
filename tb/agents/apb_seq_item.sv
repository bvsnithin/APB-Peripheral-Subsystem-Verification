//-----------------------------------------------------------------------------
// File: apb_seq_item.sv
// Description: APB Sequence Item (Transaction)
//              Represents a single APB read or write transaction.
//              Contains randomizable fields with constraints.
//-----------------------------------------------------------------------------

class apb_seq_item extends uvm_sequence_item;

  //-------------------------------------------------------------------------
  // Transaction Fields
  //-------------------------------------------------------------------------
  rand bit [31:0] paddr;    // Address (randomizable)
  rand bit [31:0] pwdata;   // Write data (randomizable)
  rand bit        pwrite;   // 1=write, 0=read (randomizable)
  bit      [31:0] prdata;   // Read data (NOT random - captured from DUT)

  //-------------------------------------------------------------------------
  // UVM Field Automation
  // Enables automatic print, copy, compare, pack/unpack
  //-------------------------------------------------------------------------
  `uvm_object_utils_begin(apb_seq_item)
    `uvm_field_int(paddr,  UVM_ALL_ON)
    `uvm_field_int(pwdata, UVM_ALL_ON)
    `uvm_field_int(pwrite, UVM_ALL_ON)
    `uvm_field_int(prdata, UVM_ALL_ON)
  `uvm_object_utils_end

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction: new

  //-------------------------------------------------------------------------
  // Constraints
  //-------------------------------------------------------------------------

  // Address must be 32-bit word aligned (divisible by 4)
  constraint addr_alignment_c {
    paddr % 4 == 0;
  }

  // Address must be within valid RAM range (0 to 1023 words)
  constraint addr_range_c {
    paddr inside {[0:1023]};
  }

endclass: apb_seq_item