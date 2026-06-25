`timescale 1ns/1ps
// =====================================================================
// axi3_write_master.sv - write-only AXI3 master (sub-channel example)
// =====================================================================
// Demonstrates the sub-channel modport paradigm: this module uses only
// the write-side modports (aw_src, w_src, b_sink) and has zero read-
// channel logic or signals.
//
// Ports:
//   aw  — Write Address channel (axi3_if.aw_src) — Tx
//   w   — Write Data channel    (axi3_if.w_src)   — Tx
//   b   — Write Response channel (axi3_if.b_sink)  — Rx
// =====================================================================
module axi3_write_master #(
  parameter int DATA_W    = 32,
  parameter int ADDR_W    = 32,
  parameter int ID_W      = 4,
  parameter int BURST_LEN = 4
) (
  axi3_if.aw_src aw,
  axi3_if.w_src  w,
  axi3_if.b_sink b,
  input  logic              start,
  output logic              done
);
  localparam logic [3:0] AXLEN = 4'(BURST_LEN - 1);  // AXI3: 4-bit

  typedef enum logic [2:0] { S_IDLE, S_AW, S_WRITE, S_B, S_DONE } state_t;
  state_t state = S_IDLE;
  logic [3:0] beat_cnt;

  always_ff @(posedge aw.aclk or negedge aw.aresetn) begin
    if (!aw.aresetn) begin
      state <= S_IDLE; done <= 1'b0;
      aw.awvalid <= 1'b0; w.wvalid <= 1'b0; b.bready <= 1'b0;
    end else begin
      case (state)
        S_IDLE: if (start) begin state <= S_AW; beat_cnt <= '0; end
        S_AW: begin
          aw.awaddr <= 32'h0000_1000;
          if (!aw.awvalid) aw.awvalid <= 1'b1;
          if (aw.awvalid && aw.awready) begin state <= S_WRITE; beat_cnt <= '0; end
        end
        S_WRITE: begin
          if (!w.wvalid) begin
            w.wvalid <= 1'b1; w.wstrb <= '1; w.wlast <= (BURST_LEN == 1);
            w.wdata <= {8'(8'hB0 + beat_cnt), 24'(beat_cnt + 1)};
          end else if (w.wvalid && w.wready) begin
            if (beat_cnt == AXLEN) state <= S_B;
            else begin
              beat_cnt <= beat_cnt + 1'b1;
              w.wdata <= {8'(8'hB0 + beat_cnt + 1), 24'(beat_cnt + 2)};
              w.wlast <= (beat_cnt + 1 == AXLEN); end
          end
        end
        S_B: begin
          if (!b.bready) b.bready <= 1'b1;
          if (b.bvalid && b.bready) begin
            w.wvalid <= 1'b0; aw.awvalid <= 1'b0; state <= S_DONE; end
        end
        S_DONE: begin
          done <= 1'b1; aw.awvalid <= 1'b0; w.wvalid <= 1'b0; b.bready <= 1'b0; end
        default: state <= S_IDLE;
      endcase
    end
  end

  // ---- Default tie-offs (write address) ------------------------------
  assign aw.awid     = '0;
  assign aw.awlen    = AXLEN;       // AXI3: 4-bit
  assign aw.awsize   = 3'b010;
  assign aw.awburst  = 2'b01;
  assign aw.awlock   = 2'b0;        // AXI3: 2-bit
  assign aw.awcache  = 4'b0;
  assign aw.awprot   = 3'b0;
  assign aw.awqos    = 4'b0;
  assign aw.awuser   = '0;

  // ---- Default tie-offs (write data) --------------------------------
  assign w.wid     = '0;            // AXI3: write interleaving ID
  assign w.wuser   = '0;
endmodule
