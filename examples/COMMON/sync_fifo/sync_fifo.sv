`timescale 1ns/1ps
// =====================================================================
// sync_fifo.sv - generic, TYPE-PARAMETERIZED FWFT FIFO
// =====================================================================
// The 'type T' parameter lets one FIFO store ANY type natively - no bit
// concatenation at all (the synthesizer flattens the struct for you).
// =====================================================================
module sync_fifo #(
  parameter type T     = logic,
  parameter int  DEPTH = 16
) (
  input  logic clk,
  input  logic rst,
  // write side
  input  logic wr_en,
  input  T     din,
  output logic full,
  // read side (first-word fall-through: dout is the current head)
  input  logic rd_en,
  output T     dout,
  output logic empty
);
  localparam int AW = (DEPTH <= 1) ? 1 : $clog2(DEPTH);

  T              mem [DEPTH];
  logic [AW-1:0] wptr  = '0;
  logic [AW-1:0] rptr  = '0;
  logic [AW:0]   count = '0;

  assign full  = (count == DEPTH);
  assign empty = (count == 0);
  assign dout  = mem[rptr];          // first-word fall-through

  always_ff @(posedge clk) begin
    if (rst) begin
      wptr  <= '0;
      rptr  <= '0;
      count <= '0;
    end else begin
      if (wr_en && !full) begin
        mem[wptr] <= din;
        wptr <= (wptr == DEPTH-1) ? '0 : wptr + 1'b1;
      end
      if (rd_en && !empty) begin
        rptr <= (rptr == DEPTH-1) ? '0 : rptr + 1'b1;
      end
      case ({(wr_en && !full), (rd_en && !empty)})
        2'b10:   count <= count + 1'b1;
        2'b01:   count <= count - 1'b1;
        default: /* no change */ ;
      endcase
    end
  end
endmodule
