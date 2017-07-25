module lorawan.test.arrayfrompushackpackettest;

//TODO: remove std.stdio;
import std.stdio;

import lorawan.parser.packets;
import lorawan.parser.parser;
import std.random;

unittest{
  PUSH_ACK pushAckStruct;
  pushAckStruct.token[0] = uniform!ubyte();
  pushAckStruct.token[1] = uniform!ubyte();
  
  ubyte[] pushAckArray= pushAckStruct.protocolVersion ~ pushAckStruct.token ~ pushAckStruct.pushAckID;
  
  Parser parser = new Parser;
  assert(parser.parseStructure(pushAckStruct) == pushAckArray);
}