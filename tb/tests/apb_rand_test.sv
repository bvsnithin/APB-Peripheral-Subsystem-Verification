//-----------------------------------------------------------------------------
// File: apb_rand_test.sv
// Description: Test that runs random APB transactions for stress testing.
//              Helps find corner cases through randomization.
//-----------------------------------------------------------------------------

class apb_rand_test extends uvm_test;
  `uvm_component_utils(apb_rand_test)

  //-------------------------------------------------------------------------
  // Component Handles
  //-------------------------------------------------------------------------
  apb_env env;                  // Environment instance
  apb_rand_seq rand_seq;        // Random sequence

  //-------------------------------------------------------------------------
  // Constructor
  //-------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //-------------------------------------------------------------------------
  // Build Phase
  //-------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  //-------------------------------------------------------------------------
  // End of Elaboration Phase
  //-------------------------------------------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction: end_of_elaboration_phase

  //-------------------------------------------------------------------------
  // Run Phase
  //-------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("TEST", "=== APB Random Test Starting ===", UVM_LOW)

    // Create and configure random sequence
    rand_seq = apb_rand_seq::type_id::create("rand_seq");
    rand_seq.num_transactions = 20;  // Run 20 random transactions

    // Execute sequence
    rand_seq.start(env.agt.seqr);

    `uvm_info("TEST", "=== APB Random Test Completed ===", UVM_LOW)

    #100;
    phase.drop_objection(this);
  endtask: run_phase

endclass: apb_rand_test
