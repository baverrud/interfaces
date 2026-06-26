// =====================================================================
// spi_slave.sv - SPI register slave with write/read tracking
// =====================================================================
// Implements a simple SPI register:
//   - Phase 0 (write): capture MOSI on SCLK rising edges into shift
//     register; on CS rising edge, store into shadow register
//   - Phase 1 (read):  drive shadow register onto MISO on SCLK
//     rising edges; on CS rising edge, toggle back to phase 0
// =====================================================================
module spi_slave (
  input  logic    clk,              // system clock
  input  logic    rstn,             // active-low reset
  spi_if.slave   s                  // SPI slave modport
);

  // ---- registers ------------------------------------------------
  logic [7:0] shadow = 0;            // internal register (the "memory")
  logic [7:0] shift  = 0;            // shift register
  logic       phase  = 0;            // 0 = write, 1 = read
  logic       cs_prev;               // previous CS for edge detect

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      shadow  <= 0;
      shift   <= 0;
      s.miso  <= 0;
      phase   <= 0;
      cs_prev <= 1;
    end else begin
      cs_prev <= s.cs;

      // ---- CS falling edge: transaction starting ---------------
      if (cs_prev && !s.cs) begin
        if (phase == 0) begin
          shift <= 0;                  // prepare to capture
        end else begin
          shift <= shadow;             // load data to echo
          // MISO is driven on SCLK low (next half-cycle)
        end
      end

      // ---- SCLK high while CS active: capture MOSI (write) -----
      if (!s.cs && s.sclk) begin
        if (phase == 0) begin
          // Write: capture MOSI on SCLK high (MSB first)
          shift <= {shift[6:0], s.mosi};
        end
      end

      // ---- SCLK low while CS active: drive MISO (read) ---------
      // Drive on the opposite half-cycle to avoid race with master
      // capture (master captures on SCLK high).
      if (!s.cs && !s.sclk) begin
        if (phase == 1) begin
          // Read: drive shadow register onto MISO
          s.miso <= shift[7];
          shift  <= {shift[6:0], 1'b0};
        end
      end

      // ---- CS rising edge: transaction ending ------------------
      if (!cs_prev && s.cs) begin
        if (phase == 0) begin
          shadow <= shift;             // store captured byte
          s.miso <= 0;                 // float MISO
        end
        phase <= ~phase;               // alternate write/read
      end

    end
  end

endmodule
