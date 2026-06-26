// =====================================================================
// qspi_master.sv - QSPI register write/read test sequencer
// =====================================================================
// Performs a QSPI register transaction (4-bit parallel):
//   1. Assert CS, drive nibble 0xA on io_o, toggle SCLK
//   2. Drive nibble 0x5 on io_o, toggle SCLK
//   3. De-assert CS
//   4. Re-assert CS, float io_o (io_oe=0), toggle SCLK×2,
//      capture io_i on dedicated capture cycles (avoids race)
//   5. De-assert CS, verify, assert done
// =====================================================================
module qspi_master #(
  parameter logic [7:0] WR_DATA = 8'hA5   // test data to write/verify
) (
  input  logic       clk,              // system clock
  input  logic       rstn,             // active-low reset
  qspi_if.master     m,                // QSPI master modport
  output logic       done              // high when test completes
);

  // ---- FSM states ------------------------------------------------
  typedef enum {
    IDLE,
    WR_ASSERT,                         // assert CS, drive first nibble
    WR_HI,                             // SCLK high (slave captures nibble)
    WR_LO,                             // SCLK low, next nibble
    WR_DEASSERT,                       // de-assert CS
    RD_ASSERT,                         // re-assert CS
    RD_HI,                             // SCLK high (slave drives io_i)
    RD_CAP,                            // capture io_i while SCLK high
    RD_LO,                             // SCLK low, advance
    RD_DEASSERT,                       // de-assert CS, verify, done
    DONE_S
  } state_t;
  state_t state = IDLE;

  logic [3:0] nibble_cnt;              // 0..1 (2 nibbles per byte)
  logic [7:0] rx_data;                 // received data

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state      <= IDLE;
      m.cs       <= 1;
      m.sclk     <= 0;
      m.io_o     <= 0;
      m.io_oe    <= 0;
      done       <= 0;
      nibble_cnt <= 0;
    end else case (state)

      // -----------------------------------------------------------
      //  WRITE PHASE: send two nibbles (0xA, 0x5)
      // -----------------------------------------------------------

      IDLE: begin
        nibble_cnt <= 0;
        state      <= WR_ASSERT;
      end

      WR_ASSERT: begin
        m.cs    <= 0;                   // select slave
        m.io_o  <= WR_DATA[7:4];        // drive first nibble (0xA)
        m.io_oe <= 4'hF;                // all pins output
        state   <= WR_HI;
      end

      WR_HI: begin
        m.sclk <= 1;                    // SCLK rising edge (slave captures)
        state  <= WR_LO;
      end

      WR_LO: begin
        m.sclk <= 0;                    // SCLK falling edge
        if (nibble_cnt == 0) begin
          m.io_o  <= WR_DATA[3:0];      // drive second nibble (0x5)
          nibble_cnt <= 1;
          state     <= WR_HI;
        end else begin
          state <= WR_DEASSERT;
        end
      end

      WR_DEASSERT: begin
        m.cs    <= 1;
        m.sclk  <= 0;
        m.io_o  <= 0;
        m.io_oe <= 0;
        state   <= RD_ASSERT;
      end

      // -----------------------------------------------------------
      //  READ PHASE: capture two nibbles from slave
      // -----------------------------------------------------------

      RD_ASSERT: begin
        m.cs     <= 0;                   // select slave
        m.io_oe  <= 0;                   // float (slave drives io_i)
        nibble_cnt <= 0;
        rx_data    <= 0;
        state      <= RD_HI;
      end

      RD_HI: begin
        m.sclk <= 1;                     // SCLK high (slave drives io_i)
        state  <= RD_CAP;
      end

      RD_CAP: begin
        // Dedicated capture cycle (avoids race with slave drive)
        if (nibble_cnt == 0) begin
          rx_data[7:4] <= m.io_i;        // capture first nibble
        end else begin
          rx_data[3:0] <= m.io_i;        // capture second nibble
        end
        state <= RD_LO;
      end

      RD_LO: begin
        m.sclk <= 0;                     // SCLK falling edge
        if (nibble_cnt == 0) begin
          nibble_cnt <= 1;
          state      <= RD_HI;
        end else begin
          state <= RD_DEASSERT;
        end
      end

      RD_DEASSERT: begin
        m.cs   <= 1;
        done   <= (rx_data == WR_DATA);
        state  <= DONE_S;
      end

      DONE_S: begin
        // hold
      end

    endcase
  end

endmodule
