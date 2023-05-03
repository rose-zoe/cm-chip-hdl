//This module takes a bit and the addresses from all buffers, and selection flags from the identifier. It
//then places the appropriate message bit on the appropriate cell line

module distributor
(
  input bit1, bit2, bit3, bit4, bit5, bit6, bit7,
  input addr1, addr2, addr3, addr4, addr5, addr6, addr7,
  input sel1, sel2, sel3, sel4, sel5, sel6, sel7,
  output reg [0:15] cellOut
);

//The first step will be to assume each of the 7 buffers is the ONLY buffer, and generate what the
//16bit output to the cells would be in that case.

reg [0:15] singleOuts [0:6];

always @(*) begin
  singleOuts[0] = (bit1 & sel1) << (15-addr1);
  singleOuts[1] = (bit2 & sel2) << (15-addr2);
  singleOuts[2] = (bit3 & sel3) << (15-addr3);
  singleOuts[3] = (bit4 & sel4) << (15-addr4);
  singleOuts[4] = (bit5 & sel5) << (15-addr5);
  singleOuts[5] = (bit6 & sel6) << (15-addr6);
  singleOuts[6] = (bit7 & sel7) << (15-addr7);
end

//Then, we just or all of these together and spit it out?

always @(*) begin
  cellOut = ((singleOuts[0]|singleOuts[1]) | (singleOuts[2]|singleOuts[3])) | ((singleOuts[4]|singleOuts[5]) | singleOuts[6]);
end

endmodule
