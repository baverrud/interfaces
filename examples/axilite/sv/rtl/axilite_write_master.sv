`timescale 1ns/1ps
// =====================================================================
// axilite_write_master.sv - write-only AXI4-Lite master
// =====================================================================
// Demonstrates the sub-channel modport paradigm: this module uses only
// the write-side modports (aw_src, w_src, b_sink) and has zero read-
// channel logic or signals.
//
// Ports:
//   aw    — Write Address channel (axilite_if.aw_src) — Tx
//   w     — Write Data channel    (axilite_if.w_src)   — Tx
//   b     — Write Response channel (axilite_if.b_sink)  — Rx
//   start — begin the write transaction
//   done  — asserted when write completes
// =====================================================================
module axilite_write_master #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32,
  parameter int USER_W = 0
) (
  axilite_if.aw_src aw,
  axilite_if.w_src  w,
  axilite_if.b_sink b,
  input  logic       start,
  output logic       done
);
  typedef enum logic [2:0] { S_IDLE, S_AW, S_WRITE, S_B, S_DONE } state_t;
  state_t state = S_IDLE;

  always_ff @(posedge aw.aclk or negedge aw.aresetn) begin
    if (!aw.aresetn) begin
      state <= S_IDLE; done <= 1'b0;
      aw.awvalid <= 1'b0; w.wvalid <= 1'b0; b.bready <= 1'b0;
    end else begin
      case (state)
        S_IDLE:  if (start) state <= S_AW;
        S_AW: begin
          aw.awaddr <= 32'h0000_1000;
          if (!aw.awvalid) aw.awvalid <= 1'b1;
          if (aw.awvalid && aw.awready) state <= S_WRITE;
        end
        S_WRITE: begin
          if (!w.wvalid) begin
            w.wvalid <= 1'b1; w.wstrb <= '1;
            w.wdata  <= DATA_W'(32'hB0B0B0B0);
          end else if (w.wvalid && w.wready) begin
            state <= S_B;
          end
        end
        S_B: begin
          if (!b.bready) b.bready <= 1'b1;
          if (b.bvalid && b.bready) begin
            w.wvalid <= 1'b0; aw.awvalid <= 1'b0; state <= S_DONE;
          end
        end
        S_DONE: begin
          done <= 1'b1;
          aw.awvalid <= 1'b0; w.wvalid <= 1'b0; b.bready <= 1'b0;
        end
        default: state <= S_IDLE;
      endcase
    end
  end

  // ---- Default tie-offs (write address) ------------------------------
  assign aw.awprot = 3'b0;
  assign aw.awuser = '0;
endmodule
