

class apb_driver extends uvm_driver #(apb_seq_item);
  `uvm_component_utils(apb_driver)

  virtual apb_if vif; // Handle to interface

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not found in APB Driver")
  endfunction

  task run_phase(uvm_phase phase);

    // Reset handling
    vif.psel    <= 0;
    vif.penable <= 0;
    
    wait(vif.presetn == 1); // Wait for reset release
    
    forever begin
      seq_item_port.get_next_item(req); // Get item from sequencer
      drive_transfer(req);              // Drive it
      seq_item_port.item_done();        // Tell sequencer we are done
    end
  endtask

  task drive_transfer(apb_seq_item item);

    // 1. SETUP PHASE: 
    // Drive paddr, pwdata, pwrite from item. Drive psel = 1.
    @ (posedge vif.pclk);
    vif.paddr  <= item.paddr;
    vif.pwrite <= item.pwrite;
    vif.psel   <= 1;
    if (item.pwrite) vif.pwdata <= item.pwdata;

    // 2. ACCESS PHASE: 
    // Wait one clock cycle, then set penable = 1.
    @(posedge vif.pclk)
    vif.penable <= 1;
    
    
    // 3. WAIT FOR READY:
    // Wait until vif.pready is high while clocking.
    while(!vif.pready) @(posedge vif.pclk);


    // 4. TEARDOWN:
    // Clear psel and penable.
    @ (posedge vif.pclk);
    vif.psel    <= 0;
    vif.penable <= 0;
    
  endtask

endclass