`timescale 1ns/1ps
// =====================================================================
// i2c_if.sv - I2C interface (2 inout wires, no triplets)
// =====================================================================
// Connects directly to the wrapper's inout I2C pins.  Internal modules
// access scl/sda via the modport or directly.
// =====================================================================
interface i2c_if (
  inout wire scl,
  inout wire sda
);
  // No internal logic.  The inout signals pass through to the
  // master/slave module via the interface instance.

  modport master (
    inout scl, sda
  );
  modport slave (
    inout scl, sda
  );
endinterface
