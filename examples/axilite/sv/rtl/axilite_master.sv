`timescale 1ns/1ps
// =====================================================================
// axilite_master.sv - AXI4-Lite demo master (test sequencer FSM)
// =====================================================================
// Performs a single-beat write followed by a single-beat read to
// exercise the AXI4-Lite bus.  AXI4-Lite has no burst — each
// transaction is exactly one beat.
//
// Outputs:
//   rd_data   — read data value for the current (or most recent) beat
//   rd_valid  — strobe, pulses for one cycle when rd_data is captured
//   done      — asserted when the full write+read sequence completes
//
// Uses axilite_if.master modport for a clean single-port interface.
// =====================================================================
module axilite_master #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32,
  parameter int USER_W = 0
) (
  axilite_if.master m,
  output logic [DATA_W-1:0] rd_data,    // current read data beat
  output logic              rd_valid,   // strobe: rd_data captured this cycle
  output logic              done
);
  // ---- Test sequencer (AXI4-Lite master FSM) ------------------------
  // AXI4-Lite is single-beat: write AW -> W -> B, then read AR -> R.
  typedef enum logic [2:0] {
    S_AW    = 3'd0,    // issue write address
    S_WRITE = 3'd1,    // send single write data beat
    S_B     = 3'd2,    // wait for write response
    S_AR    = 3'd3,    // issue read address
    S_READ  = 3'd4,    // receive single read data beat
    S_DONE  = 3'd5     // sequence complete
  } state_t;

  state_t state = S_AW;

  always_ff @(posedge m.aclk or negedge m.aresetn) begin
    if (!m.aresetn) begin
      state     <= S_AW;
      done      <= 1'b0;
      rd_valid  <= 1'b0;
      m.awvalid <= 1'b0;
      m.wvalid  <= 1'b0;
      m.bready  <= 1'b0;
      m.arvalid <= 1'b0;
      m.rready  <= 1'b0;
      m.awaddr  <= '0;
      m.araddr  <= '0;
    end else begin
      case (state)
        // ==========================================================
        //  SINGLE-BEAT WRITE
        // ==========================================================

        S_AW: begin
          // Drive the write address (address 0).
          m.awaddr  <= '0;
          if (!m.awvalid) m.awvalid <= 1'b1;
          if (m.awvalid && m.awready) begin
            state    <= S_WRITE;
          end
        end

        S_WRITE: begin
          // Drive the single write-data beat with pattern 0xA5A5A5A5.
          if (!m.wvalid) begin
            m.wvalid <= 1'b1;
            m.wstrb  <= '1;         // all byte lanes enabled
            m.wdata  <= DATA_W'(32'hA5A5A5A5);
          end else if (m.wvalid && m.wready) begin
            state <= S_B;
          end
        end

        S_B: begin
          // Wait for the slave to assert bvalid, then acknowledge
          // with bready to complete the write transaction.
          if (!m.bready) m.bready <= 1'b1;
          if (m.bvalid && m.bready) begin
            // Deassert write-handshake signals to avoid stale
            // assertions confusing the slave.
            m.wvalid  <= 1'b0;
            m.awvalid <= 1'b0;
            state     <= S_AR;
          end
        end

        // ==========================================================
        //  SINGLE-BEAT READ
        // ==========================================================

        S_AR: begin
          // Drive the read address (address 0).
          m.araddr  <= '0;
          if (!m.arvalid) m.arvalid <= 1'b1;
          if (m.arvalid && m.arready) begin
            state <= S_READ;
          end
        end

        S_READ: begin
          // Capture the single read-data beat.
          if (!m.rready) m.rready <= 1'b1;
          if (m.rvalid && m.rready) begin
            rd_valid <= 1'b1;
            rd_data  <= m.rdata;
            state    <= S_DONE;
          end else begin
            rd_valid <= 1'b0;
          end
        end

        S_DONE: begin
          // Sequence complete.
          done      <= 1'b1;
          m.arvalid <= 1'b0;
          m.rready  <= 1'b0;
        end

        default: state <= S_AW;
      endcase
    end
  end

  // ---- Default tie-offs (AXI4-Lite sidebands) ------------------------
  // awprot/arprot: normal secure data access
  assign m.awprot = 3'b0;
  assign m.arprot = 3'b0;
  assign m.awuser = '0;
  assign m.wuser  = '0;
  assign m.aruser = '0;
endmodule
