class apb_seq_item extends uvm_sequence_item;
    
  // Randomizable payload
  rand bit [31:0] paddr;
  rand bit [31:0] pwdata;
  rand bit        pwrite; 
  bit      [31:0] prdata; // Not random, comes from DUT
    
  // Standard UVM boilerplate
  `uvm_object_utils_begin(apb_seq_item)
  `uvm_field_int(paddr, UVM_ALL_ON)
  `uvm_field_int(pwdata, UVM_ALL_ON)
  `uvm_field_int(pwrite, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction

  // 1. Address alignment: APB is usually 32-bit aligned (addr % 4 == 0).
  // 2. Address range: Limit the address to a realistic range (e.g., 0 to 0xFFF).
    
  constraint addr_alignment_c {
    paddr % 4 ==0;
  }

  constraint addr_range_c {
    paddr inside {[0:1023]};
  }

endclass