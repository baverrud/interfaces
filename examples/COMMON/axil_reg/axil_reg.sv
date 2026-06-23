`timescale 1ns/1ps
// =====================================================================
// axil_reg.sv - single-register AXI4-Lite slave (synthesizable)
// =====================================================================
// A minimal register: stores one DATA_W-wide value.  Responds to:
//   - Write: awvalid+awready -> wvalid+wready -> bvalid+bready
//   - Read:  arvalid+arready -> rvalid+rready
// =====================================================================
module axil_reg #(
    parameter int DATA_W = 32,
    parameter int ADDR_W = 32,
    parameter int USER_W = 0
) (
    axilite_if.slave s
);
    localparam int U_W   = (USER_W > 0) ? USER_W : 1;
    localparam int STRB_W = DATA_W / 8;

    logic [DATA_W-1:0] reg_val = '0;

    // Write response: accept address, data, then respond
    logic aw_done;
    always_ff @(posedge s.aclk or negedge s.aresetn) begin
        if (!s.aresetn) begin
            aw_done <= 1'b0;
        end else begin
            if (s.awvalid && s.awready && !aw_done)
                aw_done <= 1'b1;
            if (s.wvalid && s.wready && aw_done)
                aw_done <= 1'b0;
        end
    end
    assign s.awready = !aw_done;
    assign s.wready  = aw_done;

    // Register write
    always_ff @(posedge s.aclk) begin
        if (s.wvalid && s.wready) begin
            for (int i = 0; i < STRB_W; i++)
                if (s.wstrb[i]) reg_val[i*8 +: 8] <= s.wdata[i*8 +: 8];
        end
    end

    // Write response (valid on the cycle after wready)
    logic bvalid_r;
    always_ff @(posedge s.aclk or negedge s.aresetn) begin
        if (!s.aresetn)
            bvalid_r <= 1'b0;
        else if (s.wvalid && s.wready)
            bvalid_r <= 1'b1;
        else if (s.bready)
            bvalid_r <= 1'b0;
    end
    assign s.bvalid = bvalid_r;
    assign s.bresp  = 2'b00;

    // Read: return reg_val
    assign s.arready = 1'b1;

    logic rvalid_r;
    always_ff @(posedge s.aclk or negedge s.aresetn) begin
        if (!s.aresetn)
            rvalid_r <= 1'b0;
        else if (s.arvalid && s.arready)
            rvalid_r <= 1'b1;
        else if (s.rready)
            rvalid_r <= 1'b0;
    end
    assign s.rvalid = rvalid_r;
    assign s.rdata  = reg_val;
    assign s.rresp  = 2'b00;
endmodule
