`timescale 1ns/1ps
// =====================================================================
// axi4_read_master.sv - read-only AXI4 master (sub-channel example)
// =====================================================================
// Demonstrates the sub-channel modport paradigm: this module uses only
// the read-side modports (ar_src, r_sink) and has zero write-channel
// logic or signals.  A write master would use aw_src + w_src + b_sink.
//
// Ports:
//   ar      — Read Address channel (axi4_if.ar_src) — Tx
//   r       — Read Data channel    (axi4_if.r_sink)  — Rx
//   start   — pulse to begin a read burst
//   done    — asserted when all read beats have been received
//   rd_data — read data value for the current (or most recent) beat
//   rd_valid— strobe, pulses when rd_data is captured
//
// Each modport carries only its own channel's signals + clock/reset,
// so a module that only reads never sees AW, W, B, or their signals.
// =====================================================================
module axi4_read_master #(
  parameter int DATA_W    = 32,
  parameter int ADDR_W    = 32,
  parameter int ID_W      = 4,
  parameter int BURST_LEN = 4
) (
  axi4_if.ar_src ar,        // read address source  (Tx)
  axi4_if.r_sink r,         // read data sink       (Rx)
  input  logic              start,
  output logic              done,
  output logic [DATA_W-1:0] rd_data,
  output logic              rd_valid
);
  localparam logic [7:0] AXLEN = 8'(BURST_LEN - 1);

  // ---- FSM -----------------------------------------------------------
  typedef enum logic [1:0] {
    S_IDLE, S_AR, S_READ, S_DONE
  } state_t;

  state_t state = S_IDLE;
  logic [7:0] beat_cnt;

  always_ff @(posedge ar.aclk or negedge ar.aresetn) begin
    if (!ar.aresetn) begin
      state <= S_IDLE;
      done  <= 1'b0;
      ar.arvalid <= 1'b0;
      r.rready   <= 1'b0;
    end else begin
      case (state)
        S_IDLE: begin
          if (start) begin
            state    <= S_AR;
            beat_cnt <= '0;
          end
        end

        S_AR: begin
          ar.araddr  <= 32'h0000_1000;  // read target address
          if (!ar.arvalid) ar.arvalid <= 1'b1;
          if (ar.arvalid && ar.arready) begin
            state    <= S_READ;
            beat_cnt <= '0;
          end
        end

        S_READ: begin
          if (!r.rready) r.rready <= 1'b1;
          if (r.rvalid && r.rready) begin
            rd_valid <= 1'b1;
            rd_data  <= r.rdata;
            if (beat_cnt == AXLEN) begin
              state <= S_DONE;
            end else begin
              beat_cnt <= beat_cnt + 1'b1;
            end
          end else begin
            rd_valid <= 1'b0;
          end
        end

        S_DONE: begin
          done     <= 1'b1;
          rd_valid <= 1'b0;
          // Deassert handshake so read does not re-trigger
          ar.arvalid <= 1'b0;
          r.rready   <= 1'b0;
        end

        default: state <= S_IDLE;
      endcase
    end
  end

  // ---- Default tie-offs (read address) -------------------------------
  assign ar.arid     = '0;
  assign ar.arlen    = AXLEN;
  assign ar.arsize   = 3'b010;
  assign ar.arburst  = 2'b01;
  assign ar.arlock   = 1'b0;
  assign ar.arcache  = 4'b0;
  assign ar.arprot   = 3'b0;
  assign ar.arqos    = 4'b0;
  assign ar.arregion = 4'b0;
  assign ar.aruser   = '0;
endmodule
