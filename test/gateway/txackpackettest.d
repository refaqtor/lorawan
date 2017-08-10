module lorawan.test.gateway.txackpackettest;

import std.random;
import std.json;
import std.conv;

import lorawan.gateway.txackpacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.lora;
import lorawan.gateway.macpacket;
import checkit;

unittest
{
  scenario!("Transformation TX_ACK packet to an array of bytes", ["gateway"])
  ({
      given!"TX_ACK packet"
      ({ 
          TxAckPacket txAckPacket = new TxAckPacket;
          
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          GatewayID gatewayID = [1, 2, 3, 4, 5, 6, 7, 8];
          TxpkAck txpkAckStruct = TxpkAck();
          
          txpkAckStruct.setError(DownlinkRequestError.NONE);
          
          JSONValue expectedJsonValue;
          JSONValue txpkAckValue;
          
          txpkAckValue["error"] = to!string(txpkAckStruct.getError);
          
          expectedJsonValue["txpk_ack"] = txpkAckValue;
          
          txAckPacket.setProtocolVersion(ProtocolVersion.VERSION_2);
          txAckPacket.setToken(randomToken);
          txAckPacket.setGatewayID(gatewayID);
          txAckPacket.setTxpkAckStruct(txpkAckStruct);
  
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.TX_ACK ~ gatewayID ~ cast(ubyte[]) toJSON(expectedJsonValue);
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = txAckPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                packetData.shouldEqual(expected);
              });
          });
      });
  });
  
  scenario!("Transformation default TX_ACK packet to an array of bytes", ["gateway"])
  ({
      given!"default TX_ACK packet"
      ({
          TxAckPacket txAckPacket = new TxAckPacket;
          
          ubyte[2] randomToken = [0, 0];
          GatewayID gatewayID = [0, 0, 0, 0, 0, 0, 0, 0];
          
          string jsonString = `{"txpk_ack" : {
            "error" : "NONE"
          }}`;
          JSONValue expectedJsonValue = parseJSON(jsonString);
  
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.TX_ACK ~ gatewayID ~ cast(ubyte[]) toJSON(expectedJsonValue);
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = txAckPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                packetData.shouldEqual(expected);
              });
          });
      });
  });
 
  scenario!("Transformation an array of bytes that represending the TX_ACK packet correctly into TX_ACK packet", ["gateway"])
  ({
      given!"Array of bytes that represending the TX_ACK packet correctly"
      ({
          TxAckPacket expected = new TxAckPacket;
          
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          GatewayID gatewayID = [1, 2, 3, 4, 5, 6, 7, 8];
          
          TxpkAck txpkAckStruct;
          
          txpkAckStruct.setError(DownlinkRequestError.NONE);
          
          expected.setProtocolVersion(ProtocolVersion.VERSION_2);
          expected.setToken(randomToken);
          expected.setGatewayID(gatewayID);
          expected.setTxpkAckStruct(txpkAckStruct);
          
          ubyte[] txAckArray = expected.toByteArray;
          
          when!"Function 'parse' is called"
          ({
              auto txAckPacket = Lora.parse(txAckArray);
              
              then!"Get the correct TX_ACK packet"
              ({
                  txAckPacket.shouldNotBeNull();
                  txAckPacket.shouldBeInstanceOf!TxAckPacket();
                  
                  TxAckPacket gotTxAckPacket = cast(TxAckPacket)txAckPacket;
                  
                  (gotTxAckPacket.getGatewayID).shouldEqual(expected.getGatewayID);
                  (gotTxAckPacket.getTxpkAckStruct).shouldEqual(expected.getTxpkAckStruct);
                  (gotTxAckPacket.getProtocolVersion).shouldEqual(expected.getProtocolVersion);
                  (gotTxAckPacket.getToken).shouldEqual(expected.getToken);
                  (gotTxAckPacket.getPacketType).shouldEqual(expected.getPacketType);
              });
          });
      });
  });

  scenario!("Transformation an array of bytes that represending the TX_ACK packet uncorrectly into TX_ACK packet", ["gateway"])
  ({
      given!"Arrays of bytes that represending the TX_ACK packet uncorrectly"
      ({  
          // incorrect packet type (forth byte should equal 5)
          ubyte[] incorrectTxAckArray1 = [2, uniform!ubyte, uniform!ubyte, 1, 1, 2, 3, 4, 5, 6, 7, 8, 99];
          // incorrect protocol version (first byte should equal 2)
          ubyte[] incorrectTxAckArray2 = [1, uniform!ubyte, uniform!ubyte, 5, 1, 2, 3, 4, 5, 6, 7, 8, 99];
          // incorrect array length (array length should be more than '12')
          ubyte[] incorrectTxAckArray3 = [2, uniform!ubyte, uniform!ubyte, 5, 1, 2, 3, 4, 5, 6, 7, 8];
          
          //json object should not be null!
          string incorrectJsonString1 = ``;
          //json object should contain "txpk_ack" field!
          string incorrectJsonString2 = `{"test" : 1}`;
          //field "txpk_ack" of json object should have "OBJECT" type, not "ARRAY"!
          string incorrectJsonString3 = `{"txpk_ack" : [1, 2, 3]}`;
          //field "error" of txpk_ack structure should have "STRING" type, not "ARRAY"!
          string incorrectJsonString4 = `{"txpk_ack" : {"error" : [1, 2, 3]}}`;
          //field "error" of txpk_ack structure must belong to the DownlinkRequestError enum!
          string incorrectJsonString5 = `{"txpk_ack" : {"error" : "hello"}}`;
          //txpk_ack structure from json object should have field "error"!
          string incorrectJsonString6 = `{"txpk_ack" : {"test" : 1}}`;

          
          ubyte[] getIncorrectTxAckArrayWithJson(string incorrectJsonString)
          {
            JSONValue incorrectJsonValue = parseJSON(incorrectJsonString);
            ubyte[] incorrectByteArray = cast(ubyte[]) toJSON(incorrectJsonValue);
            ubyte[] notJsonPart = cast(ubyte[]) [2, uniform!ubyte, uniform!ubyte, 5, 1, 2, 3, 4, 5, 6, 7, 8];
            ubyte[] incorrectTxAckArrayWithJson = notJsonPart ~ incorrectByteArray;
            return incorrectTxAckArrayWithJson;
          }
               
          ubyte[] incorrectTxAckArrayWithJson1 = getIncorrectTxAckArrayWithJson(incorrectJsonString1);
          ubyte[] incorrectTxAckArrayWithJson2 = getIncorrectTxAckArrayWithJson(incorrectJsonString2);
          ubyte[] incorrectTxAckArrayWithJson3 = getIncorrectTxAckArrayWithJson(incorrectJsonString3);
          ubyte[] incorrectTxAckArrayWithJson4 = getIncorrectTxAckArrayWithJson(incorrectJsonString4);
          ubyte[] incorrectTxAckArrayWithJson5 = getIncorrectTxAckArrayWithJson(incorrectJsonString5);
          ubyte[] incorrectTxAckArrayWithJson6 = getIncorrectTxAckArrayWithJson(incorrectJsonString6);
          
          when!"Function 'parse' is called"
          ({
              auto txAckPacket1 = Lora.parse(incorrectTxAckArray1);
              auto txAckPacket2 = Lora.parse(incorrectTxAckArray2);
              auto txAckPacket3 = Lora.parse(incorrectTxAckArray3);
              
              then!"Get a return value different from the PUSH_DATA packet or exception message"
              ({
                  txAckPacket1.shouldBeNull();
                  txAckPacket2.shouldBeNull();
                  txAckPacket3.shouldBeNull();
                  
                  (Lora.parse(incorrectTxAckArrayWithJson1)).shouldThrowWithMessage("byte array should contain " ~ 
                    "json object, but recieved array contain only \"null\" json object!");
                  
                  (Lora.parse(incorrectTxAckArrayWithJson2)).shouldThrowWithMessage("json object should contain " ~
                    "\"txpk_ack\" field!");
                  
                  (Lora.parse(incorrectTxAckArrayWithJson3)).shouldThrowWithMessage("field \"txpk_ack\" of json object " ~
                    "should have \"OBJECT\" type, but it have \"ARRAY\" type!");
                  
                  (Lora.parse(incorrectTxAckArrayWithJson4)).shouldThrowWithMessage("field \"error\" of txpk_ack structure " ~
                    "from json object should have \"STRING\" type, but it have \"ARRAY\" type!");
                  
                  (Lora.parse(incorrectTxAckArrayWithJson5)).shouldThrowWithMessage("field \"error\" of txpk_ack " ~
                    "structure from json object should have one of this values: \"NONE\", \"TOO_LATE\", \"TOO_EARLY\", " ~
                    "\"COLLISION_PACKET\", \"COLLISION_BEACON\", \"TX_FREQ\", \"TX_POWER\" or \"GPS_UNLOCKED\", " ~
                    "but it has the value \"hello\"!");
                  
                  (Lora.parse(incorrectTxAckArrayWithJson6)).shouldThrowWithMessage("txpk_ack structure from " ~
                    "json object should have field \"error\"!");
              });
          });
      });
  });
 
//  scenario!("Transformation an arrays of bytes that represending the PUSH_DATA packet correctly and have different " ~
//    "CRC status into PUSH_DATA packet", ["gateway"])
//  ({
//      given!"Array of bytes that represending the PUSH_DATA packet correctly and have different CRC status"
//      ({
//          when!"Function 'parse' is called"
//          ({
//              then!"Get the correct PUSH_DATA packet"
//              ({
//                  void verifyTheCorrectnessOfParsingForDifferentValue(CrcStatus crcStatus)
//                  {
//                    PushDataPacket expected = new PushDataPacket;
//                    Rxpk rxpkStruct;
//                    rxpkStruct.setStat(crcStatus);
//                    expected.setRxpkArray([rxpkStruct]);
//                    ubyte[] pushDataArray = expected.toByteArray;
//                    auto pushDataPacket = Lora.parse(pushDataArray);
//                    pushDataPacket.shouldNotBeNull();
//                    pushDataPacket.shouldBeInstanceOf!PushDataPacket();
//                    PushDataPacket gotPushDataPacket = cast(PushDataPacket)pushDataPacket;
//                    gotPushDataPacket.shouldEqual(expected);
//                  }
//                  
//                  verifyTheCorrectnessOfParsingForDifferentValue(CrcStatus.OK);
//                  verifyTheCorrectnessOfParsingForDifferentValue(CrcStatus.FAIL);
//                  verifyTheCorrectnessOfParsingForDifferentValue(CrcStatus.NO_CRC);
//              });
//          });
//      });
//  });
//  
//  scenario!("Transformation an arrays of bytes that represending the PUSH_DATA packet correctly and have different " ~
//    "datr value in \"LORA\" mode into PUSH_DATA packet", ["gateway"])
//  ({
//      given!"Array of bytes that represending the PUSH_DATA packet correctly and have datr value in \"LORA\" mode"
//      ({  
//          when!"Function 'parse' is called"
//          ({  
//              then!"Get the correct PUSH_DATA packet"
//              ({
//                  void verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate loraDatarate)
//                  {
//                    PushDataPacket expected = new PushDataPacket;
//                    Rxpk rxpkStruct;
//                    rxpkStruct.setModu(ModulationIdentifier.LORA);
//                    rxpkStruct.setDatr(loraDatarate);
//                    expected.setRxpkArray([rxpkStruct]);
//                    ubyte[] pushDataArray = expected.toByteArray;
//                    auto pushDataPacket = Lora.parse(pushDataArray);
//                    pushDataPacket.shouldNotBeNull();
//                    pushDataPacket.shouldBeInstanceOf!PushDataPacket();
//                    PushDataPacket gotPushDataPacket = cast(PushDataPacket)pushDataPacket;
//                    gotPushDataPacket.shouldEqual(expected);
//                  }
//                  
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_6_BW_125);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_6_BW_250);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_6_BW_500);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_7_BW_125);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_7_BW_250);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_7_BW_500);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_8_BW_125);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_8_BW_250);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_8_BW_500);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_9_BW_125);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_9_BW_250);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_9_BW_500);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_10_BW_125);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_10_BW_250);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_10_BW_500);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_11_BW_125);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_11_BW_250);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_11_BW_500);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_12_BW_125);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_12_BW_250);
//                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_12_BW_500);
//              });
//          });
//      });
//  });
//  
//  scenario!("Transformation an arrays of bytes that represending the PUSH_DATA packet correctly and have different " ~
//    "cyclic coding rate into PUSH_DATA packet", ["gateway"])
//  ({
//      given!"Array of bytes that represending the PUSH_DATA packet correctly and have different cyclic coding rate"
//      ({
//          when!"Function 'parse' is called"
//          ({
//              then!"Get the correct PUSH_DATA packet"
//              ({
//                  void verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate cyclicCodingRate)
//                  {
//                    PushDataPacket expected = new PushDataPacket;
//                    Rxpk rxpkStruct;
//                    rxpkStruct.setCodr(cyclicCodingRate);
//                    expected.setRxpkArray([rxpkStruct]);
//                    ubyte[] pushDataArray = expected.toByteArray;
//                    auto pushDataPacket = Lora.parse(pushDataArray);
//                    pushDataPacket.shouldNotBeNull();
//                    pushDataPacket.shouldBeInstanceOf!PushDataPacket();
//                    PushDataPacket gotPushDataPacket = cast(PushDataPacket)pushDataPacket;
//                    gotPushDataPacket.shouldEqual(expected);
//                  }
//                  
//                  verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate.CR_4_5);
//                  verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate.CR_4_6);
//                  verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate.CR_4_7);
//                  verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate.CR_4_8);
//              });
//          });
//      });
//  });
//  
//  scenario!("Transformation an arrays of bytes that represending the PUSH_DATA packet in \"FSK\" mode correctly", ["gateway"])
//  ({
//      given!"Array of bytes that represending the PUSH_DATA packet in \"FSK\" mode correctly"
//      ({
//          PushDataPacket expected = new PushDataPacket;
//          Rxpk rxpkStruct;
//          rxpkStruct.setModu(ModulationIdentifier.FSK);
//          rxpkStruct.setDatr(3_294_967_295);
//          expected.setRxpkArray([rxpkStruct]);          
//          ubyte[] pushDataArray = expected.toByteArray;
//          
//          when!"Function 'parse' is called"
//          ({
//              auto pushDataPacket = Lora.parse(pushDataArray);
//              
//              then!"Get the correct PUSH_DATA packet"
//              ({
//                  pushDataPacket.shouldNotBeNull();
//                  pushDataPacket.shouldBeInstanceOf!PushDataPacket();
//                  PushDataPacket gotPushDataPacket = cast(PushDataPacket)pushDataPacket;
//                  gotPushDataPacket.shouldEqual(expected);  
//              });
//          });
//      });
//  });
}