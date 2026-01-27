
package apb_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // 1. DATA OBJECTS (Must be first!)
  `include "agents/apb_seq_item.sv"

  // 2. COMPONENTS (depend on seq_item)
  // `include "agents/apb_sequencer.sv"
  `include "agents/apb_driver.sv"
  `include "agents/apb_monitor.sv"
  `include "agents/apb_agent.sv"

  // 3. ENVIRONMENT (depends on agent)
  `include "env/apb_env.sv"

  // 4. SEQUENCES (depend on seq_item)
  `include "sequences/apb_base_seq.sv"

  // 5. TEST (depends on env and sequences)
  `include "tests/apb_test.sv"

endpackage