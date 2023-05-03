//This module takes addresses and priorities from the buffers, and selects which ones to send to cells.
//This is also fed back to the priority calculator to delete spent messages.

module identifier
(
  input addr1, addr2, addr3, addr4, addr5, addr6, addr7,
  input pri1, pri2, pri3, pri4, pri5, pri6, pri7,
  input shouldOr,
  output sel1, sel2, sel3, sel4, sel5, sel6, sel7
);

//First step is to deselect any messages not for this router
wire [0:6] notRouter;
assign notRouter[0] = (addr1[0:11] == 12'b000000000000);
assign notRouter[1] = (addr2[0:11] == 12'b000000000000);
assign notRouter[2] = (addr3[0:11] == 12'b000000000000);
assign notRouter[3] = (addr4[0:11] == 12'b000000000000);
assign notRouter[4] = (addr5[0:11] == 12'b000000000000);
assign notRouter[5] = (addr6[0:11] == 12'b000000000000);
assign notRouter[6] = (addr7[0:11] == 12'b000000000000);

//So then we need the highest priority thing for each of the other cells. This is probably another drag
//through style thing, with a 16 bitmap initially set to all 0s. Then iterate over the highest priority
//first, setting the bit on a hit. If the bit is already set, there's a higher pri message and the router
//is marked for deselection.

//First, this requires a lookup from priorities to buffers, the reverse of what we have now.
reg [0:2] priToBuf [0:6];
wire [0:3] addrs [0:6];
assign addrs[0] = addr1;
assign addrs[1] = addr2;
assign addrs[2] = addr3;
assign addrs[3] = addr4;
assign addrs[4] = addr5;
assign addrs[5] = addr6;
assign addrs[6] = addr7;

always @(*) begin
  priToBuf[0] = 3'b000;
  priToBuf[1] = 3'b000;
  priToBuf[2] = 3'b000;
  priToBuf[3] = 3'b000;
  priToBuf[4] = 3'b000;
  priToBuf[5] = 3'b000;
  priToBuf[6] = 3'b000;

  if (pri1 != 3'b000) priToBuf[pri1-1] = 3'b001;
  if (pri2 != 3'b000) priToBuf[pri2-1] = 3'b010;
  if (pri3 != 3'b000) priToBuf[pri3-1] = 3'b011;
  if (pri4 != 3'b000) priToBuf[pri4-1] = 3'b100;
  if (pri5 != 3'b000) priToBuf[pri5-1] = 3'b101;
  if (pri6 != 3'b000) priToBuf[pri6-1] = 3'b110;
  if (pri7 != 3'b000) priToBuf[pri7-1] = 3'b111;
end

//Now, the dragthrough
reg [0:16] bitmaps [0:6]
reg [0:6] notPri [0:6]

always @(*) begin
  bitmaps[0] = 16'h0000;
  notPri[0] = 7'b0000000;
  integer i;
  for (i = 0; i < 7; i = i + 1) begin
    //The corresponding notPri is set if the bitmap is set
  end
end


endmodule
