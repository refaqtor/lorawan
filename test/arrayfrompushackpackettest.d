module lorawan.test.arrayfrompushackpackettest;

import lorawan.gateway.pushackpacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import std.random;

unittest{
  PushAckPacket pushAckPAcket = new PushAckPacket;
  
  ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
  
  pushAckPAcket.setProtocolVersion(ProtocolVersion.VERSION_2);
  pushAckPAcket.setToken(randomToken);
  pushAckPAcket.setPacketType(PacketType.PUSH_ACK);
  
  ubyte[] pushAckArray= pushAckPAcket.getProtocolVersion ~ pushAckPAcket.getToken ~ pushAckPAcket.getPacketType;
  
  assert(pushAckPAcket.toUbyteArray == pushAckArray);
}