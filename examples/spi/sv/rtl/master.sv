// =====================================================================
// spi_master.sv - SPI register write/read test sequencer
// =====================================================================
// Performs a complete SPI register transaction:
//   1. Assert CS, send 8 SCLK cycles with byte 0xA5 (MSB first)
//   2. De-assert CS
//   3. Re-assert CS, send 8 SCLK cycles, capture MISO on rising edges
//   4. De-assert CS, verify captured byte = 0xA5, assert done
// =====================================================================
module spi_master #(
  parameter logic [7:0] WR_DATA = 8'hA5   // test data to write/verify
) (
  input  logic       clk,              // system clock
  input  logic       rstn,             // active-low reset
  spi_if.master      m,                // SPI master modport
  output logic       done              // high when test completes
);

  // ---- FSM states ------------------------------------------------
  typedef enum {
    IDLE,                              // prepare write data
    WR_ASSERT,                         // assert CS, drive MSB
    WR_HI,                             // SCLK rising edge (slave captures)
    WR_LO,                             // SCLK falling edge, next bit
    WR_DEASSERT,                       // de-assert CS after byte sent
    RD_ASSERT,                         // re-assert CS for read
    RD_HI,                             // SCLK rising edge (slave drives MISO)
    RD_CAP,                            // capture MISO while SCLK high
    RD_LO,                             // SCLK falling edge, advance
    RD_DEASSERT,                       // de-assert CS, verify, done
    DONE_S
  } state_t;
  state_t state = IDLE;

  logic [3:0] bit_idx;                 // 0..7
  logic [7:0] tx_shift;                // transmit shift register
  logic [7:0] rx_shift;                // receive shift register

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state    <= IDLE;
      m.cs     <= 1;                   // CS inactive (high)
      m.sclk   <= 0;                   // SCLK idle low (SPI mode 0)
      m.mosi   <= 0;
      done     <= 0;
      bit_idx  <= 0;
    end else case (state)

      // -----------------------------------------------------------
      //  WRITE PHASE: send WR_DATA to the slave
      // -----------------------------------------------------------

      // IDLE: load write data ------------------------------------
      IDLE: begin
        tx_shift <= WR_DATA;
        bit_idx  <= 0;
        state    <= WR_ASSERT;
      end

      // WR_ASSERT: assert CS, drive first MOSI bit (MSB first) ---
      WR_ASSERT: begin
        m.cs     <= 0;                  // select slave
        m.mosi   <= tx_shift[7];        // drive MSB
        state    <= WR_HI;
      end

      // WR_HI: raise SCLK (slave captures MOSI on rising edge) ---
      WR_HI: begin
        m.sclk   <= 1;
        state    <= WR_LO;
      end

      // WR_LO: lower SCLK, shift out next bit --------------------
      WR_LO: begin
        m.sclk   <= 0;
        tx_shift <= {tx_shift[6:0], 1'b0};  // shift left
        if (bit_idx == 7) begin
          // All 8 bits sent
          state <= WR_DEASSERT;
        end else begin
          m.mosi   <= tx_shift[6];       // next MSB
          bit_idx  <= bit_idx + 1;
          state    <= WR_HI;
        end
      end

      // WR_DEASSERT: end write transaction -----------------------
      WR_DEASSERT: begin
        m.cs     <= 1;                   // de-select slave
        m.sclk   <= 0;
        m.mosi   <= 0;
        bit_idx  <= 0;
        state    <= RD_ASSERT;
      end

      // -----------------------------------------------------------
      //  READ PHASE: receive the echo from the slave
      // -----------------------------------------------------------

      // RD_ASSERT: re-assert CS for read transaction -------------
      RD_ASSERT: begin
        m.cs     <= 0;                   // select slave
        bit_idx  <= 0;
        rx_shift <= 0;
        state    <= RD_HI;
      end

      // RD_HI: raise SCLK (slave drives MISO) --------------------
      RD_HI: begin
        m.sclk   <= 1;
        state    <= RD_CAP;
      end

      // RD_CAP: capture MISO while SCLK is high -----------------
      // Dedicated cycle avoids race with slave's MISO drive.
      RD_CAP: begin
        rx_shift <= {rx_shift[6:0], m.miso};
        state    <= RD_LO;
      end

      // RD_LO: lower SCLK, advance to next bit ------------------
      RD_LO: begin
        m.sclk   <= 0;
        if (bit_idx == 7) begin
          state <= RD_DEASSERT;
        end else begin
          bit_idx <= bit_idx + 1;
          state   <= RD_HI;
        end
      end

      // RD_DEASSERT: end read, verify data -----------------------
      RD_DEASSERT: begin
        m.cs <= 1;                       // de-select slave
        // Verify: did we read back what we wrote?
        done <= (rx_shift == WR_DATA);
        state <= DONE_S;
      end

      // DONE_S: hold ---------------------------------------------
      DONE_S: begin
        // done stays high
      end

    endcase
  end

endmodule
