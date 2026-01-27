module top;
  import uvm_pkg::*;
  import apb_pkg::*; 

  logic pclk;
  logic presetn;

  // 1. Clock and Reset Generation
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk; // 100MHz clock
  end

  initial begin
    presetn = 0;
    #20 presetn = 1; // Release reset after 20ns
  end

  // 2. Interface Instance
  apb_if vif(pclk, presetn);

  // 3. DUT Instance (APB RAM)
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

  // 4. Start UVM
  initial begin
    // Pass Interface to UVM
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);
    
    // Run the Test
    run_test("apb_test");
  end

endmodule