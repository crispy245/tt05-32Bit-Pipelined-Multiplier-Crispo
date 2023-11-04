module multi (
  input [3:0] a,          // 4-bit input A
  input [3:0] b,          // 4-bit input B
  input clk,
  input rst,
  input ena,
  output [7:0] product    // 8-bit output (4-bit x 4-bit product)
);

  wire [3:0] sum_vec[4:0];
  wire [3:0] carry_vec[4:0];

  // Pipeline registers
  reg [7:0] last_level;
  wire [7:0] to_last_level;

  reg [10:0] prev_level;

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
  

always @(posedge clk) begin
    if(rst == 0 || ena == 0) begin
        prev_level[10:0] <= 11'b0;
    end
    else begin
        // prev_level[0] <= sum_vec[0][0];
        // prev_level[1] <= sum_vec[1][0];
        // prev_level[2] <= sum_vec[2][0];
        // prev_level[3] <= sum_vec[3][0];
        // prev_level[4] <= carry_vec[3][0];
        // prev_level[5] <= sum_vec[3][1];
        // prev_level[6] <= carry_vec[3][1];
        // prev_level[7] <= sum_vec[3][2];
        // prev_level[8] <= carry_vec[3][2];
        // prev_level[9] <= sum_vec[3][3];
        // prev_level[10] <= carry_vec[3][3];
    prev_level[10:0] <= {carry_vec[3][3],sum_vec[3][3],carry_vec[3][2],
                        sum_vec[3][2],carry_vec[3][1],sum_vec[3][1],
                        carry_vec[3][0],sum_vec[3][0],sum_vec[2][0],
                        sum_vec[1][0],sum_vec[0][0]};
    end
  end



  adder adder16(prev_level[5], prev_level[4], 1'b0,            carry_vec[4][0],sum_vec[4][0]);
  adder adder17(prev_level[7], prev_level[6], carry_vec[4][0], carry_vec[4][1],sum_vec[4][1]);
  adder adder18(prev_level[9], prev_level[8], carry_vec[4][1], carry_vec[4][2],sum_vec[4][2]);
  adder adder19(1'b0,          prev_level[10], carry_vec[4][2], carry_vec[4][3],sum_vec[4][3]);

  assign product = last_level;

  always @(posedge clk) begin
    if(rst == 0 || ena == 0) begin
        last_level[7:0] <= 8'b0;
    end
    else begin
        last_level[7:0] <= {sum_vec[4][3],sum_vec[4][2],sum_vec[4][1],sum_vec[4][0],prev_level[3],prev_level[2],prev_level[1],prev_level[0]};
    end
  end

endmodule



// module multi (
//   input [3:0] a,          // 4-bit input A
//   input [3:0] b,          // 4-bit input B
//   input clk,
//   input rst,
//   input ena,
//   output [7:0] product    // 8-bit output (4-bit x 4-bit product)
// );

//   wire [3:0] sum_vec[4:0];
//   wire [3:0] carry_vec[4:0];

//   // Pipeline registers
//   reg [7:0] last_level;
//   wire [7:0] to_last_level;

//   adder adder0(1'b0, a[0]&b[0], 1'b0, carry_vec[0][0],sum_vec[0][0]);
//   adder adder1(1'b0, a[1]&b[0], 1'b0, carry_vec[0][1],sum_vec[0][1]);
//   adder adder2(1'b0, a[2]&b[0], 1'b0, carry_vec[0][2],sum_vec[0][2]);
//   adder adder3(1'b0, a[3]&b[0], 1'b0, carry_vec[0][3],sum_vec[0][3]);

//   adder adder4(sum_vec[0][1], a[0]&b[1], carry_vec[0][0], carry_vec[1][0],sum_vec[1][0]);
//   adder adder5(sum_vec[0][2], a[1]&b[1], carry_vec[0][1], carry_vec[1][1],sum_vec[1][1]);
//   adder adder6(sum_vec[0][3], a[2]&b[1], carry_vec[0][2], carry_vec[1][2],sum_vec[1][2]);
//   adder adder7(1'b0,          a[3]&b[1], carry_vec[0][3], carry_vec[1][3],sum_vec[1][3]);

//   adder adder8 (sum_vec[1][1], a[0]&b[2], carry_vec[1][0], carry_vec[2][0],sum_vec[2][0]);
//   adder adder9 (sum_vec[1][2], a[1]&b[2], carry_vec[1][1], carry_vec[2][1],sum_vec[2][1]);
//   adder adder10(sum_vec[1][3], a[2]&b[2], carry_vec[1][2], carry_vec[2][2],sum_vec[2][2]);
//   adder adder11(1'b0,          a[3]&b[2], carry_vec[1][3], carry_vec[2][3],sum_vec[2][3]);

//   adder adder12(sum_vec[2][1], a[0]&b[3], carry_vec[2][0], carry_vec[3][0],sum_vec[3][0]);
//   adder adder13(sum_vec[2][2], a[1]&b[3], carry_vec[2][1], carry_vec[3][1],sum_vec[3][1]);
//   adder adder14(sum_vec[2][3], a[2]&b[3], carry_vec[2][2], carry_vec[3][2],sum_vec[3][2]);
//   adder adder15(1'b0,          a[3]&b[3], carry_vec[2][3], carry_vec[3][3],sum_vec[3][3]);

//   adder adder16(sum_vec[3][1], carry_vec[3][0], 1'b0,            carry_vec[4][0],sum_vec[4][0]);
//   adder adder17(sum_vec[3][2], carry_vec[3][1], carry_vec[4][0], carry_vec[4][1],sum_vec[4][1]);
//   adder adder18(sum_vec[3][3], carry_vec[3][2], carry_vec[4][1], carry_vec[4][2],sum_vec[4][2]);
//   adder adder19(1'b0,          carry_vec[3][3], carry_vec[4][2], carry_vec[4][3],sum_vec[4][3]);

//   assign product = last_level;

//   always @(posedge clk) begin
//     last_level[7:0] <= {sum_vec[4][3],sum_vec[4][2],sum_vec[4][1],sum_vec[4][0],sum_vec[3][0],sum_vec[2][0],sum_vec[1][0],sum_vec[0][0]};
//   end

// endmodule