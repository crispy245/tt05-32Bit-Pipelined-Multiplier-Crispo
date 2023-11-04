module multi (
  input [3:0] a,          // 4-bit input A
  input [3:0] b,          // 4-bit input B
  input clk,
  input ena,
  input rst,
  output [7:0] product    // 8-bit output (4-bit x 4-bit product)
);

  wire [3:0] sum_vec[3:0];
  wire [3:0] carry_vec[4:0];

  // Pipeline registers
  reg [8:0] last_level_pipe;

  adder adder0(1'b0, a[0]&b[0], 1'b0, carry_vec[0][0],sum_vec[0][0]);
  adder adder1(1'b0, a[1]&b[0], 1'b0, carry_vec[0][1],sum_vec[0][1]);
  adder adder2(1'b0, a[2]&b[0], 1'b0, carry_vec[0][2],sum_vec[0][2]);
  adder adder3(1'b0, a[3]&b[0], 1'b0, carry_vec[0][3],sum_vec[0][3]);

  adder adder4(sum_vec[0][1], a[0]&b[1], carry_vec[0][0], carry_vec[1][0],sum_vec[1][0]);
  adder adder5(sum_vec[0][2], a[1]&b[1], carry_vec[0][1], carry_vec[1][1],sum_vec[1][1]);
  adder adder6(sum_vec[0][3], a[2]&b[1], carry_vec[0][2], carry_vec[1][2],sum_vec[1][2]);
  adder adder7(1'b0,          a[3]&b[1], carry_vec[0][3], carry_vec[1][3],sum_vec[1][3]);

  adder adder8 (sum_vec[1][1], a[0]&b[2], carry_vec[1][0], carry_vec[2][0],sum_vec[2][0]);
  adder adder9 (sum_vec[1][2], a[1]&b[2], carry_vec[1][1], carry_vec[2][1],sum_vec[2][1]);
  adder adder10(sum_vec[1][3], a[2]&b[2], carry_vec[1][2], carry_vec[2][2],sum_vec[2][2]);
  adder adder11(1'b0,          a[3]&b[2], carry_vec[1][3], carry_vec[2][3],sum_vec[2][3]);

  adder adder12(sum_vec[2][1], a[0]&b[3], carry_vec[2][0], carry_vec[3][0],sum_vec[3][0]);
  adder adder13(sum_vec[2][2], a[1]&b[3], carry_vec[2][1], carry_vec[3][1],sum_vec[3][1]);
  adder adder14(sum_vec[2][3], a[2]&b[3], carry_vec[2][2], carry_vec[3][2],sum_vec[3][2]);
  adder adder15(1'b0,          a[3]&b[3], carry_vec[2][3], carry_vec[3][3],sum_vec[3][3]);

  wire [3:0] sumToPipe;
  adder adder16(sum_vec[3][1], carry_vec[3][0], 1'b0,            carry_vec[4][0],sumToPipe[0]);
  adder adder17(sum_vec[3][2], carry_vec[3][1], carry_vec[4][1], carry_vec[4][1],sumToPipe[1]);
  adder adder18(sum_vec[3][3], carry_vec[3][2], carry_vec[4][2], carry_vec[4][2],sumToPipe[2]);
  adder adder19(1'b0,          carry_vec[3][3], carry_vec[4][3], carry_vec[4][3],sumToPipe[3]);


  always @(posedge clk) begin
    if(rst == 1'b0 || ena == 1'b0) begin
        last_level_pipe[7:0] <= 8'b0;
        product[7:0] <= 8'b0;
    end
    else begin
        product[7:0] <= {sumToPipe,sum_vec[3][0],sum_vec[2][0],sum_vec[1][0],sum_vec[0][0]};
    end
  end

endmodule
