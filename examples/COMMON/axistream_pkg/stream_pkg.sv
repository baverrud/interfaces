`timescale 1ns/1ps
// =====================================================================
// stream_pkg.sv - structured stream payloads as PACKED STRUCTS
// =====================================================================
// A 'packed' struct IS its bit-vector, so serialization is automatic and
// the width is simply $bits(type_t).
// =====================================================================
package stream_pkg;

  // 25-bit RGB pixel with start-of-frame flag  ($bits(pixel_t) == 25)
  typedef struct packed {
    logic [7:0] r;
    logic [7:0] g;
    logic [7:0] b;
    logic       sof;
  } pixel_t;

  // 32-bit complex (IQ) sample                 ($bits(iq_t) == 32)
  typedef struct packed {
    logic signed [15:0] i;
    logic signed [15:0] q;
  } iq_t;

endpackage
