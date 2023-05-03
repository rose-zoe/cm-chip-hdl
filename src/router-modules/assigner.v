//This module takes in the inputs from the cells (which on cycle 0 should be 1 if they
//want to send) and picks 4 of them to assign to the input buffers, sending them as output.

module assigner
(
  input [0:15] cellIns,
  output reg [0:4] res1, res2, res3, res4
);

//The general structure here will be to "drag through" a 3 bit counter, starting at 0, through an
//iteration over all 16 inputs.
reg [0:3] ress [0:3];

reg [0:2] counter [0:16];

always @(*) begin
  counter[0] = 3'b000;
  for (int i = 0; i < 4; i = i + 1) ress[i] = 5'b10000; //Indicates no message for this buf
  for (int i = 0; i < 16; i = i + 1) begin
    if (cellIns[i] & (counter[i] != 3'b100)) begin
      ress[counter[i]] = i;
      counter[i+1] = counter[i] + 1;
    end
    else counter[i+1] = counter[i];
  end
end

//That should be all, actual assignments into the registers is handled by somebody else.

endmodule
