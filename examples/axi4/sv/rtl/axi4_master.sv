`timescale 1ns/1ps
// =====================================================================
// axi4_master.sv - AXI4 demo master (test sequencer FSM)
// =====================================================================
// Performs an incrementing burst write followed by a burst read to
// exercise the AXI4 bus.  Burst length is parameterized; write data
// uses a recognizable pattern based on the beat index.
//
// Outputs:
//   rd_data   — read data value for the current (or most recent) beat
//   rd_valid  — strobe, pulses for one cycle when rd_data is captured
//   done      — asserted when the full write+read sequence completes
//
// Uses axi4_if.master modport for a clean single-port interface.
// =====================================================================
module axi4_master #(
  parameter int DATA_W    = 32,
  parameter int ADDR_W    = 32,
  parameter int ID_W      = 4,
  parameter int BURST_LEN = 4       // number of beats per burst (1..256)
) (
  axi4_if.master m,
  output logic [DATA_W-1:0] rd_data,    // current read data beat
  output logic              rd_valid,   // strobe: rd_data captured this cycle
  output logic              done
);
  // ---- Internal constants --------------------------------------------
  // AXI4 awlen/arlen field = burst length - 1 (0 means 1 beat).
  localparam logic [7:0] AXLEN = 8'(BURST_LEN - 1);

  // ---- Test sequencer (AXI4 master FSM) ------------------------------
  // The FSM cycles through write-address, write-data, write-response,
  // read-address, and read-data phases.  Beat counting is handled by
  // a counter so the burst length is fully parameterized.
  typedef enum logic [2:0] {
    S_AW    = 3'd0,    // issue write address
    S_WRITE = 3'd1,    // send write data beats
    S_B     = 3'd2,    // wait for write response
    S_AR    = 3'd3,    // issue read address
    S_READ  = 3'd4,    // receive read data beats
    S_DONE  = 3'd5     // sequence complete
  } state_t;

  state_t state = S_AW;
  logic [7:0] beat_cnt;   // current beat index (0..BURST_LEN-1)

  // Write-address phase: drive address + defaults, wait for handshake.
  // Read-address phase: same pattern, different channel.
  // All FSM-driven handshake signals must be reset to 0, otherwise they
  // start as X and the conditions like "if (!m.awvalid)" never evaluate true.
  always_ff @(posedge m.aclk or negedge m.aresetn) begin
    if (!m.aresetn) begin
      state    <= S_AW;
      done     <= 1'b0;
      beat_cnt <= '0;
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
        //  BURST WRITE
        // ==========================================================

        S_AW: begin
          // Drive the write address; the sideband tie-offs below
          // define awlen, awsize, awburst, etc.
          m.awaddr  <= '0;
          if (!m.awvalid) m.awvalid <= 1'b1;
          if (m.awvalid && m.awready) begin
            state    <= S_WRITE;
            beat_cnt <= '0;
          end
        end

        S_WRITE: begin
          // Drive each write-data beat.  On the first beat through
          // this state, assert wvalid + set the first data value.
          // For subsequent beats (when wvalid is already high and
          // the slave accepts), advance to the next beat.
          if (!m.wvalid) begin
            m.wvalid <= 1'b1;
            m.wstrb  <= '1;         // all byte lanes enabled
            m.wlast  <= (BURST_LEN == 1);  // single-beat: last on first
            // Generate a recognizable data pattern: {0xA0+beat, beat+1}
            // This makes each beat unique and easy to verify.
            m.wdata  <= {8'(8'hA0 + beat_cnt), 24'(beat_cnt + 1)};
          end else if (m.wvalid && m.wready) begin
            // Advance to the next beat (or move to write-response)
            if (beat_cnt == AXLEN) begin
              // All beats sent — wait for B response
              state <= S_B;
            end else begin
              beat_cnt <= beat_cnt + 1'b1;
              m.wdata  <= {8'(8'hA0 + beat_cnt + 1), 24'(beat_cnt + 2)};
              m.wlast  <= (beat_cnt + 1 == AXLEN);
            end
          end
        end

        S_B: begin
          // Wait for the slave to assert bvalid, then acknowledge
          // with bready to complete the write transaction.
          if (!m.bready) m.bready <= 1'b1;
          if (m.bvalid && m.bready) begin
            // Deassert write-handshake signals so the slave
            // does not see a stale wvalid/awvalid after we
            // leave the write phase.  Without this, the
            // slave's W-before-AW path can capture a spurious
            // write data beat and overwrite mem[0].
            m.wvalid  <= 1'b0;
            m.awvalid <= 1'b0;
            state     <= S_AR;
            beat_cnt  <= '0;
          end
        end

        // ==========================================================
        //  BURST READ
        // ==========================================================

        S_AR: begin
          // Drive the read address; sideband tie-offs handle arlen,
          // arsize, arburst, etc.
          m.araddr  <= '0;
          if (!m.arvalid) m.arvalid <= 1'b1;
          if (m.arvalid && m.arready) begin
            state    <= S_READ;
            beat_cnt <= '0;
          end
        end

        S_READ: begin
          // Assert rready while reading.  The first cycle sets it
          // to 1; thereafter it stays 1 until we leave S_READ.
          if (!m.rready) m.rready <= 1'b1;
          if (m.rvalid && m.rready) begin
            rd_valid <= 1'b1;
            rd_data  <= m.rdata;
            if (beat_cnt == AXLEN) begin
              // rlast should also be asserted here — the
              // assertion in axi4_if checks this contract.
              state <= S_DONE;
            end else begin
              beat_cnt <= beat_cnt + 1'b1;
            end
          end else begin
            rd_valid <= 1'b0;
          end
        end

        S_DONE: begin
          done      <= 1'b1;
          rd_valid  <= 1'b0;
          m.arvalid <= 1'b0;  // prevent re-triggered AR after read
          m.rready  <= 1'b0;  // clean up read data sink
        end

        default: state <= S_DONE;
      endcase
    end
  end

  // ---- Default tie-offs (write address channel) ----------------------
  // These signals are constant for this demo; a more sophisticated master
  // would drive them from the FSM or configuration registers.
  assign m.awid     = '0;          // single-threaded — no transaction ID needed
  assign m.awlen    = AXLEN;       // burst length = BURST_LEN beats
  assign m.awsize   = 3'b010;      // 4 bytes per beat (2^2)
  assign m.awburst  = 2'b01;       // INCR (incrementing) burst type
  assign m.awlock   = 1'b0;        // normal access, no locking
  assign m.awcache  = 4'b0;        // non-bufferable, non-cacheable
  assign m.awprot   = 3'b0;        // secure, privileged, data access
  assign m.awqos    = 4'b0;        // no QoS
  assign m.awregion = 4'b0;        // single region
  assign m.awuser   = '0;          // no user sideband

  // ---- Default tie-offs (write data channel) -------------------------
  assign m.wuser    = '0;          // no user sideband per-beat

  // ---- Default tie-offs (read address channel) -----------------------
  assign m.arid     = '0;          // single-threaded — no transaction ID needed
  assign m.arlen    = AXLEN;       // burst length = BURST_LEN beats
  assign m.arsize   = 3'b010;      // 4 bytes per beat (2^2)
  assign m.arburst  = 2'b01;       // INCR (incrementing) burst type
  assign m.arlock   = 1'b0;        // normal access, no locking
  assign m.arcache  = 4'b0;        // non-bufferable, non-cacheable
  assign m.arprot   = 3'b0;        // secure, privileged, data access
  assign m.arqos    = 4'b0;        // no QoS
  assign m.arregion = 4'b0;        // single region
  assign m.aruser   = '0;          // no user sideband
endmodule
