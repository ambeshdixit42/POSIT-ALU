`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2023 11:56:16 AM
// Design Name: 
// Module Name: posit_binary
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// posit number has 1 Sign bit, 2 regime bit, 1 exponent bit, 4 fraction bit

module posit_binary(
  input [7:0] posit1,
  input [7:0] posit2,
  output reg signed [15:0] binary1,
  output reg signed [15:0] binary2
);

  reg sign1, sign2;
  reg [1:0] regime1, regime2;
  reg exponent1, exponent2;
  reg [3:0] fraction1, fraction2;


always @* begin
  // Extracting individual components of posit1
   sign1 = posit1[7];
   regime1 = posit1[6:5];
   exponent1 = posit1[4];
   fraction1 = posit1[3:0];

  // Extracting individual components of posit2
   sign2 = posit2[7];
   regime2 = posit2[6:5];
   exponent2 = posit2[4];
   fraction2 = posit2[3:0];

end

  reg signed [16:0] decimal_value1;
  reg signed [16:0] decimal_value2;
  
  // Convert to decimal
 always @* begin
    // Convert posit1 to decimal
    decimal_value1 = (sign1 ? -1 : 1) * (2 ** (regime1 * 2 + exponent1)) * (1 + fraction1/16);

    // Convert posit2 to decimal
    decimal_value2 = (sign2 ? -1 : 1) * (2 ** (regime2 * 2 + exponent2)) * (1 + fraction2/16);
 
end

    reg signed [15:0] integer_part1, integer_part2;
    reg signed [15:0] fractional_part1, fractional_part2;

    // Separate the integer and fractional parts
    always @* begin
        integer_part1 = $signed(decimal_value1); // Extract integer part
        fractional_part1 = decimal_value1 - integer_part1; // Extract fractional part
        integer_part2 = $signed(decimal_value2); // Extract integer part
        fractional_part2 = decimal_value2 - integer_part2; // Extract fractional part
    end

    // Convert integer part to 5-bit binary representation
    always @* begin
        binary1[15] = integer_part1[15]; // Set the sign bit
        binary2[15] = integer_part2[15]; 
        
        // Convert the absolute value of the integer part to binary
        binary2[14:10] = (integer_part2[14:10] >= 0) ? integer_part2[14:10] : -integer_part2[14:10];
        binary1[14:10] = (integer_part1[14:10] >= 0) ? integer_part1[14:10] : -integer_part1[14:10];
    end

    // Convert fractional part to 10-bit binary representation
    always @* begin
        fractional_part1 = fractional_part1 * (1 << 10); // Scale fractional part to fit 10 bits
        fractional_part2 = fractional_part2 * (1 << 10);
        
        // Take absolute value of the scaled fractional part
        fractional_part1 = (fractional_part1 >= 0) ? fractional_part1 : -fractional_part1;
        fractional_part2 = (fractional_part2 >= 0) ? fractional_part2 : -fractional_part2;

        // Store 10-bit fractional part
        binary1[9:0] = fractional_part1[15:6];
        binary2[9:0] = fractional_part2[15:6];
    end

endmodule



