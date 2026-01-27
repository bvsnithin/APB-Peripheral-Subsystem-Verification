module apb_ram (
  input  logic        pclk,
  input  logic        presetn,
  input  logic [31:0] paddr,
  input  logic        psel,
  input  logic        penable,
  input  logic        pwrite,
  input  logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic        pready
);

  // Memory Array: 1024 words x 32 bits
  logic [31:0] mem [1024];

  // APB is usually 2 cycles (Setup -> Access). 
  // We can assert PREADY immediately in the Access phase.
  assign pready = psel && penable; 

  // WRITE LOGIC
  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      // Optional: Reset memory or just leave random
    end else if (psel && penable && pwrite) begin
      mem[paddr] <= pwdata; // Using paddr as index directly for simplicity
    end
  end

  // READ LOGIC
  // If we are selected and NOT writing, drive the data.
  // Otherwise, drive 0 (or X, or previous value).
  always @(*) begin
    if (psel && !pwrite) begin
      prdata = mem[paddr];
    end else begin
      prdata = 32'h0;
    end
  end

endmodule