`timescale 1ns/1ps
// =====================================================================
// axi3_master.sv - AXI3 demo master (test sequencer FSM)
// =====================================================================
// Performs an incrementing burst write followed by a burst read to
// exercise the AXI3 bus.  Burst length is parameterized; write data
// uses a recognizable pattern based on the beat index.
//
// AXI3 differs from AXI4: burst length is 4-bit (1-16 beats), lock is
// 2-bit, wid is present on the write data channel, and there is no
// awregion/arregion.
//
// Uses axi3_if.master modport for a clean single-port interface.
// =====================================================================
module axi3_master #(
  parameter int DATA_W    = 32,
  parameter int ADDR_W    = 32,
  parameter int ID_W      = 4,
  parameter int BURST_LEN = 4       // number of beats per burst (1..16 for AXI3)
) (
  axi3_if.master m,
  output logic [DATA_W-1:0] rd_data,
  output logic              rd_valid,
  output logic              done
);
  localparam logic [3:0] AXLEN = 4'(BURST_LEN - 1);  // AXI3: 4-bit len

  typedef enum logic [2:0] {
    S_AW, S_WRITE, S_B, S_AR, S_READ, S_DONE
  } state_t;

  state_t state = S_AW;
  logic [3:0] beat_cnt;

  always_ff @(posedge m.aclk or negedge m.aresetn) begin
    if (!m.aresetn) begin
      state <= S_AW; done <= 1'b0; beat_cnt <= '0;
      m.awvalid <= 1'b0; m.wvalid <= 1'b0; m.bready <= 1'b0;
      m.arvalid <= 1'b0; m.rready <= 1'b0;
      m.awaddr <= '0; m.araddr <= '0;
    end else begin
      case (state)
        S_AW: begin
          m.awaddr <= '0;
          if (!m.awvalid) m.awvalid <= 1'b1;
          if (m.awvalid && m.awready) begin state <= S_WRITE; beat_cnt <= '0; end
        end
        S_WRITE: begin
          if (!m.wvalid) begin
            m.wvalid <= 1'b1; m.wstrb <= '1; m.wlast <= (BURST_LEN == 1);
            m.wdata <= {8'(8'hA0 + beat_cnt), 24'(beat_cnt + 1)};
          end else if (m.wvalid && m.wready) begin
            if (beat_cnt == AXLEN) state <= S_B;
            else begin beat_cnt <= beat_cnt + 1'b1;
              m.wdata <= {8'(8'hA0 + beat_cnt + 1), 24'(beat_cnt + 2)};
              m.wlast <= (beat_cnt + 1 == AXLEN); end
          end
        end
        S_B: begin
          if (!m.bready) m.bready <= 1'b1;
          if (m.bvalid && m.bready) begin
            m.wvalid <= 1'b0; m.awvalid <= 1'b0;
            state <= S_AR; beat_cnt <= '0; end
        end
        S_AR: begin
          m.araddr <= '0;
          if (!m.arvalid) m.arvalid <= 1'b1;
          if (m.arvalid && m.arready) begin state <= S_READ; beat_cnt <= '0; end
        end
        S_READ: begin
          if (!m.rready) m.rready <= 1'b1;
          if (m.rvalid && m.rready) begin
            rd_valid <= 1'b1; rd_data <= m.rdata;
            if (beat_cnt == AXLEN) state <= S_DONE;
            else beat_cnt <= beat_cnt + 1'b1;
          end else rd_valid <= 1'b0;
        end
        S_DONE: begin
          done <= 1'b1; rd_valid <= 1'b0;
          m.arvalid <= 1'b0; m.rready <= 1'b0; end
        default: state <= S_DONE;
      endcase
    end
  end

  // ---- Default tie-offs (write address) ------------------------------
  assign m.awid     = '0;
  assign m.awlen    = AXLEN;       // AXI3: 4-bit
  assign m.awsize   = 3'b010;
  assign m.awburst  = 2'b01;
  assign m.awlock   = 2'b0;        // AXI3: 2-bit
  assign m.awcache  = 4'b0;
  assign m.awprot   = 3'b0;
  assign m.awqos    = 4'b0;
  assign m.awuser   = '0;

  // ---- Default tie-offs (write data) --------------------------------
  assign m.wid     = '0;           // AXI3: write interleaving ID
  assign m.wuser   = '0;

  // ---- Default tie-offs (read address) -------------------------------
  assign m.arid     = '0;
  assign m.arlen    = AXLEN;       // AXI3: 4-bit
  assign m.arsize   = 3'b010;
  assign m.arburst  = 2'b01;
  assign m.arlock   = 2'b0;        // AXI3: 2-bit
  assign m.arcache  = 4'b0;
  assign m.arprot   = 3'b0;
  assign m.arqos    = 4'b0;
  assign m.aruser   = '0;
endmodule
