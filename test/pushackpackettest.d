module lorawan.test.pushackpackettest;

import lorawan.gateway.pushackpacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import std.random;

unittest
{
  // When we have a PUSH_ACK packet and the function 'toByteArray' is called
  // Then we get the correct byte array
  
  PushAckPacket pushAckPacket = new PushAckPacket;
  
  ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
  
  pushAckPacket.setProtocolVersion(ProtocolVersion.VERSION_2)
    .setToken(randomToken);
  
  ubyte[] pushAckArray = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.PUSH_ACK;
  
  assert(pushAckPacket.toByteArray == pushAckArray);
}

unittest
{
  // When we have a default PUSH_ACK packet and the function 'toByteArray' is called
  // Then we get the correct byte array
  
  PushAckPacket pushAckPacket = new PushAckPacket;
  
  ubyte[] pushAckArray = [2,0,0,1];
  
  assert(pushAckPacket.toByteArray == pushAckArray);
}