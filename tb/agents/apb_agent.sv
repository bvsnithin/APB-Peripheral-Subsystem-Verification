//-----------------------------------------------------------------------------
// File: apb_agent.sv
// Description: APB Agent
//              Container for driver, monitor, and sequencer.
//              Supports both ACTIVE (with driver) and PASSIVE (monitor only) modes.
//-----------------------------------------------------------------------------

class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

  //-------------------------------------------------------------------------
  // Component Handles
  //-------------------------------------------------------------------------
  apb_driver                    drv;   // Driver (ACTIVE mode only)
  apb_monitor                   mon;   // Monitor (always present)
  uvm_sequencer #(apb_seq_item) seqr;  // Sequencer (ACTIVE mode only)

  // Virtual interface handle
  virtual apb_if vif;

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //-------------------------------------------------------------------------
  // Build Phase
  // Create sub-components based on agent mode (ACTIVE vs PASSIVE)
  //-------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Monitor is always created (needed in both ACTIVE and PASSIVE modes)
    mon = apb_monitor::type_id::create("mon", this);

    // Get virtual interface from config_db
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", "Virtual interface not found in APB Agent")
    end

    // Create driver and sequencer only in ACTIVE mode
    if (get_is_active() == UVM_ACTIVE) begin
      drv  = apb_driver::type_id::create("drv", this);
      seqr = uvm_sequencer#(apb_seq_item)::type_id::create("seqr", this);
    end
  endfunction: build_phase

  //-------------------------------------------------------------------------
  // Connect Phase
  // Wire up virtual interface and TLM ports
  //-------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect monitor to interface
    mon.vif = vif;

    // In ACTIVE mode, connect driver and sequencer
    if (get_is_active() == UVM_ACTIVE) begin
      drv.vif = vif;
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction: connect_phase

endclass: apb_agent