// =====================================================================
// apb_master.sv - APB test sequencer (write 0xA5, read back, verify)
// =====================================================================
// Walks through the APB write then read handshake:
//   IDLE -> WR_SETUP -> WR_ACCESS -> RD_SETUP -> RD_ACCESS -> DONE
// The master drives the APB master modport; the slave responds.
// APB protocol: SETUP phase (PSEL=1, PENABLE=0) -> ACCESS (PSEL=1, PENABLE=1)
// =====================================================================
module apb_master #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32
) (
  input  logic              pclk,           // APB clock
  input  logic              prstn,          // APB reset (active low)
  apb_if.master             m,              // APB master modport (drives bus)
  output logic [DATA_W-1:0] rd_data,        // read data captured from slave
  output logic              rd_valid,       // strobe: rd_data valid this cycle
  output logic              done            // write+read sequence complete
);
  // ---- Sequencer FSM -------------------------------------------------
  // APB write: SETUP (PSEL, no PENABLE) -> ACCESS (PSEL + PENABLE) -> wait PREADY
  // APB read:  same two-phase handshake
  typedef enum {IDLE, WR_SETUP, WR_ACCESS, RD_SETUP, RD_ACCESS, DONE_S} s_t;
  s_t s = IDLE;

  always_ff @(posedge pclk or negedge prstn) begin
    if (!prstn) begin
      s         <= IDLE;
      m.psel    <= 0;
      m.penable <= 0;
      m.pwrite  <= 0;
      m.paddr   <= '0;
      m.pwdata  <= '0;
      m.pprot   <= 0;
      m.pstrb   <= '0;
      rd_valid  <= 0;
      done      <= 0;
    end else case (s)
      IDLE: begin
        // ---- Write: SETUP phase -----------------------------------
        // Drive address, data, and write strobe; PENABLE stays low
        m.psel    <= 1;
        m.paddr   <= '0;                   // target address 0
        m.pwdata  <= 32'hA5;               // known test pattern
        m.pwrite  <= 1;                    // write strobe
        s         <= WR_SETUP;
      end
      WR_SETUP: begin
        // ---- Write: ACCESS phase ----------------------------------
        // Assert PENABLE; slave responds with PREADY in this cycle
        m.penable <= 1;
        s         <= WR_ACCESS;
      end
      WR_ACCESS: begin
        // Wait for slave to assert PREADY, then de-assert all strobes
        if (m.pready) begin
          m.psel    <= 0;
          m.penable <= 0;
          m.pwrite  <= 0;
          s         <= RD_SETUP;
        end
      end
      RD_SETUP: begin
        // ---- Read: SETUP phase ------------------------------------
        // Drive address and read strobe; PENABLE stays low
        m.psel    <= 1;
        m.paddr   <= '0;                   // same address
        m.pwrite  <= 0;                    // read strobe
        s         <= RD_ACCESS;
      end
      RD_ACCESS: begin
        // ---- Read: ACCESS phase -----------------------------------
        // Assert PENABLE; capture PRDATA when PREADY arrives
        m.penable <= 1;
        if (m.pready) begin
          rd_data  <= m.prdata;            // capture read data
          rd_valid <= 1;                   // strobe for one cycle
          m.psel   <= 0;
          m.penable <= 0;
          s        <= DONE_S;
        end
      end
      DONE_S: begin
        rd_valid <= 0;                     // single-cycle strobe
        done     <= 1;                     // signal completion
      end
    endcase
  end
endmodule

