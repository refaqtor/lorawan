module lorawan.test.gateway.pullackpackettest;

import lorawan.gateway.pullackpacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.lora;
import std.random;
import checkit;

unittest
{
  scenario!("Transformation PULL_ACK packet to an array of bytes", ["gateway"])
  ({
      given!"PULL_ACK packet"
      ({
          PullAckPacket pullAckPacket = new PullAckPacket;
  
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          
          pullAckPacket.setProtocolVersion(ProtocolVersion.VERSION_2);
          pullAckPacket.setToken(randomToken);
          
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.PULL_ACK;
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pullAckPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                  packetData.shouldEqual(expected);
              });
          });
      });
  });

  scenario!("Transformation default PULL_ACK packet to an array of bytes", ["gateway"])
  ({
      given!"Default PULL_ACK packet"
      ({
          PullAckPacket pullAckPacket = new PullAckPacket;
          ubyte[] expected = [2,0,0,4];
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pullAckPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                  packetData.shouldEqual(expected);
              });
          });
      });
  });

  scenario!("Transformation an array of bytes that represending the PULL_ACK packet correctly into PULL_ACK packet", ["gateway"])
  ({
      given!"Array of bytes that represending the PULL_ACK packet correctly"
      ({
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          ubyte[] pullAckArray = 2 ~ randomToken ~ 4;
          
          when!"Function 'parse' is called"
          ({
              auto pullAckPacket = Lora.parse(pullAckArray);
              
              PullAckPacket expected = new PullAckPacket;
              expected.setProtocolVersion(ProtocolVersion.VERSION_2);
              expected.setToken(randomToken);
              
              then!"Get the correct PULL_ACK packet"
              ({
                  pullAckPacket.shouldNotBeNull();
                  pullAckPacket.shouldBeInstanceOf!PullAckPacket();
                  (cast(PullAckPacket) pullAckPacket).shouldEqual(expected);
              });
          });
      });
  });

  scenario!("Transformation an array of bytes that represending the PULL_ACK packet uncorrectly into PULL_ACK packet", ["gateway"])
  ({
      given!"Arrays of bytes that represending the PULL_ACK packet uncorrectly"
      ({
          // incorrect packet type (forth byte should equal 4)
          ubyte[] incorrectPullAckArray1 = [2, uniform!ubyte, uniform!ubyte, 2];
          // incorrect protocol version (first byte should equal 2)
          ubyte[] incorrectPullAckArray2 = [1, uniform!ubyte, uniform!ubyte, 4];
          // incorrect array length (array length should equal 4)
          ubyte[] incorrectPullAckArray3 = [1, 2];
          
          when!"Function 'parse' is called"
          ({
              auto pullAckPacket1 = Lora.parse(incorrectPullAckArray1);
              auto pullAckPacket2 = Lora.parse(incorrectPullAckArray2);
              auto pullAckPacket3 = Lora.parse(incorrectPullAckArray3);
              
              then!"Get a return value different from the PULL_ACK packet"
              ({
                  pullAckPacket1.shouldBeNull();
                  pullAckPacket2.shouldBeNull();
                  pullAckPacket3.shouldBeNull();
              });
          });
      });
  });
}