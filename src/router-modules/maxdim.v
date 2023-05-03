//This module takes inputs of the priorities of the buffers, the addresses of the messages, and the
//current dimension. It then outputs the buffer number of the highest priority message destined for that
//dimension.

module maxdim
(
  input [0:2] pri1, pri2, pri3, pri4, pri5, pri6, pri7,
  input [0:11] addr1, addr2, addr3, addr4, addr5, addr6, addr7,
  input [0:3] curDim,
  output reg toSend
);

//The first thing will be to zero out the priorities on any register not sending on this dim.
reg [0:2] pris [0:7];

always @(*) begin
  pris[0] = 3'b000;
  pris[1] = (addr1[curDim]) ? pri1 : 3'b000;
  pris[2] = (addr2[curDim]) ? pri2 : 3'b000;
  pris[3] = (addr3[curDim]) ? pri3 : 3'b000;
  pris[4] = (addr4[curDim]) ? pri4 : 3'b000;
  pris[5] = (addr5[curDim]) ? pri5 : 3'b000;
  pris[6] = (addr6[curDim]) ? pri6 : 3'b000;
  pris[7] = (addr7[curDim]) ? pri7 : 3'b000;
end

//Next, we can send everything through a tree structure of comparators to find the one with the biggest
//priority. We prefer left to break ties - the only ties should be if both priorities are 0, in which
//case we want to pick the dummy register 0.

reg [0:2] tree [0:5];

always @(*) begin
  //First, we assign the first layer of the tree based on the calculated pris
  tree[0] = (pris[0] < pris[1]) ? 3'b001 : 3'b000;
  tree[1] = (pris[2] < pris[3]) ? 3'b011 : 3'b010;
  tree[2] = (pris[4] < pris[5]) ? 3'b101 : 3'b100;
  tree[3] = (pris[6] < pris[7]) ? 3'b111 : 3'b110;

  //Now, the second layer is just a similar thing but comparing these
  tree[4] = (pris[tree[0]] < pris[tree[1]]) ? tree[1] : tree[0];
  tree[5] = (pris[tree[2]] < pris[tree[3]]) ? tree[3] : tree[2];

  //The final layer, and therefore the output, is just the same thing on these 2 entries.
  toSend = (pris[tree[4]] < pris[tree[5]]) ? tree[5] : tree[4];
end

endmodule
