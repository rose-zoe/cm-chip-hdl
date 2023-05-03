//This module finds 4 empty buffers and spits them out.

module empties
(
  input [0:2] pri1, pri2, pri3, pri4, pri5, pri6, pri7,
  output reg [0:2] res1, res2, res3, res4
);

//First, we assign a byte based on whether that buffer is available
wire [0:6] bufFree;
assign bufFree[0] = !(pri1 == 3'b000);
assign bufFree[1] = !(pri2 == 3'b000);
assign bufFree[2] = !(pri3 == 3'b000);
assign bufFree[3] = !(pri4 == 3'b000);
assign bufFree[4] = !(pri5 == 3'b000);
assign bufFree[5] = !(pri6 == 3'b000);
assign bufFree[6] = !(pri7 == 3'b000);

//We build temporary registers to write into so we can sort at the end
reg [0:2] res1f, res2f, res3f, res4f;

//Then, we can pick res1 to be the rightmost bit with a 1
always @(*) begin
  (* parallel_case *) casex (bufFree)
    7'bxxxxxx1: res1f = 3'b001;
    7'bxxxxx10: res1f = 3'b010;
    7'bxxxx100: res1f = 3'b011;
    7'bxxx1000: res1f = 3'b100;
    7'bxx10000: res1f = 3'b101;
    7'bx100000: res1f = 3'b110;
    7'b1000000: res1f = 3'b111;
    7'b0000000: res1f = 3'b000;
  endcase
end

//We can do a similar thing for res4 with the leftmost bit with a 1, with a temporary for comparison
//to avoid making them the same which would be bad.

reg [0:2] res4t;
always @(*) begin
  (* parallel_case *) casex (bufFree)
    7'b1xxxxxx: res4t = 3'b111;
    7'b01xxxxx: res4t = 3'b110;
    7'b001xxxx: res4t = 3'b101;
    7'b0001xxx: res4t = 3'b100;
    7'b00001xx: res4t = 3'b011;
    7'b000001x: res4t = 3'b010;
    7'b0000001: res4t = 3'b001;
    7'b0000000: res4t = 3'b000;
  endcase
  res4f = (res1f == res4t) ? 3'b000 : res4t;
end

//Now the next part depends on the result in res4. If it's zero, we may as well skip the next step as
//there's only 1 available buffer.
reg [0:2] res2t, res3t;
always @(*) begin
  if (res4f == 3'b000) begin
    res2f = 3'b000;
    res3f = 3'b000;
  end
  else begin
    res2f = res2z;
    res3f = res3z;
  end
end

//Ok, so now we know we have 2 different values in outputs 1 and 4. We can simply set these to 0 in a
//new buffer to avoid causing pain
wire bufFree2;
assign bufFree2 = bufFree & ~(1 << res1f | 1 << res4f);

//Now to do the same thing again

always @(*) begin
  (* parallel_case *) casex (bufFree)
    7'bxxxxxx1: res2t = 3'b001;
    7'bxxxxx10: res2t = 3'b010;
    7'bxxxx100: res2t = 3'b011;
    7'bxxx1000: res2t = 3'b100;
    7'bxx10000: res2t = 3'b101;
    7'bx100000: res2t = 3'b110;
    7'b1000000: res2t = 3'b111;
    7'b0000000: res2t = 3'b000;
  endcase
end

reg [0:2] res3tt;
always @(*) begin
  (* parallel_case *) casex (bufFree)
    7'b1xxxxxx: res3tt = 3'b111;
    7'b01xxxxx: res3tt = 3'b110;
    7'b001xxxx: res3tt = 3'b101;
    7'b0001xxx: res3tt = 3'b100;
    7'b00001xx: res3tt = 3'b011;
    7'b000001x: res3tt = 3'b010;
    7'b0000001: res3tt = 3'b001;
    7'b0000000: res3tt = 3'b000;
  endcase
  res3t = (res2t == res3tt) ? 3'b000 : res3tt;
end

//If either of those pairs are the same it needs to be zeroed too.
reg [0:2] res2z, res3z;
always @(*) begin
  res2z = (res1f == res2t) ? 3'b000 : res2t;
  res3z = (res3t == res4f) ? 3'b000 : res3t;
end

//Finally, the Fs just need to be "sorted", by which I mean moving a zero in 2 or 3 into 4 if 4 is
//non zero. If both 2 and 3 are zero, we can just swap 2 with 0 to be done. If just 3 is 0, we need to
//swap that with 0, and the same if just 2. So, the smart move seems to be to swap 4 and 2 in all cases,
//then, as 2 cannot be zero if 3 is not, swap 3 and 4. In other words:
always @(*)
begin
  res1 = res1f;
  res2 = res4f;
  res3 = res2f;
  res3 = res3f;
end

//BAM, 4 buffers with zeros in the directions we want!
endmodule
