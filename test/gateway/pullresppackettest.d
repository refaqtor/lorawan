module lorawan.test.gateway.pullresppackettest;

import std.random;
import std.json;

import lorawan.gateway.pullresppacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.lora;
import lorawan.gateway.macpacket;
import checkit;

unittest
{
  scenario!("Transformation PULL_RESP packet to an array of bytes", ["gateway"])
  ({
      given!"PULL_RESP packet"
      ({ 
          PullRespPacket pullRespPacket = new PullRespPacket();
          
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          Txpk txpkStruct;
                   
          MacPacket data = new MacPacket;
          data.setData("-DS4CGaDCdG+48eJNM3Vai-zDpsR71Pn9CPA9uCON84");
          
          txpkStruct.setImme(true);
          txpkStruct.setTmms(564654);
          txpkStruct.setTmst(3512348611);
          txpkStruct.setFreq(866.349812);
          txpkStruct.setChan(2);
          txpkStruct.setRfch(0);
          txpkStruct.setPowe(15);
          txpkStruct.setModu(ModulationIdentifier.LORA);
          txpkStruct.setDatr(LoraDatarate.SF_7_BW_125);
          txpkStruct.setCodr(CyclicCodingRate.CR_4_6);
          txpkStruct.setDatr(500000);
          txpkStruct.setFdev(3000);
          txpkStruct.setIpol(false);
          txpkStruct.setPrea(32);
          txpkStruct.setSize(64);
          txpkStruct.setData(data);
          txpkStruct.setNcrc(false);
          
          JSONValue expectedJsonValue;
          JSONValue txpkValue;
          
          txpkValue["imme"] = txpkStruct.getImme;
          txpkValue["tmms"] = txpkStruct.getTmms;
          txpkValue["tmst"] = txpkStruct.getTmst;
          txpkValue["freq"] = cast(double) txpkStruct.getFreq;
          txpkValue["chan"] = cast(ubyte) txpkStruct.getChan; 
          txpkValue["rfch"] = txpkStruct.getRfch; 
          txpkValue["powe"] = txpkStruct.getPowe; 
          txpkValue["modu"] = txpkStruct.getModu;
          txpkValue["datr"] = txpkStruct.getDatrs;
          txpkValue["codr"] = txpkStruct.getCodr;
          txpkValue["fdev"] = txpkStruct.getFdev; 
          txpkValue["ipol"] = txpkStruct.getIpol;
          txpkValue["prea"] = txpkStruct.getPrea;
          txpkValue["size"] = txpkStruct.getSize;
          txpkValue["data"] = (txpkStruct.getData).getData();
          txpkValue["ncrc"] = txpkStruct.getNcrc;
          
          expectedJsonValue["txpk"] = txpkValue;
          
          pullRespPacket.setProtocolVersion(ProtocolVersion.VERSION_2);
          pullRespPacket.setToken(randomToken);
          pullRespPacket.setTxpkStruct(txpkStruct);
  
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.PULL_RESP ~ cast(ubyte[]) toJSON(expectedJsonValue);
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pullRespPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                packetData.shouldEqual(expected);
              });
          });
      });
  });
  
  scenario!("Transformation default PULL_RESP packet to an array of bytes", ["gateway"])
  ({
      given!"default PULL_RESP packet"
      ({
          PullRespPacket pullRespPacket = new PullRespPacket;
          
          ubyte[2] randomToken = [0, 0];
          
          string jsonString = `{"txpk" : {
            "modu":"LORA",
            "datr":"SF6BW125",
            "codr":"4/5"
          }}`;
          JSONValue expectedJsonValue = parseJSON(jsonString);
  
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.PULL_RESP ~ cast(ubyte[]) toJSON(expectedJsonValue);
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pullRespPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                packetData.shouldEqual(expected);
              });
          });
      });
  });  
  
  scenario!("Transformation PULL_RESP packet in FSK mode to an array of bytes", ["gateway"])
  ({
      given!"PULL_RESP packet in FSK mode"
      ({ 
          PullRespPacket pullRespPacket = new PullRespPacket;
          Txpk txpkStruct;
          
          txpkStruct.setModu(ModulationIdentifier.FSK);
          txpkStruct.setDatr(LoraDatarate.SF_7_BW_125);
          txpkStruct.setDatr(500000);
          
          JSONValue expectedJsonValue;
          JSONValue txpkValue;
          
          txpkValue["modu"] = txpkStruct.getModu;
          txpkValue["datr"] = txpkStruct.getDatrn;
          txpkValue["codr"] = CyclicCodingRate.CR_4_5;
                    
          expectedJsonValue["txpk"] = txpkValue;
          
          pullRespPacket.setTxpkStruct(txpkStruct);
  
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ cast(ubyte[]) [0, 0] ~ PacketType.PULL_RESP ~ cast(ubyte[]) toJSON(expectedJsonValue);
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pullRespPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                packetData.shouldEqual(expected);
              });
          });
      });
  });
    
  scenario!("Transformation an array of bytes that represending the PULL_RESP packet correctly into PULL_RESP packet", ["gateway"])
  ({
      given!"Array of bytes that represending the PULL_RESP packet correctly"
      ({
          PullRespPacket expected = new PullRespPacket;
          
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          Txpk txpkStruct;
          
          MacPacket data = new MacPacket;
          data.setData("-DS4CGaDCdG+48eJNM3Vai-zDpsR71Pn9CPA9uCON84");
          
          txpkStruct.setModu(ModulationIdentifier.FSK);
          txpkStruct.setCodr(CyclicCodingRate.CR_4_8);
          txpkStruct.setImme(true);
          txpkStruct.setIpol(true);
          txpkStruct.setNcrc(false);
          txpkStruct.setPowe(uint.max);
          txpkStruct.setFdev(uint.max);
          txpkStruct.setPrea(123);
          txpkStruct.setDatr(5000);
          txpkStruct.setTmms(789);
          txpkStruct.setTmst(987);
          txpkStruct.setFreq(456);
          txpkStruct.setChan(12);
          txpkStruct.setRfch(369);
          txpkStruct.setSize(232);
          txpkStruct.setData(data);
          
          expected.setProtocolVersion(ProtocolVersion.VERSION_2);
          expected.setToken(randomToken);
          expected.setTxpkStruct(txpkStruct);
          
          ubyte[] pullRespArray = expected.toByteArray;
          
          when!"Function 'parse' is called"
          ({
              auto pullRespPacket = Lora.parse(pullRespArray);
              
              then!"Get the correct PULL_RESP packet"
              ({
                  pullRespPacket.shouldNotBeNull();
                  pullRespPacket.shouldBeInstanceOf!PullRespPacket();
                  
                  PullRespPacket gotPullRespPacket = cast(PullRespPacket)pullRespPacket;
                  
                  (gotPullRespPacket.getTxpkStruct).shouldEqual(expected.getTxpkStruct);
                  (gotPullRespPacket.getProtocolVersion).shouldEqual(expected.getProtocolVersion);
                  (gotPullRespPacket.getToken).shouldEqual(expected.getToken);
                  (gotPullRespPacket.getPacketType).shouldEqual(expected.getPacketType);
              });
          });
      });
  });

  scenario!("Transformation an array of bytes that represending the PULL_RESP packet uncorrectly into PULL_RESP packet", ["gateway"])
  ({
      given!"Arrays of bytes that represending the PULL_RESP packet uncorrectly"
      ({  
          // incorrect packet type (forth byte should equal 3)
          ubyte[] incorrectPullRespArray1 = [2, uniform!ubyte, uniform!ubyte, 1, 99];
          // incorrect protocol version (first byte should equal 2)
          ubyte[] incorrectPullRespArray2 = [1, uniform!ubyte, uniform!ubyte, 3, 99];
          // incorrect array length (array length should be more than '4')
          ubyte[] incorrectPullRespArray3 = [2, uniform!ubyte, uniform!ubyte, 3];
          
          //json object should not be null!
          string incorrectJsonString1 = ``;
          //json object should contain "txpk" field!
          string incorrectJsonString2 = `{"test" : 1}`;
          //field "txpk" of json object should have "OBJECT" type, not "ARRAY"!
          string incorrectJsonString3 = `{"txpk" : [1, 2, 3]}`;
          //field "imme" of txpk structure should have "TRUE" or "FALSE" type, not "ARRAY"!
          string incorrectJsonString4 = `{"txpk" : { "modu" : "LORA", "datr" : "SF7BW125", "codr" : "4/5", "imme" : [1, 2, 3] }}`;
 
          ubyte[] getIncorrectPullRespArrayWithJson(string incorrectJsonString)
          {
            JSONValue incorrectJsonValue = parseJSON(incorrectJsonString);
            ubyte[] incorrectByteArray = cast(ubyte[]) toJSON(incorrectJsonValue);
            ubyte[] notJsonPart = cast(ubyte[]) [2, uniform!ubyte, uniform!ubyte, 3];
            ubyte[] incorrectPullRespArrayWithJson = notJsonPart ~ incorrectByteArray;
            return incorrectPullRespArrayWithJson;
          }
               
          ubyte[] incorrectPullRespArrayWithJson1 = getIncorrectPullRespArrayWithJson(incorrectJsonString1);
          ubyte[] incorrectPullRespArrayWithJson2 = getIncorrectPullRespArrayWithJson(incorrectJsonString2);
          ubyte[] incorrectPullRespArrayWithJson3 = getIncorrectPullRespArrayWithJson(incorrectJsonString3);
          ubyte[] incorrectPullRespArrayWithJson4 = getIncorrectPullRespArrayWithJson(incorrectJsonString4);
          
          when!"Function 'parse' is called"
          ({
              auto pullRespPacket1 = Lora.parse(incorrectPullRespArray1);
              auto pullRespPacket2 = Lora.parse(incorrectPullRespArray2);
              auto pullRespPacket3 = Lora.parse(incorrectPullRespArray3);
              
              then!"Get a return value different from the PULL_RESP packet or exception message"
              ({
                  pullRespPacket1.shouldBeNull();
                  pullRespPacket2.shouldBeNull();
                  pullRespPacket3.shouldBeNull();
                  
                  (Lora.parse(incorrectPullRespArrayWithJson1)).shouldThrowWithMessage("byte array should contain " ~ 
                    "json object, but recieved array contain only \"null\" json object!");
                  
                  (Lora.parse(incorrectPullRespArrayWithJson2)).shouldThrowWithMessage("json object should contain \"txpk\" field!");
                  
                  (Lora.parse(incorrectPullRespArrayWithJson3)).shouldThrowWithMessage("field \"txpk\" of json object " ~
                    "should have \"OBJECT\" type, but it have \"ARRAY\" type!");
                  
                  (Lora.parse(incorrectPullRespArrayWithJson4)).shouldThrowWithMessage("field \"imme\" of txpk structure " ~
                    "from json object should have one of this types: \"TRUE\" or \"FALSE\", but it have \"ARRAY\" type!");
              });
          });
      });
  }); 
}