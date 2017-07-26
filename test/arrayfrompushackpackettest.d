module lorawan.test.arrayfrompushackpackettest;

import lorawan.gateway.pushackpacket;
import lorawan.gateway.abstractpacket;
import std.random;

unittest{
  PushAckPacket pushAckPAcket = new PushAckPacket;
  
  ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
  
  pushAckPAcket.setProtocolVersion(2);
  pushAckPAcket.setToken(randomToken);
  pushAckPAcket.setPacketTypeID(1);
  
  ubyte[] pushAckArray= pushAckPAcket.getProtocolVersion ~ pushAckPAcket.getToken ~ pushAckPAcket.getPacketTypeID;

  assert(pushAckPAcket.toUbyteArray == pushAckArray);
}