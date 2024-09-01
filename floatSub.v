`timescale 1 ns / 1 ps

module floatSub(floatA, floatB, difference);
	
	input [15:0] floatA, floatB;
	output reg [15:0] difference;

	reg sign;
	reg signed [5:0] exponent;
	reg [9:0] mantissa;
	reg [4:0] exponentA, exponentB;
	reg [10:0] fractionA, fractionB, fraction;
	reg [7:0] shiftAmount;
	reg borrow;

	always @ (floatA or floatB) begin
		exponentA = floatA[14:10];
		exponentB = floatB[14:10];
		fractionA = {1'b1, floatA[9:0]};
		fractionB = {1'b1, floatB[9:0]}; 
	
		exponent = exponentA;

		if (floatA == 0) begin		// special case (floatA = 0)
			difference = -floatB;
		end else if (floatB == 0) begin	// special case (floatB = 0)
			difference = floatA;
		end else if (floatA[14:0] == floatB[14:0] && floatA[15] ^ floatB[15] == 1'b1) begin
			difference = 0;
		end else begin
			if (exponentB > exponentA) begin
				shiftAmount = exponentB - exponentA;
				fractionA = fractionA >> shiftAmount;
				exponent = exponentB;
			end else if (exponentA > exponentB) begin 
				shiftAmount = exponentA - exponentB;
				fractionB = fractionB >> shiftAmount;
				exponent = exponentA;
			end

			if (floatA[15] == floatB[15]) begin	// same sign
				if (fractionA >= fractionB) begin
					{borrow, fraction} = fractionA - fractionB;
				end else begin
					{borrow, fraction} = fractionB - fractionA;
					sign = floatB[15]; // switch sign to floatB's sign
				end
				
				if (borrow == 1'b1) begin
					fraction = ~fraction + 1;
				end
				
				sign = floatA[15];
			end else begin	// different signs
				{borrow, fraction} = fractionA + fractionB;
				sign = floatA[15];

				if (borrow == 1'b1) begin
					{borrow, fraction} = {borrow, fraction} >> 1;
					exponent = exponent + 1;
				end

				if (fraction[10] == 0) begin
					if (fraction[9:0] != 10'b0) begin
						fraction = fraction << 1;
						exponent = exponent - 1;
					end
				end
			end
			
			mantissa = fraction[9:0];

			if (exponent[5] == 1'b1) begin // exponent is negative
				difference = 16'b0000000000000000;
			end else begin
				difference = {sign, exponent[4:0], mantissa};
			end
		end
	end

endmodule
