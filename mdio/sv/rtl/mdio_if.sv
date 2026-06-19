`timescale 1ns/1ps
// =====================================================================
// mdio_if.sv - MDIO interface (IEEE 802.3 Clause 22)
// =====================================================================
// MDC: management data clock (driven by station management)
// MDIO: management data I/O (bidirectional, tri-state)
// =====================================================================
interface mdio_if (
    inout wire mdio
);
    logic mdc;                   // clock (station -> PHY)

    modport manager (
        output mdc,
        inout mdio
    );
    modport phy (
        input  mdc,
        inout mdio
    );
endinterface
