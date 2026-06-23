`timescale 1ns/1ps
// =====================================================================
// top.sv - AXI4-Lite demo: test driver -> axil_reg
// =====================================================================
// The test driver writes a value to the register, then reads it back.
// =====================================================================
module top #(
    parameter int DATA_W = 32,
    parameter int ADDR_W = 32
) (
    input  logic        aclk,
    input  logic        aresetn,
    output logic [DATA_W-1:0] reg_readout
);
    axilite_if #(.DATA_W(DATA_W), .ADDR_W(ADDR_W)) bus (.aclk, .aresetn);

    // Simple test sequencer (write one value, then read it back)
    logic [DATA_W-1:0] test_val = DATA_W'(32'hDEADBEEF);
    logic [1:0] state = 2'd0;

    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 2'd0;
        end else begin
            case (state)
                2'd0: begin                          // Write phase
                    if (bus.awvalid && bus.awready)   state <= 2'd1;
                    if (!bus.awvalid)                 bus.awvalid <= 1'b1;
                end
                2'd1: begin
                    bus.wstrb  <= '1;
                    bus.wdata  <= test_val;
                    if (!bus.wvalid)                  bus.wvalid <= 1'b1;
                    if (bus.wvalid && bus.wready)     state <= 2'd2;
                end
                2'd2: begin
                    if (bus.bvalid && bus.bready)     state <= 2'd3;
                    if (!bus.bready)                  bus.bready <= 1'b1;
                end
                2'd3: begin                          // Read phase
                    if (!bus.arvalid)                 bus.arvalid <= 1'b1;
                    if (bus.arvalid && bus.arready)   state <= 2'd4;
                end
                2'd4: begin
                    if (bus.rvalid && bus.rready)     state <= 2'd5;
                    if (!bus.rready)                  bus.rready <= 1'b1;
                end
                2'd5: ;  // done
            endcase
        end
    end

    // Defaults
    assign bus.awaddr = '0;
    assign bus.awprot = '0;

    assign reg_readout = bus.rdata;

    axil_reg #(.DATA_W(DATA_W), .ADDR_W(ADDR_W)) u_reg (.s(bus.slave));
endmodule
