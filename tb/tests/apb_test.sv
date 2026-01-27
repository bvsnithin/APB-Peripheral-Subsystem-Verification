class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)

  apb_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);

    
    // Tell the Sequencer (env.agt.seqr) to run 'apb_base_seq' during the run_phase.
    uvm_config_db#(uvm_object_wrapper)::set(this, 
                                            "env.agt.seqr.run_phase", 
                                            "default_sequence", 
                                            apb_base_seq::type_id::get());
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

endclass