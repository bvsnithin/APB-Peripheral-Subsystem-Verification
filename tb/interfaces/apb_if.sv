interface apb_if(input logic pclk, input logic presetn);

  logic [31:0] paddr;
  logic        psel;
  logic        penable;
  logic        pwrite;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;
  
  modport driver (
    input  pclk, presetn, prdata, pready,
    output paddr, psel, penable, pwrite, pwdata
  );

  modport monitor (
    input pclk, presetn, paddr, psel, penable, pwrite, pwdata, prdata, pready
  );

endinterface