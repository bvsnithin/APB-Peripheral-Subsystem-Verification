//-----------------------------------------------------------------------------
// File: apb_write_seq.sv
// Description: Sequence that generates APB write transactions.
//              Can be configured for specific address/data or randomized.
//-----------------------------------------------------------------------------

class apb_write_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_write_seq)

  //-------------------------------------------------------------------------
  // Configurable Parameters
  // These can be set before starting the sequence to control behavior
  //-------------------------------------------------------------------------
  rand bit [31:0] write_addr;   // Target address for write
  rand bit [31:0] write_data;   // Data to write
  int num_writes = 1;           // Number of write transactions to generate

  // Constraint: Keep address within valid RAM range (0-1023) and aligned
  constraint addr_c {
    write_addr inside {[0:1023]};
    write_addr % 4 == 0;
  }

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name = "apb_write_seq");
    super.new(name);
  endfunction: new

  //-------------------------------------------------------------------------
  // Body Task
  // Main sequence execution - generates write transactions
  //-------------------------------------------------------------------------
  virtual task body();
    `uvm_info("WRITE_SEQ", $sformatf("Starting %0d write transaction(s)", num_writes), UVM_LOW)

    repeat (num_writes) begin
      // Create and randomize the sequence item
      `uvm_do_with(req, {
        pwrite == 1;              // Force write operation
        paddr  == write_addr;     // Use configured address
        pwdata == write_data;     // Use configured data
      })

      `uvm_info("WRITE_SEQ", $sformatf("Write: Addr=0x%0h Data=0x%0h", 
                                        req.paddr, req.pwdata), UVM_MEDIUM)

      // Re-randomize for next iteration if multiple writes
      if (num_writes > 1) begin
        if (!this.randomize()) begin
          `uvm_error("WRITE_SEQ", "Randomization failed")
        end
      end
    end

    `uvm_info("WRITE_SEQ", "Write sequence completed", UVM_LOW)
  endtask: body

endclass: apb_write_seq
