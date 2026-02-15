//-----------------------------------------------------------------------------
// File: apb_rand_seq.sv
// Description: Sequence that generates random APB read/write transactions.
//              Useful for stress testing and corner case exploration.
//-----------------------------------------------------------------------------

class apb_rand_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_rand_seq)

  //-------------------------------------------------------------------------
  // Configurable Parameters
  //-------------------------------------------------------------------------
  int num_transactions = 10;    // Number of random transactions to generate

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name = "apb_rand_seq");
    super.new(name);
  endfunction: new

  //-------------------------------------------------------------------------
  // Body Task
  // Main sequence execution - generates random read/write transactions
  //-------------------------------------------------------------------------
  virtual task body();
    `uvm_info("RAND_SEQ", $sformatf("Starting %0d random transactions", num_transactions), UVM_LOW)

    repeat (num_transactions) begin
      // Create and start sequence item with full randomization
      // The constraints in apb_seq_item will ensure valid addresses
      `uvm_do(req)

      `uvm_info("RAND_SEQ", $sformatf("Random Trans: %s Addr=0x%0h Data=0x%0h",
                                       req.pwrite ? "WRITE" : "READ",
                                       req.paddr, 
                                       req.pwrite ? req.pwdata : req.prdata), UVM_MEDIUM)
    end

    `uvm_info("RAND_SEQ", "Random sequence completed", UVM_LOW)
  endtask: body

endclass: apb_rand_seq
