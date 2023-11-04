module adder(
    input wire a,
    input wire b,
    input wire cin,
    output wire cout,
    output wire s
);
    // Sum output
  assign s = a ^ b ^ cin;
  // Carry-out
  assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

