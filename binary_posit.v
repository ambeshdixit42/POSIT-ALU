`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2023 12:27:39 PM
// Design Name: 
// Module Name: binary_posit
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

module binary_posit(
  input signed [15:0] binary,
  output reg [7:0] posit
);


    reg sign;
    reg [4:0] regime;
    reg exponent;
    reg [3:0] fraction;
    reg [15:0] abs_decimal;

    // Take absolute value of decimal value
    always @* begin
        abs_decimal = (binary >= 0) ? binary : -binary;
    end
    
    reg [15:0] temp; 
    reg [4:0] regime1;
    // Calculate sign, regime, exponent, and fraction for posit representation
    always @* begin
        sign = (binary < 0) ? 1'b1 : 1'b0; // Determine the sign bit
        
        
        if (abs_decimal != 0) begin
            
            regime1 =2;
            // Calculate exponent
            exponent = (abs_decimal[(regime1 + 1)] == 1) ? 1 : 0;

            // Calculate fraction
            fraction = (abs_decimal >> (regime1 - 3)) & 4'b1111;
        end else begin
            // Zero value
            regime1 = 0;
            exponent = 0;
            fraction = 0;
        end
    end

    // Construct the 8-bit posit representation
    always @* begin
        posit[7] = sign;
        posit[6:5] = regime1;
        posit[4] = exponent;
        posit[3:0] = fraction;
    end

endmodule

