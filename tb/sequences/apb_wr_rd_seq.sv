//-----------------------------------------------------------------------------
// File: apb_wr_rd_seq.sv
// Description: Sequence that performs write-then-read to same address.
//              This is a fundamental test pattern to verify data integrity.
//-----------------------------------------------------------------------------

class apb_wr_rd_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_wr_rd_seq)

  //-------------------------------------------------------------------------
  // Configurable Parameters
  //-------------------------------------------------------------------------
  rand bit [31:0] target_addr;  // Address for write-read pair
  rand bit [31:0] target_data;  // Data to write and verify
  int num_pairs = 1;            // Number of write-read pairs

  // Constraint: Keep address within valid RAM range and aligned
  constraint addr_c {
    target_addr inside {[0:1023]};
    target_addr % 4 == 0;
  }

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name = "apb_wr_rd_seq");
    super.new(name);
  endfunction: new

  //-------------------------------------------------------------------------
  // Body Task
  // For each pair: Write data to address, then read back and verify
  //-------------------------------------------------------------------------
  virtual task body();
    bit [31:0] saved_addr;
    bit [31:0] saved_data;

    `uvm_info("WR_RD_SEQ", $sformatf("Starting %0d write-read pair(s)", num_pairs), UVM_LOW)

    repeat (num_pairs) begin
      // Save values for the read-back
      saved_addr = target_addr;
      saved_data = target_data;

      // Step 1: Write Transaction
      `uvm_do_with(req, {
        pwrite == 1;
        paddr  == saved_addr;
        pwdata == saved_data;
      })
      `uvm_info("WR_RD_SEQ", $sformatf("WRITE: Addr=0x%0h Data=0x%0h", 
                                        saved_addr, saved_data), UVM_MEDIUM)

      // Step 2: Read Transaction (same address)
      `uvm_do_with(req, {
        pwrite == 0;
        paddr  == saved_addr;
      })
      `uvm_info("WR_RD_SEQ", $sformatf("READ:  Addr=0x%0h Data=0x%0h", 
                                        saved_addr, req.prdata), UVM_MEDIUM)

      // Re-randomize for next pair
      if (num_pairs > 1) begin
        if (!this.randomize()) begin
          `uvm_error("WR_RD_SEQ", "Randomization failed")
        end
      end
    end

    `uvm_info("WR_RD_SEQ", "Write-read sequence completed", UVM_LOW)
  endtask: body

endclass: apb_wr_rd_seq
