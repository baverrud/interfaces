// =====================================================================
// qspi_slave.sv - QSPI register slave (4-bit parallel)
// =====================================================================
// Phase 0 (write): capture io_o on SCLK high into shadow register
//   (2 SCLK cycles × 4 bits = 1 byte)
// Phase 1 (read):  drive shadow onto io_i combinatorially
// =====================================================================
module qspi_slave (
  input  logic    clk,
  input  logic    rstn,
  qspi_if.slave   s
);

  logic [7:0] shadow = 0;              // internal register
  logic       phase  = 0;              // 0=write, 1=read
  logic       cs_int;                  // scalar conversion of s.cs
  logic       cs_prev;                 // previous CS for edge detect
  logic [3:0] nibble_cnt;              // 0..1 (2 nibbles per byte)
  logic       read_nibble;             // which nibble to drive (0=high, 1=low)

  // ---- Combinational io_i drive during read phase ----------------
  // Always drive the appropriate nibble of shadow onto io_i when
  // CS is active and we're in read phase.  This avoids delta-cycle
  // races with the master's RD_CAP capture.
  assign s.io_i = (!cs_int && phase == 1) ?
                  (read_nibble == 0 ? shadow[7:4] : shadow[3:0]) :
                  4'h0;

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      shadow      <= 0;
      phase       <= 0;
      cs_prev     <= 1;
      cs_int      <= 1;
      nibble_cnt  <= 0;
      read_nibble <= 0;
    end else begin
      cs_int  <= s.cs;
      cs_prev <= cs_int;

      // ---- CS falling edge: transaction starting ---------------
      if (cs_prev && !cs_int) begin
        nibble_cnt  <= 0;
        read_nibble <= 0;
      end

      // ---- SCLK high while CS active: capture io_o (write) -----
      if (!cs_int && s.sclk && phase == 0) begin
        if (nibble_cnt == 0) begin
          shadow[7:4] <= s.io_o;
          nibble_cnt  <= 1;
        end else begin
          shadow[3:0] <= s.io_o;
        end
      end

      // ---- SCLK low while CS active: advance read nibble -------
      if (!cs_int && !s.sclk && phase == 1) begin
        read_nibble <= 1;
      end

      // ---- CS rising edge: transaction ending ------------------
      if (!cs_prev && cs_int) begin
        phase <= ~phase;
      end

    end
  end

endmodule
