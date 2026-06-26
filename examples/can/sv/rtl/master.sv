// =====================================================================
// can_master.sv - CAN controller test sequencer
// =====================================================================
// Simulates a CAN frame start on the TX line:
//   1. IDLE:      TX = recessive (1)
//   2. DOMINANT:  TX = dominant (0) for 4 cycles (simulating SOF + bits)
//   3. TOGGLE:    TX toggles for 4 cycles (simulating data/CRC bits)
//   4. DONE:      back to recessive, assert done
// The transceiver echoes TX -> RX; this master reads RX to verify.
// =====================================================================
module can_master (
  input  logic       clk,             // system clock
  input  logic       rstn,            // active-low reset
  can_if.controller  m,               // controller modport (tx=out, rx=in)
  output logic       done             // high when test completes
);

  // ---- FSM states ------------------------------------------------
  typedef enum {
    IDLE,                              // recessive (idle bus)
    DOMINANT,                          // dominant pulse (frame start)
    TOGGLE,                            // toggling data bits
    DONE_S                             // test complete
  } state_t;
  state_t state = IDLE;

  logic [3:0] cnt;                     // per-state cycle counter

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state <= IDLE;
      m.tx  <= 1;                      // bus idle = recessive
      done  <= 0;
    end else case (state)

      // IDLE: bus is recessive (1), prepare to start
      IDLE: begin
        m.tx  <= 1;
        cnt   <= 0;
        state <= DOMINANT;
      end

      // DOMINANT: drive bus dominant (0) for 4 cycles
      // In a real CAN frame this would be SOF + arbitration bits.
      DOMINANT: begin
        m.tx <= 0;
        if (cnt == 3) begin
          cnt   <= 0;
          state <= TOGGLE;
        end else begin
          cnt <= cnt + 1;
        end
      end

      // TOGGLE: alternate TX for 4 cycles (simulating data bits)
      TOGGLE: begin
        m.tx <= ~m.tx;                  // toggle each cycle
        if (cnt == 3) begin
          state <= DONE_S;
        end else begin
          cnt <= cnt + 1;
        end
      end

      // DONE: sequence complete
      DONE_S: begin
        m.tx <= 1;                      // back to recessive
        done <= 1;
      end

    endcase
  end

endmodule
