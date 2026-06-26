// =====================================================================
// jtag_tap.sv - JTAG TAP with bypass register
// =====================================================================
// Implements the IEEE 1149.1 TAP state machine (16 states) and a
// 1-bit bypass register.  The TAP state transitions on TCK rising
// edge based on TMS.  TDO is driven on TCK falling edge.
//
// Bypass register behaviour:
//   Capture-DR: loads 0
//   Shift-DR:   shifts TDI → bypass register → TDO
// =====================================================================
module jtag_tap (
  input  logic    clk,               // system clock (for reset sync)
  input  logic    rstn,              // active-low reset
  jtag_if.tap    s                   // TAP modport
);

  // ---- TCK edge detection --------------------------------------
  logic tck_prev;
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) tck_prev <= 0;
    else       tck_prev <= s.tck;
  end
  wire tck_rise =  s.tck && !tck_prev;  // sample TDI, advance state
  wire tck_fall = !s.tck &&  tck_prev;  // drive TDO

  // ---- JTAG TAP state machine (16 states, IEEE 1149.1) ---------
  typedef enum {
    TLR,       // Test-Logic-Reset
    RTI,       // Run-Test/Idle
    SEL_DR,    // Select-DR-Scan
    CAP_DR,    // Capture-DR
    SHIFT_DR,  // Shift-DR
    EXIT1_DR,  // Exit1-DR
    PAUSE_DR,  // Pause-DR
    EXIT2_DR,  // Exit2-DR
    UPD_DR,    // Update-DR
    SEL_IR,    // Select-IR-Scan
    CAP_IR,    // Capture-IR
    SHIFT_IR,  // Shift-IR
    EXIT1_IR,  // Exit1-IR
    PAUSE_IR,  // Pause-IR
    EXIT2_IR,  // Exit2-IR
    UPD_IR     // Update-IR
  } tap_state_t;
  tap_state_t tap_state = TLR;

  // ---- Bypass register (1-bit) ---------------------------------
  logic bypass_reg;

  // ---- TDO output (driven on TCK falling edge) -----------------
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      s.tdo <= 0;
    end else if (tck_fall) begin
      // Drive TDO based on current state
      case (tap_state)
        SHIFT_DR: s.tdo <= bypass_reg;  // bypass register to TDO
        SHIFT_IR: s.tdo <= bypass_reg;  // simplified: also bypass
        default:  s.tdo <= 0;
      endcase
    end
  end

  // ---- TAP state machine (transitions on TCK rising edge) ------
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      tap_state  <= TLR;
      bypass_reg <= 0;
    end else if (tck_rise) begin
      // State transition based on TMS
      case (tap_state)

        TLR:     tap_state <= s.tms ? TLR : RTI;
        RTI:     tap_state <= s.tms ? SEL_DR : RTI;
        SEL_DR:  tap_state <= s.tms ? SEL_IR : CAP_DR;
        CAP_DR:  begin
          bypass_reg <= 1'b0;            // capture: bypass = 0
          tap_state <= s.tms ? EXIT1_DR : SHIFT_DR;
        end
        SHIFT_DR: begin
          bypass_reg <= s.tdi;          // shift: TDI into bypass
          tap_state <= s.tms ? EXIT1_DR : SHIFT_DR;
        end
        EXIT1_DR: tap_state <= s.tms ? UPD_DR : PAUSE_DR;
        PAUSE_DR: tap_state <= s.tms ? EXIT2_DR : PAUSE_DR;
        EXIT2_DR: tap_state <= s.tms ? UPD_DR : SHIFT_DR;
        UPD_DR:   tap_state <= s.tms ? SEL_DR : RTI;
        SEL_IR:   tap_state <= s.tms ? TLR : CAP_IR;
        CAP_IR:   tap_state <= s.tms ? EXIT1_IR : SHIFT_IR;
        SHIFT_IR: tap_state <= s.tms ? EXIT1_IR : SHIFT_IR;
        EXIT1_IR: tap_state <= s.tms ? UPD_IR : PAUSE_IR;
        PAUSE_IR: tap_state <= s.tms ? EXIT2_IR : PAUSE_IR;
        EXIT2_IR: tap_state <= s.tms ? UPD_IR : SHIFT_IR;
        UPD_IR:   tap_state <= s.tms ? SEL_DR : RTI;

      endcase
    end
  end

endmodule
