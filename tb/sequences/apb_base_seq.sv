class apb_base_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_base_seq)

  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction

  task body();
    // 1. Write Transaction
    `uvm_do_with(req, { 
      paddr == 32'h10; 
      pwrite == 1; 
      pwdata == 32'hCAFE_CAFE; 
    })

    // 2. Read Transaction
    `uvm_do_with(req, { 
      paddr == 32'h10; 
      pwrite == 0; 
    })
  endtask
endclass