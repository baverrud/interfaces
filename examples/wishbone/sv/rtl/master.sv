// =====================================================================
// wishbone_master.sv - Wishbone test sequencer (write 0xA5, read back)
// =====================================================================
// Drives a Wishbone write cycle (STB+CYC+WE) then a read cycle (STB+CYC).
// Clock/reset are separate ports — the Wishbone interface doesn't
// carry them (only AXI-style interfaces embed clock/reset).
// =====================================================================
module wishbone_master #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32
) (
  input  logic              clk, rstn,     // clock and reset (active low)
  wishbone_if.master        m,             // Wishbone master modport
  output logic [DATA_W-1:0] rd_data,       // read data from slave
  output logic              rd_valid,      // strobe: rd_data valid
  output logic              done           // sequence complete
);
  // ---- Sequencer FSM: write then read --------------------------------
  typedef enum {IDLE, WR, RD, DONE_S} s_t;
  s_t s = IDLE;

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      s <= IDLE; rd_valid <= 0; done <= 0;
      m.adr <= '0; m.dat_o <= '0; m.we <= 0;
      m.sel <= '0; m.stb <= 0; m.cyc <= 0;
    end else case (s)
      IDLE: begin
        // Write cycle: address, data, WE, STB, CYC all asserted
        m.adr   <= '0;                      // address 0
        m.dat_o <= 32'hA5;                  // test pattern
        m.we    <= 1;                       // write enable
        m.sel   <= '1;                      // all byte lanes
        m.stb   <= 1;                       // start transaction
        m.cyc   <= 1;                       // bus cycle
        s <= WR;
      end
      WR: begin
        if (m.ack) begin                    // slave acknowledges write
          m.stb <= 0; m.cyc <= 0; m.we <= 0;
          s <= RD;
        end
      end
      RD: begin
        // Read cycle: address, no WE, STB, CYC
        m.adr <= '0; m.we <= 0;
        m.stb <= 1; m.cyc <= 1;
        if (m.ack) begin                    // slave returns data
          rd_data  <= m.dat_i;
          rd_valid <= 1;
          m.stb <= 0; m.cyc <= 0;
          s <= DONE_S;
        end
      end
      DONE_S: begin rd_valid <= 0; done <= 1; end
    endcase
  end
endmodule
