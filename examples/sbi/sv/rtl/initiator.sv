// =====================================================================
// sbi_initiator.sv - SBI test sequencer (write 0xA5, read back)
// =====================================================================
// Drives an SBI write (CS+WR+wdata) then read (CS+RD) transaction.
// Clock/reset are separate ports — the SBI interface doesn't carry
// them (unlike AXI-style interfaces).
// =====================================================================
module sbi_initiator #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 8
) (
  input  logic              clk, rstn,     // clock and reset (active low)
  sbi_if.initiator          m,             // SBI initiator modport
  output logic [DATA_W-1:0] rd_data,       // read data from target
  output logic              rd_valid,      // strobe: rd_data valid
  output logic              done           // sequence complete
);
  typedef enum {IDLE, WR, RD, DONE_S} s_t;
  s_t s = IDLE;
  logic [DATA_W-1:0] rdata;

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      s <= IDLE; rd_valid <= 0; done <= 0; rdata <= '0;
      m.cs <= 0; m.addr <= '0; m.wr <= 0; m.rd <= 0; m.wdata <= '0;
    end else case (s)
      IDLE: begin
        m.cs <= 1; m.wr <= 1; m.wdata <= 32'hA5;  // write: CS+WR+data
        s <= WR;
      end
      WR: begin
        if (m.ready) begin
          m.cs <= 0; m.wr <= 0;                   // clear strobes
          s <= RD;
        end
      end
      RD: begin
        m.cs <= 1; m.rd <= 1;                      // read: CS+RD
        if (m.ready) begin
          rdata <= m.rdata; rd_valid <= 1;
          m.cs <= 0; m.rd <= 0;
          s <= DONE_S;
        end
      end
      DONE_S: begin rd_valid <= 0; done <= 1; end
    endcase
  end
  assign rd_data = rdata;
endmodule
