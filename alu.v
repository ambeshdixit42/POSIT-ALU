`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2023 12:02:57 PM
// Design Name: 
// Module Name: alu
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

module alu(
    input [7:0] positnum1,
    input [7:0] positnum2,
    input [2:0] select,
    output [7:0] positoutput
    );

 wire signed [15:0] binarynum1;
 wire signed [15:0] binarynum2;
 wire signed [15:0] binarysum;
 wire signed [15:0] binarydiff;
 wire signed [15:0] binarymult;
 reg signed [15:0] binaryout;
 //reg [7:0] posit;
// converting input posit numbers to binary

posit_binary conv(
    .posit1(positnum1),
    .posit2(positnum2),
    .binary1(binarynum1),
    .binary2(binarynum2) 
); 

floatAdd add(.floatA(binarynum1), .floatB(binarynum2), .sum(binarysum));
floatSub sub(.floatA(binarynum1), .floatB(binarynum2), .difference(binarydiff));
floatMult mul(.floatA(binarynum1), .floatB(binarynum2), .product(binarymult));

// performing arithmetic and logical operations

always @(*)
    begin
    case (select)
      3'b000 :  binaryout = binarysum;   
      3'b001 :  binaryout = binarydiff;
      3'b010 :  binaryout = binarymult;
      3'b011 :  binaryout = binarynum1 & binarynum2;
      3'b100 :  binaryout = binarynum1 | binarynum2;
      default: binaryout = 16'b0;
    endcase
    end

// converting binary output back to posit
binary_posit conversion(
    .binary(binaryout),
    .posit(positoutput)
);

endmodule
