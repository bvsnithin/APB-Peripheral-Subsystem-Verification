//-----------------------------------------------------------------------------
// File: apb_env.sv
// Description: APB Verification Environment
//              Contains the agent, scoreboard, and coverage collector.
//              Connects monitor output to scoreboard and coverage.
//-----------------------------------------------------------------------------

class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)

  //-------------------------------------------------------------------------
  // Component Handles
  //-------------------------------------------------------------------------
  apb_agent      agt;   // APB Agent (driver, monitor, sequencer)
  apb_scoreboard scb;   // Scoreboard for checking
  apb_coverage   cov;   // Functional coverage collector

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //-------------------------------------------------------------------------
  // Build Phase
  // Create all sub-components
  //-------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create Agent
    agt = apb_agent::type_id::create("agt", this);

    // Create Scoreboard
    scb = apb_scoreboard::type_id::create("scb", this);

    // Create Coverage Collector
    cov = apb_coverage::type_id::create("cov", this);
  endfunction: build_phase

  //-------------------------------------------------------------------------
  // Connect Phase
  // Wire up analysis ports from monitor to scoreboard and coverage
  //-------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect monitor's analysis port to scoreboard
    agt.mon.item_collected_port.connect(scb.item_collected_export);

    // Connect monitor's analysis port to coverage collector
    agt.mon.item_collected_port.connect(cov.analysis_export);
  endfunction: connect_phase

endclass: apb_env