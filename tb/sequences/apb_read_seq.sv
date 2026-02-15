//-----------------------------------------------------------------------------
// File: apb_read_seq.sv
// Description: Sequence that generates APB read transactions.
//              Can be configured for specific address or randomized.
//-----------------------------------------------------------------------------

class apb_read_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_read_seq)

  //-------------------------------------------------------------------------
  // Configurable Parameters
  //-------------------------------------------------------------------------
  rand bit [31:0] read_addr;    // Target address for read
  int num_reads = 1;            // Number of read transactions to generate

  // Constraint: Keep address within valid RAM range (0-1023) and aligned
  constraint addr_c {
    read_addr inside {[0:1023]};
    read_addr % 4 == 0;
  }

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name = "apb_read_seq");
    super.new(name);
  endfunction: new

  //-------------------------------------------------------------------------
  // Body Task
  // Main sequence execution - generates read transactions
  //-------------------------------------------------------------------------
  virtual task body();
    `uvm_info("READ_SEQ", $sformatf("Starting %0d read transaction(s)", num_reads), UVM_LOW)

    repeat (num_reads) begin
      // Create and randomize the sequence item
      `uvm_do_with(req, {
        pwrite == 0;              // Force read operation
        paddr  == read_addr;      // Use configured address
      })

      `uvm_info("READ_SEQ", $sformatf("Read: Addr=0x%0h Data=0x%0h", 
                                       req.paddr, req.prdata), UVM_MEDIUM)

      // Re-randomize for next iteration if multiple reads
      if (num_reads > 1) begin
        if (!this.randomize()) begin
          `uvm_error("READ_SEQ", "Randomization failed")
        end
      end
    end

    `uvm_info("READ_SEQ", "Read sequence completed", UVM_LOW)
  endtask: body

endclass: apb_read_seq
