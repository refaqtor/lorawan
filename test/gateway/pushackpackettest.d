module lorawan.test.gateway.pushackpackettest;

import lorawan.gateway.pushackpacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.lora;
import std.random;
import checkit;

unittest
{
  scenario!("Transformation PUSH_ACK packet to an array of bytes", ["gateway"])
  ({
      given!"PUSH_ACK packet"
      ({
          PushAckPacket pushAckPacket = new PushAckPacket;
  
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          
          pushAckPacket.setProtocolVersion(ProtocolVersion.VERSION_2);
          pushAckPacket.setToken(randomToken);
          
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.PUSH_ACK;
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pushAckPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                  packetData.shouldEqual(expected);
              });
          });
      });
  });

  scenario!("Transformation default PUSH_ACK packet to an array of bytes", ["gateway"])
  ({
      given!"Default PUSH_ACK packet"
      ({
          PushAckPacket pushAckPacket = new PushAckPacket;
          ubyte[] expected = [2,0,0,1];
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pushAckPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                  packetData.shouldEqual(expected);
              });
          });
      });
  });

  scenario!("Transformation an array of bytes that represending the PUSH_ACK packet correctly into PUSH_ACK packet", ["gateway"])
  ({
      given!"Array of bytes that represending the PUSH_ACK packet correctly"
      ({
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          ubyte[] pushAckArray = 2 ~ randomToken ~ 1;
          
          when!"Function 'parse' is called"
          ({
              auto pushAckPacket = Lora.parse(pushAckArray);
              
              PushAckPacket expected = new PushAckPacket;
              expected.setProtocolVersion(ProtocolVersion.VERSION_2);
              expected.setToken(randomToken);
              
              then!"Get the correct PUSH_ACK packet"
              ({
                  pushAckPacket.shouldNotBeNull();
                  pushAckPacket.shouldBeInstanceOf!PushAckPacket();
                  (cast(PushAckPacket) pushAckPacket).shouldEqual(expected);
              });
          });
      });
  });

  scenario!("Transformation an array of bytes that represending the PUSH_ACK packet uncorrectly into PUSH_ACK packet", ["gateway"])
  ({
      given!"Arrays of bytes that represending the PUSH_ACK packet uncorrectly"
      ({
          // incorrect packet type (forth byte should equal 1)
          ubyte[] incorrectPushAckArray1 = [2, uniform!ubyte, uniform!ubyte, 2];
          // incorrect protocol version (first byte should equal 2)
          ubyte[] incorrectPushAckArray2 = [1, uniform!ubyte, uniform!ubyte, 1];
          // incorrect array length (array length should equal 4)
          ubyte[] incorrectPushAckArray3 = [1, 2];
          
          when!"Function 'parse' is called"
          ({
              auto pushAckPacket1 = Lora.parse(incorrectPushAckArray1);
              auto pushAckPacket2 = Lora.parse(incorrectPushAckArray2);
              auto pushAckPacket3 = Lora.parse(incorrectPushAckArray3);
              
              then!"Get a return value different from the PUSH_ACK packet"
              ({
                  pushAckPacket1.shouldBeNull();
                  pushAckPacket2.shouldBeNull();
                  pushAckPacket3.shouldBeNull();
              });
          });
      });
  });
}
