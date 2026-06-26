// =====================================================================
// apb_slave.sv - single-register APB slave
// =====================================================================
// Implements the APB slave handshake with a three-state FSM:
//   IDLE  -> PSEL asserted, PENABLE low (SETUP phase seen)
//   SETUP -> PENABLE asserted (ACCESS phase seen), assert PREADY
//   ACCESS -> de-assert PREADY, return to IDLE
// Supports one 32-bit register at address 0.
// =====================================================================
module apb_slave #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32
) (
  input  logic        pclk,               // APB clock
  input  logic        prstn,              // APB reset (active low)
  apb_if.slave        s                   // APB slave modport
);
  logic [DATA_W-1:0] reg0;                // single register at address 0

  // ---- APB slave state machine ---------------------------------------
  typedef enum {IDLE, SETUP, ACCESS} s_t;
  s_t st;

  always_ff @(posedge pclk or negedge prstn) begin
    if (!prstn) begin
      st        <= IDLE;
      reg0      <= '0;                    // clear register on reset
      s.pready  <= 0;                     // not ready
      s.pslverr <= 0;                     // no error
      s.prdata  <= '0;                    // clear read data bus
    end else case (st)
      IDLE: begin
        s.pready <= 0;
        // SETUP phase detected: PSEL high, PENABLE low
        if (s.psel && !s.penable) st <= SETUP;
      end
      SETUP: begin
        // ACCESS phase detected: PENABLE asserted
        if (s.penable) begin
          st       <= ACCESS;
          s.pready <= 1;                  // respond: data ready
          if (s.pwrite)
            reg0 <= s.pwdata;             // write: store data
          else
            s.prdata <= reg0;             // read:  return register
        end
      end
      ACCESS: begin
        s.pready <= 0;                    // de-assert ready
        st       <= IDLE;                 // back to idle
      end
    endcase
  end
endmodule

