//-----------------------------------------------------------------------------
// File: apb_driver.sv
// Description: APB Driver Component
//              Receives sequence items from sequencer and drives them onto
//              the APB interface following the APB protocol timing.
//-----------------------------------------------------------------------------

class apb_driver extends uvm_driver #(apb_seq_item);
  `uvm_component_utils(apb_driver)

  //-------------------------------------------------------------------------
  // Virtual Interface Handle
  //-------------------------------------------------------------------------
  virtual apb_if vif;

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //-------------------------------------------------------------------------
  // Build Phase
  // Get virtual interface from config_db
  //-------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not found in APB Driver")
  endfunction: build_phase

  //-------------------------------------------------------------------------
  // Run Phase
  // Main driver loop - gets items from sequencer and drives them
  //-------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    // Initialize bus signals to idle state
    vif.psel    <= 0;
    vif.penable <= 0;

    // Wait for reset to be released before driving
    wait (vif.presetn == 1);

    // Main driver loop
    forever begin
      seq_item_port.get_next_item(req);  // Get next transaction from sequencer
      drive_transfer(req);                // Drive the transaction on bus
      seq_item_port.item_done();          // Signal completion to sequencer
    end
  endtask: run_phase

  //-------------------------------------------------------------------------
  // Drive Transfer Task
  // Implements APB protocol state machine:
  //   IDLE -> SETUP -> ACCESS -> IDLE
  //-------------------------------------------------------------------------
  task drive_transfer(apb_seq_item item);

    // SETUP PHASE: Assert PSEL, drive address and control signals
    @(posedge vif.pclk);
    vif.paddr  <= item.paddr;
    vif.pwrite <= item.pwrite;
    vif.psel   <= 1;
    if (item.pwrite) vif.pwdata <= item.pwdata;

    // ACCESS PHASE: Assert PENABLE
    @(posedge vif.pclk);
    vif.penable <= 1;

    // Wait for PREADY from slave (handles wait states)
    do begin
      @(posedge vif.pclk);
    end while (vif.pready == 0);

    // Return to IDLE: Deassert PSEL and PENABLE
    vif.psel    <= 0;
    vif.penable <= 0;

  endtask: drive_transfer

endclass: apb_driver