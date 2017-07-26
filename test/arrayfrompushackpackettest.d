module lorawan.test.arrayfrompushackpackettest;

import lorawan.gateway.pushackpacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import std.random;

unittest
{
  PushAckPacket pushAckPacket = new PushAckPacket;
  
  ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
  
  pushAckPacket.setProtocolVersion(ProtocolVersion.VERSION_2);
  pushAckPacket.setToken(randomToken);
  pushAckPacket.setPacketType(PacketType.PUSH_ACK);
  
  ubyte[] pushAckArray= pushAckPacket.getProtocolVersion ~ pushAckPacket.getToken ~ pushAckPacket.getPacketType;
  
  assert(pushAckPacket.toByteArray == pushAckArray);
}