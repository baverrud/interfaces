// =====================================================================
// jtag_controller.sv - JTAG controller (TAP sequencer)
// =====================================================================
// Generates TCK (clk/2) and drives TMS/TDI to navigate the TAP
// through a complete bypass-register test sequence:
//
//   Test-Logic-Reset (5 TCKs) → Run-Test/Idle → Select-DR-Scan →
//   Capture-DR → Shift-DR (shift 1 bit) → Exit1-DR → Update-DR →
//   Run-Test/Idle → DONE
//
// TMS changes on TCK falling edge; TDO sampled on TCK rising edge.
// =====================================================================
module jtag_controller (
  input  logic    clk,               // system clock
  input  logic    rstn,              // active-low reset
  jtag_if.tap    m,                  // TAP modport (tck/tms/tdi=out, tdo=in)
  output logic   done                // high when test completes
);

  // ---- TCK generation (clk/2) ----------------------------------
  logic tck_reg;
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) tck_reg <= 0;
    else       tck_reg <= ~tck_reg;
  end
  assign m.tck = tck_reg;

  // ---- TCK edge detection --------------------------------------
  logic tck_prev;
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) tck_prev <= 0;
    else       tck_prev <= tck_reg;
  end
  wire tck_rise =  tck_reg && !tck_prev;  // sample TDO
  wire tck_fall = !tck_reg &&  tck_prev;  // drive TMS, TDI

  // ---- sampled TDO value ---------------------------------------
  logic tdo_val;
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) tdo_val <= 0;
    else if (tck_rise) tdo_val <= m.tdo;
  end

  // ---- FSM: one state per TCK cycle ----------------------------
  typedef enum {
    RST1, RST2, RST3, RST4, RST5,    // Test-Logic-Reset ×5
    GO_RTI,                            // → Run-Test/Idle
    GO_SEL_DR,                         // → Select-DR-Scan
    GO_CAP_DR,                         // → Capture-DR
    GO_SHIFT_DR,                       // → Shift-DR
    SHIFT_BIT,                         // shift 1 bit (bypass)
    EXIT_SHIFT,                        // → Exit1-DR
    GO_UPD_DR,                         // → Update-DR
    GO_RTI2,                           // → Run-Test/Idle
    DONE_S
  } state_t;
  state_t state = RST1;

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state <= RST1;
      m.tms <= 0;
      m.tdi <= 0;
      done  <= 0;
    end else if (tck_fall) begin
      // Drive TMS/TDI on TCK falling edge, then advance state
      case (state)

        // Five TCK cycles with TMS=1 keeps TAP in Test-Logic-Reset
        RST1, RST2, RST3, RST4: begin
          m.tms  <= 1;
          m.tdi  <= 0;
          state  <= state_t'(state + 1);
        end
        RST5: begin
          m.tms  <= 1;
          m.tdi  <= 0;
          state  <= GO_RTI;
        end

        // TMS=0: Test-Logic-Reset → Run-Test/Idle
        GO_RTI: begin
          m.tms <= 0;
          state <= GO_SEL_DR;
        end

        // TMS=1: Run-Test/Idle → Select-DR-Scan
        GO_SEL_DR: begin
          m.tms <= 1;
          state <= GO_CAP_DR;
        end

        // TMS=0: Select-DR-Scan → Capture-DR
        GO_CAP_DR: begin
          m.tms <= 0;
          state <= GO_SHIFT_DR;
        end

        // TMS=0: Capture-DR → Shift-DR
        GO_SHIFT_DR: begin
          m.tms <= 0;
          state <= SHIFT_BIT;
        end

        // Shift-DR with TMS=0 (stay in Shift-DR), TDI=1
        // The bypass register captures TDI=1; TDO shows previous value
        SHIFT_BIT: begin
          m.tms  <= 1;                   // next: Exit1-DR
          m.tdi  <= 1;
          state  <= EXIT_SHIFT;
        end

        // TMS=1: Shift-DR → Exit1-DR
        EXIT_SHIFT: begin
          m.tms <= 1;
          state <= GO_UPD_DR;
        end

        // TMS=1: Exit1-DR → Update-DR
        GO_UPD_DR: begin
          m.tms <= 1;
          state <= GO_RTI2;
        end

        // TMS=0: Update-DR → Run-Test/Idle
        GO_RTI2: begin
          m.tms <= 0;
          state <= DONE_S;
        end

        DONE_S: begin
          done <= 1;
        end

      endcase
    end
  end

endmodule
