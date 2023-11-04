`default_nettype none

module tt_um_4_bit_pipeline_multiplier(
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    assign uio_out[7:0] = uio_in[7:0];
    assign uio_oe[7:0] = {8'b0};
  
    wire [2:0] generic;
    assign generic = {ena};

    multi multi0(.a(ui_in[3:0]),
             .b(ui_in[7:4]),
             .clk(clk),
             .product(.uo_out));

    
    

    

endmodule
