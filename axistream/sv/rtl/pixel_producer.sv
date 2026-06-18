// =====================================================================
// pixel_producer.sv - builds RGB pixels, drives an axis_if.tx
// =====================================================================
// Assigning a pixel_t straight onto m.tdata IS the "pack" - no helper
// function needed, because pixel_t is a packed struct.
// =====================================================================
module pixel_producer #(
    parameter int LINE = 8        // pixels per line; tlast at end of line
) (
    input logic clk,
    input logic rst,
    axis_if.tx  m                 // m.tdata is pixel_t (from the instance)
);
    import stream_pkg::*;

    logic [7:0] cnt  = '0;        // pixel index in line
    logic [7:0] seed = '0;        // evolving colour
    pixel_t     px;

    always_comb begin
        px.r   = seed;
        px.g   = seed + 8'd1;
        px.b   = seed + 8'd2;
        px.sof = (cnt == 0);
    end

    assign m.tdata  = px;         // packed struct -> bus, automatically
    assign m.tvalid = 1'b1;
    assign m.tlast  = (cnt == LINE-1);

    always_ff @(posedge clk) begin
        if (rst) begin
            cnt  <= '0;
            seed <= '0;
        end else if (m.tready) begin   // advance only on an accepted beat
            seed <= seed + 8'd1;
            cnt  <= (cnt == LINE-1) ? 8'd0 : cnt + 8'd1;
        end
    end
endmodule
