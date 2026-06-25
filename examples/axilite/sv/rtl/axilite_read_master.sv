`timescale 1ns/1ps
// =====================================================================
// axilite_read_master.sv - read-only AXI4-Lite master
// =====================================================================
// Demonstrates the sub-channel modport paradigm: this module uses only
// the read-side modports (ar_src, r_sink) and has zero write-channel
// logic or signals.
//
// Ports:
//   ar      — Read Address channel (axilite_if.ar_src) — Tx
//   r       — Read Data channel    (axilite_if.r_sink)  — Rx
//   start   — begin the read transaction
//   done    — asserted when read completes
// =====================================================================
module axilite_read_master #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32,
  parameter int USER_W = 0
) (
  axilite_if.ar_src ar,
  axilite_if.r_sink r,
  input  logic              start,
  output logic              done,
  output logic [DATA_W-1:0] rd_data,
  output logic              rd_valid
);
  typedef enum logic [1:0] { S_IDLE, S_AR, S_READ, S_DONE } state_t;
  state_t state = S_IDLE;

  always_ff @(posedge ar.aclk or negedge ar.aresetn) begin
    if (!ar.aresetn) begin
      state <= S_IDLE; done <= 1'b0;
      ar.arvalid <= 1'b0; r.rready <= 1'b0;
    end else begin
      case (state)
        S_IDLE: if (start) state <= S_AR;
        S_AR: begin
          ar.araddr <= 32'h0000_1000;
          if (!ar.arvalid) ar.arvalid <= 1'b1;
          if (ar.arvalid && ar.arready) state <= S_READ;
        end
        S_READ: begin
          if (!r.rready) r.rready <= 1'b1;
          if (r.rvalid && r.rready) begin
            rd_valid <= 1'b1; rd_data <= r.rdata;
            state <= S_DONE;
          end else begin
            rd_valid <= 1'b0;
          end
        end
        S_DONE: begin
          done <= 1'b1; rd_valid <= 1'b0;
          ar.arvalid <= 1'b0; r.rready <= 1'b0;
        end
        default: state <= S_IDLE;
      endcase
    end
  end

  // ---- Default tie-offs (read address) -------------------------------
  assign ar.arprot = 3'b0;
  assign ar.aruser = '0;
endmodule
