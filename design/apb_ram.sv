

module apb_ram #(
  parameter ADDR_WIDTH = 10,
  parameter DATA_WIDTH = 32
)(
  input  logic                    pclk,
  input  logic                    presetn,
  input  logic [ADDR_WIDTH-1:0]   paddr,
  input  logic                    psel,
  input  logic                    penable,
  input  logic                    pwrite,
  input  logic [DATA_WIDTH-1:0]   pwdata,
  output logic [DATA_WIDTH-1:0]   prdata,
  output logic                    pready
);

  // Memory Array
  logic [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];

  // APB Protocol Logic
  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      prdata <= '0;
      pready <= 0;
    end else begin
      // Default Ready State
      pready <= 1'b0; 

      // APB Access Phase
      if (psel && penable) begin
        pready <= 1'b1; // Ready immediately for this simple RAM
        
        if (pwrite) begin
          // WRITE Operation
          mem[paddr] <= pwdata;
        end else begin
          // READ Operation
          prdata <= mem[paddr];
        end
      end
    end
  end

endmodule