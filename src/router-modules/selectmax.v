//This module selects the highest priority buffer with a message for each cell, and then generates
//the appropriate bits to send to the cells.

module selectmax
(
  input bit1, bit2, bit3, bit4, bit5, bit6, bit7,
  input [0:15] addr1, addr2, addr3, addr4, addr5, addr6, addr7,
  input [0:2] pri1, pri2, pri3, pri4, pri5, pri6, pri7,
  output reg [0:15] cellOut,
  output reg [0:7] dashes
);

//First, we zero out the priorities

endmodule
