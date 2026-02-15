//-----------------------------------------------------------------------------
// File: apb_monitor.sv
// Description: APB Monitor Component
//              Passively observes APB bus transactions and broadcasts them
//              to analysis components (scoreboard, coverage).
//-----------------------------------------------------------------------------

class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  //-------------------------------------------------------------------------
  // Virtual Interface Handle
  //-------------------------------------------------------------------------
  virtual apb_if vif;

  //-------------------------------------------------------------------------
  // Analysis Port
  // Broadcasts captured transactions to subscribers (scoreboard, coverage)
  //-------------------------------------------------------------------------
  uvm_analysis_port #(apb_seq_item) item_collected_port;

  // Temporary handle for captured transaction
  apb_seq_item trans_collected;

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction: new

  //-------------------------------------------------------------------------
  // Build Phase
  // Get virtual interface from config_db
  //-------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not found in APB Monitor")
  endfunction: build_phase

  //-------------------------------------------------------------------------
  // Run Phase
  // Continuously monitors bus for completed transactions
  //-------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    `uvm_info("MON", "Monitor run_phase started", UVM_LOW)

    forever begin
      @(posedge vif.pclk);

      // Detect completed transaction: PSEL=1, PENABLE=1, PREADY=1
      if (vif.psel && vif.penable && vif.pready) begin
        `uvm_info("MON", "Transaction Captured!", UVM_HIGH)

        // Create new transaction object
        trans_collected = apb_seq_item::type_id::create("trans_collected");

        // Capture common fields
        trans_collected.paddr  = vif.paddr;
        trans_collected.pwrite = vif.pwrite;

        // Capture data based on transaction type
        if (vif.pwrite) begin
          trans_collected.pwdata = vif.pwdata;  // Write: capture write data
        end else begin
          trans_collected.prdata = vif.prdata;  // Read: capture read data
        end

        // Broadcast transaction to all subscribers
        item_collected_port.write(trans_collected);
      end
    end
  endtask: run_phase

endclass: apb_monitor