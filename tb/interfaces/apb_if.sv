//-----------------------------------------------------------------------------
// File: apb_if.sv
// Description: APB Interface Definition
//              Defines all APB signals and modports for driver/monitor access.
//              Based on AMBA APB Protocol Specification.
//-----------------------------------------------------------------------------

interface apb_if(input logic pclk, input logic presetn);

  //-------------------------------------------------------------------------
  // APB Signal Declarations
  //-------------------------------------------------------------------------
  logic [31:0] paddr;     // Address bus
  logic        psel;      // Peripheral select
  logic        penable;   // Enable signal (indicates access phase)
  logic        pwrite;    // Write enable (1=write, 0=read)
  logic [31:0] pwdata;    // Write data bus
  logic [31:0] prdata;    // Read data bus (from slave)
  logic        pready;    // Ready signal (from slave)

  //-------------------------------------------------------------------------
  // Modport: driver
  // Used by APB Driver to drive transactions to DUT
  //-------------------------------------------------------------------------
  modport driver (
    input  pclk, presetn, prdata, pready,
    output paddr, psel, penable, pwrite, pwdata
  );

  //-------------------------------------------------------------------------
  // Modport: monitor
  // Used by APB Monitor to observe all bus signals (read-only)
  //-------------------------------------------------------------------------
  modport monitor (
    input pclk, presetn, paddr, psel, penable, pwrite, pwdata, prdata, pready
  );

endinterface: apb_if