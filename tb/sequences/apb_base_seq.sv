//-----------------------------------------------------------------------------
// File: apb_base_seq.sv
// Description: APB Base Sequence
//              Simple sequence that does one write followed by one read
//              to the same address. Used as a basic sanity test.
//-----------------------------------------------------------------------------

class apb_base_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_base_seq)

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction: new

  //-------------------------------------------------------------------------
  // Body Task
  // Main sequence execution
  //-------------------------------------------------------------------------
  task body();
    `uvm_info("BASE_SEQ", "Starting base sequence", UVM_LOW)

    // Step 1: Write 0xCAFE_CAFE to address 0x10
    `uvm_do_with(req, {
      paddr  == 32'h10;
      pwrite == 1;
      pwdata == 32'hCAFE_CAFE;
    })

    // Step 2: Read back from address 0x10
    `uvm_do_with(req, {
      paddr  == 32'h10;
      pwrite == 0;
    })

    `uvm_info("BASE_SEQ", "Base sequence completed", UVM_LOW)
  endtask: body

endclass: apb_base_seq