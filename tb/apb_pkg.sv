//-----------------------------------------------------------------------------
// File: apb_pkg.sv
// Description: APB Verification Package
//              Imports UVM and includes all testbench components in the
//              correct compilation order (dependencies first).
//-----------------------------------------------------------------------------

package apb_pkg;

  // Import UVM base library and macros
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //-------------------------------------------------------------------------
  // 1. DATA OBJECTS (Must be first - no dependencies)
  //-------------------------------------------------------------------------
  `include "agents/apb_seq_item.sv"

  //-------------------------------------------------------------------------
  // 2. AGENT COMPONENTS (depend on seq_item)
  //-------------------------------------------------------------------------
  `include "agents/apb_driver.sv"
  `include "agents/apb_monitor.sv"
  `include "agents/apb_agent.sv"

  //-------------------------------------------------------------------------
  // 3. ENVIRONMENT COMPONENTS (depend on agent)
  //-------------------------------------------------------------------------
  `include "env/apb_scoreboard.sv"
  `include "env/apb_coverage.sv"
  `include "env/apb_env.sv"

  //-------------------------------------------------------------------------
  // 4. SEQUENCES (depend on seq_item)
  //-------------------------------------------------------------------------
  `include "sequences/apb_base_seq.sv"
  `include "sequences/apb_write_seq.sv"
  `include "sequences/apb_read_seq.sv"
  `include "sequences/apb_rand_seq.sv"
  `include "sequences/apb_wr_rd_seq.sv"

  //-------------------------------------------------------------------------
  // 5. TESTS (depend on env and sequences)
  //-------------------------------------------------------------------------
  `include "tests/apb_test.sv"
  `include "tests/apb_wr_rd_test.sv"
  `include "tests/apb_rand_test.sv"

endpackage: apb_pkg