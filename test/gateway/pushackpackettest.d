module lorawan.test.gateway.pushackpackettest;

import lorawan.gateway.pushackpacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.lora;
import std.random;

static bool isEqual(PushAckPacket pushAckPacket1, PushAckPacket pushAckPacket2)
{
  if(pushAckPacket1.getProtocolVersion() != pushAckPacket2.getProtocolVersion()){ return false; }
  if(pushAckPacket1.getToken() != pushAckPacket2.getToken()){ return false; }
  if(pushAckPacket1.getPacketType() != pushAckPacket2.getPacketType()){ return false; }
  return true;
}

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

unittest
{
  // When we have an array of bytes that represending the PUSH_ACK packet correctly and the function 'parse' is called
  // Then we get the correct PUSH_ACK packet
  
  ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
  
  ubyte[] pushAckArray = 2 ~ randomToken ~ 1;
  
  PushAckPacket pushAckPacket1 = new PushAckPacket;
  
  pushAckPacket1.setProtocolVersion(ProtocolVersion.VERSION_2);
  pushAckPacket1.setToken(randomToken);
      
  auto pushAckPacket2 = Lora.parse(pushAckArray);
  
  assert(cast(PushAckPacket) pushAckPacket2 !is null);
  assert(isEqual(pushAckPacket1, cast(PushAckPacket) pushAckPacket2));
}

unittest
{
  // When we have an array of bytes that represending the PUSH_ACK packet uncorrectly and the function 'parse' is called
  // Then we get a return value different from the PUSH_ACK packet
  
  // incorrect packet type (forth byte should equal 1)
  ubyte[] incorrectPushAckArray1 = [2, uniform!ubyte, uniform!ubyte, 2];
  // incorrect protocol version (first byte should equal 2)
  ubyte[] incorrectPushAckArray2 = [1, uniform!ubyte, uniform!ubyte, 2];
  // incorrect array length (array length should equal 4)
  ubyte[] incorrectPushAckArray3 = [1, 2];
  
  auto pushAckPacket1 = Lora.parse(incorrectPushAckArray1);
  auto pushAckPacket2 = Lora.parse(incorrectPushAckArray2);
  auto pushAckPacket3 = Lora.parse(incorrectPushAckArray3);
  
  assert(pushAckPacket1 is null);
  assert(pushAckPacket2 is null);
  assert(pushAckPacket3 is null);
}
