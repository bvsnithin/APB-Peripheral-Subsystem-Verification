//-----------------------------------------------------------------------------
// File: apb_wr_rd_test.sv
// Description: Test that performs multiple write-read operations to verify
//              APB RAM data integrity. Uses write-read sequence pairs.
//-----------------------------------------------------------------------------

class apb_wr_rd_test extends uvm_test;
  `uvm_component_utils(apb_wr_rd_test)

  //-------------------------------------------------------------------------
  // Component Handles
  //-------------------------------------------------------------------------
  apb_env env;                  // Environment instance
  apb_wr_rd_seq wr_rd_seq;      // Write-read sequence

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //-------------------------------------------------------------------------
  // Build Phase
  // Create the environment
  //-------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  //-------------------------------------------------------------------------
  // End of Elaboration Phase
  // Print the UVM topology for debug visibility
  //-------------------------------------------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction: end_of_elaboration_phase

  //-------------------------------------------------------------------------
  // Run Phase
  // Execute the test sequence
  //-------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    // Raise objection to keep simulation alive
    phase.raise_objection(this);

    `uvm_info("TEST", "=== APB Write-Read Test Starting ===", UVM_LOW)

    // Create the write-read sequence
    wr_rd_seq = apb_wr_rd_seq::type_id::create("wr_rd_seq");

    // Configure for 10 write-read pairs
    wr_rd_seq.num_pairs = 10;

    // Start the sequence on the agent's sequencer
    wr_rd_seq.start(env.agt.seqr);

    `uvm_info("TEST", "=== APB Write-Read Test Completed ===", UVM_LOW)

    // Small delay before ending
    #100;

    // Drop objection to end simulation
    phase.drop_objection(this);
  endtask: run_phase

endclass: apb_wr_rd_test
