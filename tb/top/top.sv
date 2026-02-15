//-----------------------------------------------------------------------------
// File: top.sv
// Description: Testbench Top Module
//              Instantiates DUT, interface, clock/reset generation,
//              and starts UVM test.
//-----------------------------------------------------------------------------

module top;

  // Import UVM and testbench package
  import uvm_pkg::*;
  import apb_pkg::*;

  //-------------------------------------------------------------------------
  // Clock and Reset Signals
  //-------------------------------------------------------------------------
  logic pclk;
  logic presetn;

  //-------------------------------------------------------------------------
  // Clock Generation: 100MHz (10ns period)
  //-------------------------------------------------------------------------
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;
  end

  //-------------------------------------------------------------------------
  // Reset Generation: Active low, released after 20ns
  //-------------------------------------------------------------------------
  initial begin
    presetn = 0;
    #20 presetn = 1;
  end

  //-------------------------------------------------------------------------
  // APB Interface Instance
  //-------------------------------------------------------------------------
  apb_if vif(pclk, presetn);

  //-------------------------------------------------------------------------
  // DUT Instance: APB RAM
  //-------------------------------------------------------------------------
  apb_ram dut (
    .pclk    (vif.pclk),
    .presetn (vif.presetn),
    .paddr   (vif.paddr),
    .psel    (vif.psel),
    .penable (vif.penable),
    .pwrite  (vif.pwrite),
    .pwdata  (vif.pwdata),
    .prdata  (vif.prdata),
    .pready  (vif.pready)
  );

  //-------------------------------------------------------------------------
  // UVM Test Start
  //-------------------------------------------------------------------------
  initial begin
    // Register virtual interface in config_db for UVM components
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);

    // Start the UVM test (test name can be overridden via +UVM_TESTNAME)
    run_test("apb_test");
  end

  //-------------------------------------------------------------------------
  // Optional Debug Monitors (can be disabled in production)
  //-------------------------------------------------------------------------

  // Monitor memory writes at address 0x10 (for debug)
  always @(dut.mem[16]) begin
    $display("[TOP DEBUG] Memory[0x10] updated to: 0x%h", dut.mem[16]);
  end

  // Monitor completed bus transactions (for debug)
  always @(posedge pclk) begin
    if (vif.psel && vif.penable && vif.pready)
      $display("[TOP DEBUG] Bus Trans: Addr=0x%h Write=%b Data=0x%h",
               vif.paddr, vif.pwrite, vif.pwrite ? vif.pwdata : vif.prdata);
  end

endmodule: top