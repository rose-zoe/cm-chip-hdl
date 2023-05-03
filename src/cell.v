/*
 * Architectural notes: I'm going to use some kind of finite state machine to control the cycles on
 * which the cell should actually execute and on which it should do nothing. The actual processing and
 * all should be doable in one cycle so no need to fret there, but it will only go on cycles when a
 * specific control line is on. Memory reading and writing will also be managed externally; the cells
 * here will receiver only the bits from the memory and send the bits back out.
 */

module procCell (
  input clk, //Hardware stuff
  input latch,

  input readA, //Instruction stuff
  input readB,
  input flagR,
  input flagW,
  input flagC,
  input sense,
  input memTruth,
  input flagTruth,
  input newsDir,

  input north, //Inputs from other cells on chip
  input east,
  input south,
  input west,
  input daisy,

  input handshake, //Router stuff
  input routerIn,

  output reg writeA, //Writeback
  output reg flagOut, //For daisychaining and what have you
  output reg routerData, //Data being sent to router
  output reg gloPin, //Assertions over global pin
);

localparam
  ZERO    = 4'b0000,
  GLOBAL  = 4'b0001,
  LONGPAR = 4'b0010,
  DAISY   = 4'b0011,
  RACK    = 4'b0100,
  RDAT    = 4'b0101,
  CUBE    = 4'b0110,
  NEWS    = 4'b0111,

  NORTH   = 2'b00,
  EAST    = 2'b01,
  SOUTH   = 2'b11,
  WEST    = 2'b10;

reg [7:0] generalFlags;

reg newsIn; //Put the correct NEWS input on the line
always @(*)
  case(newsDir)
    NORTH: newsIn <= north;
    EAST: newsIn <= east;
    SOUTH: newsIn <= south;
    WEST: newsIn <= west;
  endcase

reg conWire; //The value of the the flag being conditioned on
always @(*)
  case(flagC)
    ZERO:    conWire <= 1'b0;
    GLOBAL:  conWire <= 1'b0;
    LONGPAR: conWire <= 1'b0;
    DAISY:   conWire <= daisy;
    RACK:    conWire <= handshake;
    RDAT:    conWire <= routerIn;
    CUBE:    conWire <= 1'b0;
    NEWS:    conWire <= newsIn;
    default: conWire <= generalFlags[flagC & 3'b111);
  endcase

reg flagVal; //The value of the flag being read
always @(*)
  case(flagR)
    ZERO:    flagVal <= 1'b0;
    GLOBAL:  flagVal <= 1'b0;
    LONGPAR: flagVal <= 1'b0;
    DAISY:   flagVal <= daisy;
    RACK:    flagVal <= handshake;
    RDAT:    flagVal <= routerIn;
    CUBE:    flagVal <= 1'b0;
    NEWS:    flagVal <= newsIn;
    default: flagVal <= generalFlags[flagR & 3'b111);
  endcase

wire memRes; //Result of memory calculation
assign memRes = memTruth[{readA, readB, flagVal}];

wire flagRes; //Result of flag calculation
assign flagRes = flagTruth[{readA, readB, flagVal}];

always @(posedge clk) begin
  if (latch) begin
    if (conWire == sense) begin
      //First, it is simple to return the memory value to be written back to
      writeA <= memRes;

      //The result of the flag calculation is always written to flagOut
      flagOut <= flagRes;

      //Writing back the flag result is a little more complicated
      if (flagW == GLOBAL) gloPin <= flagRes;
      if (flagW == RDAT) routerData <= flagRes;
      if (flagW & 4'b1000) generalFlags[flagW & 3'b111] <= flagRes;
    end
    else writeA <= readA;
  end
end

endmodule
