module lorawan.test.gateway.pulldatapackettest;

import lorawan.gateway.pulldatapacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.lora;
import std.random;
import checkit;

unittest
{
  scenario!("Transformation PULL_DATA packet to an array of bytes", ["gateway"])
  ({
      given!"PULL_DATA packet"
      ({
          PullDataPacket pullDataPacket = new PullDataPacket;
  
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          GatewayID gatewayID = [1, 2, 3, 4, 5, 6, 7, 8];
          
          pullDataPacket.setProtocolVersion(ProtocolVersion.VERSION_2);
          pullDataPacket.setToken(randomToken);
          pullDataPacket.setGatewayID(gatewayID);
          
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.PULL_DATA ~ gatewayID;
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pullDataPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                  packetData.shouldEqual(expected);
              });
          });
      });
  });

  scenario!("Transformation default PULL_DATA packet to an array of bytes", ["gateway"])
  ({
      given!"Default PULL_DATA packet"
      ({
          PullDataPacket pullDataPacket = new PullDataPacket;
          ubyte[] expected = [2,0,0,2,0,0,0,0,0,0,0,0];
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pullDataPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                  packetData.shouldEqual(expected);
              });
          });
      });
  });

  scenario!("Transformation an array of bytes that represending the PULL_DATA packet correctly into PULL_DATA packet", ["gateway"])
  ({
      given!"Array of bytes that represending the PULL_DATA packet correctly"
      ({
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          GatewayID gatewayID = [1, 2, 3, 4, 5, 6, 7, 8];
          
          ubyte[] pullDataArray = 2 ~ randomToken ~ 2 ~ gatewayID;
          
          when!"Function 'parse' is called"
          ({
              auto pullDataPacket = Lora.parse(pullDataArray);
              
              PullDataPacket expected = new PullDataPacket;
              expected.setProtocolVersion(ProtocolVersion.VERSION_2);
              expected.setToken(randomToken);
              expected.setGatewayID(gatewayID);
              
              then!"Get the correct PULL_DATA packet"
              ({
                  pullDataPacket.shouldNotBeNull();
                  pullDataPacket.shouldBeInstanceOf!PullDataPacket();
                  
                  // For coverage
                  (cast(PullDataPacket) pullDataPacket).getGatewayID.shouldEqual(gatewayID);
                  
                  (cast(PullDataPacket) pullDataPacket).shouldEqual(expected);
              });
          });
      });
  });

  scenario!("Transformation an array of bytes that represending the PULL_DATA packet uncorrectly into PULL_DATA packet", ["gateway"])
  ({
      given!"Arrays of bytes that represending the PULL_DATA packet uncorrectly"
      ({
          // incorrect packet type (forth byte should equal 2)
          ubyte[] incorrectPullDataArray1 = [2, uniform!ubyte, uniform!ubyte, 0];
          // incorrect protocol version (first byte should equal 2)
          ubyte[] incorrectPullDataArray2 = [1, uniform!ubyte, uniform!ubyte, 2];
          // incorrect array length (array length should equal 12)
          ubyte[] incorrectPullDataArray3 = [2, 2];
          
          when!"Function 'parse' is called"
          ({
              auto pullDataPacket1 = Lora.parse(incorrectPullDataArray1);
              auto pullDataPacket2 = Lora.parse(incorrectPullDataArray2);
              auto pullDataPacket3 = Lora.parse(incorrectPullDataArray3);
              
              then!"Get a return value different from the PULL_DATA packet"
              ({
                  pullDataPacket1.shouldBeNull();
                  pullDataPacket2.shouldBeNull();
                  pullDataPacket3.shouldBeNull();
              });
          });
      });
  });
}