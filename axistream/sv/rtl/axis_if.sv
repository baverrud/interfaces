// =====================================================================
// axis_if.sv - parameterized AXI-Stream interface with tx/rx modports
// =====================================================================
// One interface serves ANY payload type via the 'type' parameter T.
// 'tx' drives data/framing and samples back-pressure; 'rx' is the inverse.
// =====================================================================
interface axis_if #(parameter type T = logic);
    T     tdata;
    logic tlast;
    logic tvalid;
    logic tready;

    modport tx (output tdata, output tlast, output tvalid, input  tready);
    modport rx (input  tdata, input  tlast, input  tvalid, output tready);
endinterface
