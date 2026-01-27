class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  // Port to receive data from Monitor
  // Note: uvm_analysis_imp requires TWO parameters: the item type and THIS class type
  uvm_analysis_imp #(apb_seq_item, apb_scoreboard) item_collected_export;

  bit [31:0] ref_mem [int];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_export = new("item_collected_export", this);
  endfunction

  // This function is called AUTOMATICALLY when the Monitor calls .write()
  virtual function void write(apb_seq_item trans);
    
    if (trans.pwrite) begin
      `uvm_info("SCB", $sformatf("WRITE: Addr=0x%0h Data=0x%0h", trans.paddr, trans.pwdata), UVM_LOW)
      ref_mem[trans.paddr] = trans.pwdata;

    end else begin
      // The DUT read data. We must check if it matches our memory.
      
      // 1. Check if the address exists in our memory
      if (!ref_mem.exists(trans.paddr)) begin
        `uvm_warning("SCB", "Reading from uninitialized address, expecting 0")
        ref_mem[trans.paddr] = 0;
      end

      // 2. Compare Actual (trans.prdata) vs Expected (ref_mem[trans.paddr])
      if (trans.prdata !== ref_mem[trans.paddr]) begin
         // FAIL: Print Error
         `uvm_error("SCB", $sformatf("MISMATCH! Addr=0x%0h Exp=0x%0h Act=0x%0h", 
                                     trans.paddr, ref_mem[trans.paddr], trans.prdata))
      end else begin
         // PASS: Print Info
         `uvm_info("SCB", $sformatf("MATCH! Addr=0x%0h Data=0x%0h", trans.paddr, trans.prdata), UVM_LOW)
      end
    end
    
  endfunction

endclass