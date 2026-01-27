class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)

  apb_env env;
  apb_base_seq seq; // Handle for the sequence

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    // 1. Raise Objection (Keep the simulation alive)
    phase.raise_objection(this);
    
    // 2. Create and Start the Sequence
    seq = apb_base_seq::type_id::create("seq");
    `uvm_info("TEST", "Starting Sequence...", UVM_LOW)
    
    // Pass the sequencer handle (env.agt.seqr)
    seq.start(env.agt.seqr);
    
    `uvm_info("TEST", "Sequence Finished!", UVM_LOW)

    // 3. Drop Objection (End the simulation)
    phase.drop_objection(this);
  endtask

endclass