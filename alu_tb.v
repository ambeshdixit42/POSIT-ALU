`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2023 11:51:28 AM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb;

  reg [7:0] positnum1 = 0;
  reg [7:0] positnum2 = 0;
  reg [2:0] select = 0;
  wire [7:0] positoutput =0;
  
  alu uut(
    .positnum1(positnum1),
    .positnum2(positnum2),
    .select(select),
    .positoutput(positoutput)
  );

  initial begin
    // Test case 1: Addition (select = 3'b000)
    positnum1 <= 8'b01011001; 
    positnum2 <= 8'b11001010; 
    select = 3'b000;
    #3; // Allow some time for the calculation
   
    select <= 3'b001;
    #3; // Allow some time for the calculation
    
    select <= 3'b010;
    #3; // Allow some time for the calculation
    
    select <= 3'b011;
    #3; // Allow some time for the calculation
    
    select <= 3'b100;
    #3; // Allow some time for the calculation
    
    $stop; // Stop simulation
  end

endmodule
