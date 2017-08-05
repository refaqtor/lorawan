module lorawan.test.gateway.pushdatapackettest;

import std.random;
import std.json;
import std.datetime;

import lorawan.gateway.pushdatapacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.lora;
import lorawan.gateway.macpacket;
import checkit;

unittest
{
  scenario!("Transformation PUSH_DATA packet to an array of bytes", ["gateway"])
  ({
      given!"PUSH_DATA packet"
      ({ 
          PushDataPacket pushDataPacket = new PushDataPacket();
          
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          GatewayID gatewayID = [1, 2, 3, 4, 5, 6, 7, 8];
          Rxpk[] rxpkArray = [];
          Stat statStruct;
          
          Rxpk rxpkStruct;
          
          SysTime sysTime = SysTime(DateTime(2017, 6, 3, 22, 22, 52), hnsecs(45), UTC());
          MacPacket data = new MacPacket;
          data.setData("-DS4CGaDCdG+48eJNM3Vai-zDpsR71Pn9CPA9uCON84");
          
          rxpkStruct.setTime(sysTime);
          rxpkStruct.setTmms(564654);
          rxpkStruct.setTmst(3512348611);
          rxpkStruct.setChan(2);
          rxpkStruct.setRfch(0);
          rxpkStruct.setFreq(866.349812);
          rxpkStruct.setStat(CrcStatus.OK);
          rxpkStruct.setModu(ModulationIdentifier.LORA);
          rxpkStruct.setDatr(LoraDatarate.SF_7_BW_125);
          rxpkStruct.setDatr(500000);
          rxpkStruct.setCodr(CyclicCodingRate.CR_4_6);
          rxpkStruct.setRssi(-35);
          rxpkStruct.setLsnr(5.1);
          rxpkStruct.setSize(32);
          rxpkStruct.setData(data);
          
          statStruct.setTime(sysTime);
          statStruct.setLatn(46.24000);
          statStruct.setLate(3.25230);
          statStruct.setAlti(145);
          statStruct.setRxnb(2);
          statStruct.setRxok(2);
          statStruct.setRxfw(2);
          statStruct.setAckr(100.0);
          statStruct.setDwnb(2);
          statStruct.setTxnb(2);
          
          rxpkArray ~= rxpkStruct;
          
          JSONValue expectedJsonValue;
          JSONValue[] rxpkPackets = [];
          JSONValue rxpkValue;
          JSONValue statValue;
          
          rxpkValue["time"] = (rxpkStruct.getTime).toISOString();
          rxpkValue["tmms"] = rxpkStruct.getTmms;
          rxpkValue["tmst"] = rxpkStruct.getTmst;
          rxpkValue["freq"] = cast(double)rxpkStruct.getFreq;
          rxpkValue["chan"] = rxpkStruct.getChan;
          rxpkValue["rfch"] = rxpkStruct.getRfch;
          rxpkValue["stat"] = cast(byte)rxpkStruct.getStat;
          rxpkValue["modu"] = rxpkStruct.getModu;
          rxpkValue["datr"] = rxpkStruct.getDatrs;
          rxpkValue["codr"] = rxpkStruct.getCodr;
          rxpkValue["rssi"] = rxpkStruct.getRssi;
          rxpkValue["lsnr"] = cast(float)rxpkStruct.getLsnr;
          rxpkValue["size"] = rxpkStruct.getSize;
          rxpkValue["data"] = (rxpkStruct.getData).getData();
          
          rxpkPackets ~= rxpkValue;
          
          statValue["time"] = (statStruct.getTime).toISOExtString();
          statValue["latn"] = cast(double)statStruct.getLatn;
          statValue["late"] = cast(double)statStruct.getLate;
          statValue["alti"] = statStruct.getAlti;
          statValue["rxnb"] = statStruct.getRxnb;
          statValue["rxok"] = statStruct.getRxok;
          statValue["rxfw"] = statStruct.getRxfw;
          statValue["ackr"] = cast(double)statStruct.getAckr;
          statValue["dwnb"] = statStruct.getDwnb;
          statValue["txnb"] = statStruct.getTxnb;
          
          expectedJsonValue["rxpk"] = rxpkPackets;
          expectedJsonValue["stat"] = statValue;
          
          pushDataPacket.setProtocolVersion(ProtocolVersion.VERSION_2);
          pushDataPacket.setToken(randomToken);
          pushDataPacket.setGatewayID(gatewayID);
          pushDataPacket.setRxpkArray(rxpkArray);
          pushDataPacket.setStatStruct(statStruct);
  
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.PUSH_DATA ~ gatewayID ~ cast(ubyte[]) toJSON(expectedJsonValue);
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pushDataPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                packetData.shouldEqual(expected);
              });
          });
      });
  });
  
  scenario!("Transformation default PUSH_DATA packet to an array of bytes", ["gateway"])
  ({
      given!"default PUSH_DATA packet"
      ({
          PushDataPacket pushDataPacket = new PushDataPacket;
          
          ubyte[2] randomToken = [0, 0];
          GatewayID gatewayID = [0, 0, 0, 0, 0, 0, 0, 0];
          
          string jsonString = `{"rxpk" : [{
            "stat":1,
            "modu":"LORA",
            "datr":"SF6BW125",
            "codr":"4/5"
          }]}`;
          JSONValue expectedJsonValue = parseJSON(jsonString);
  
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.PUSH_DATA ~ gatewayID ~ cast(ubyte[]) toJSON(expectedJsonValue);
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pushDataPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                packetData.shouldEqual(expected);
              });
          });
      });
  });  
  
  scenario!("Set empty rxpk array when stat struct is not empty", ["gateway"])
  ({
      given!"PUSH_DATA packet with not empty stat struct and empty rxpk array"
      ({
          PushDataPacket pushDataPacket = new PushDataPacket;
          
          Stat statStruct;
          
          SysTime sysTime = SysTime(DateTime(2017, 6, 3, 22, 22, 52), hnsecs(45), UTC());
          
          statStruct.setTime(sysTime);
          statStruct.setLatn(46.24000);
          statStruct.setLate(3.25230);
          statStruct.setAlti(145);
          statStruct.setRxnb(2);
          statStruct.setRxok(2);
          statStruct.setRxfw(2);
          statStruct.setAckr(100.0);
          statStruct.setDwnb(2);
          statStruct.setTxnb(2);
          
          Rxpk[] rxpkArray = [];
          
          pushDataPacket.setStatStruct(statStruct);
           
          when!"Function 'setRxpkArray' is called"
          ({
              bool result = pushDataPacket.setRxpkArray(rxpkArray);
              
              then!"Result of 'set' operation is true"
              ({
                result.shouldBeTrue();
              });
          });
      });
  });
  
  scenario!("Set empty rxpk array when stat struct is empty too", ["gateway"])
  ({
      given!"default PUSH_DATA packet and empty rxpk array"
      ({
          PushDataPacket pushDataPacket = new PushDataPacket;
          Rxpk[] rxpkArray = [];
          
          when!"Function 'setRxpkArray' is called"
          ({
              bool result = pushDataPacket.setRxpkArray(rxpkArray);
              
              then!"Result of 'set' operation is false"
              ({
                result.shouldBeFalse();
              });
          });
      });
  });
  
  scenario!("Set empty stat structure when rxpk array is not empty", ["gateway"])
  ({
      given!"PUSH_DATA packet with not empty rxpk array and empty stat structure"
      ({
          PushDataPacket pushDataPacket = new PushDataPacket;
          Stat statStruct;
           
          when!"Function 'setStatStruct' is called"
          ({
              bool result = pushDataPacket.setStatStruct(statStruct);
              
              then!"Result of 'set' operation is true"
              ({
                result.shouldBeTrue();
              });
          });
      });
  });
  
  scenario!("Set empty stat structure when rxpk array is empty too", ["gateway"])
  ({
      given!"PUSH_DATA packet with empty rxpk array and empty stat structure"
      ({
          PushDataPacket pushDataPacket = new PushDataPacket;
          Stat statStruct;
          
          SysTime sysTime = SysTime(DateTime(2017, 6, 3, 22, 22, 52), hnsecs(45), UTC());
          
          statStruct.setTime(sysTime);
          statStruct.setLatn(46.24000);
          statStruct.setLate(3.25230);
          statStruct.setAlti(145);
          statStruct.setRxnb(2);
          statStruct.setRxok(2);
          statStruct.setRxfw(2);
          statStruct.setAckr(100.0);
          statStruct.setDwnb(2);
          statStruct.setTxnb(2);
          
          Rxpk[] rxpkArray = [];
          
          pushDataPacket.setStatStruct(statStruct);
          pushDataPacket.setRxpkArray(rxpkArray);
          // Now rxpk array is empty...
          
          Stat emptyStatStruct;
           
          when!"Function 'setStatStruct' is called"
          ({
              bool result = pushDataPacket.setStatStruct(emptyStatStruct);
              
              then!"Result of 'set' operation is false"
              ({
                result.shouldBeFalse();
              });
          });
      });
  });
  
  scenario!("Transformation PUSH_DATA packet in FSK mode to an array of bytes", ["gateway"])
  ({
      given!"PUSH_DATA packet in FSK mode"
      ({ 
          PushDataPacket pushDataPacket = new PushDataPacket;
          Rxpk rxpkStruct;
          
          rxpkStruct.setModu(ModulationIdentifier.FSK);
          rxpkStruct.setDatr(LoraDatarate.SF_7_BW_125);
          rxpkStruct.setDatr(500000);
          
          JSONValue expectedJsonValue;
          JSONValue[] rxpkPackets = [];
          JSONValue rxpkValue;
          
          rxpkValue["modu"] = rxpkStruct.getModu;
          rxpkValue["datr"] = rxpkStruct.getDatrn;
          rxpkValue["stat"] = cast(byte) CrcStatus.OK;
          rxpkValue["codr"] = CyclicCodingRate.CR_4_5;
          
          rxpkPackets ~= rxpkValue;
          
          expectedJsonValue["rxpk"] = rxpkPackets;
          
          pushDataPacket.setRxpkArray([rxpkStruct]);
  
          ubyte[] expected = ProtocolVersion.VERSION_2 ~ cast(ubyte[]) [0, 0] ~ PacketType.PUSH_DATA ~ cast(ubyte[]) [0, 0, 0, 0, 0, 0, 0, 0] ~ cast(ubyte[]) toJSON(expectedJsonValue);
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] packetData = pushDataPacket.toByteArray();
              
              then!"Get the correct byte array"
              ({
                packetData.shouldEqual(expected);
              });
          });
      });
  });
  
  scenario!("Set not UTC time for rxpk structure", ["gateway"])
  ({
      given!"rxpk structure and no UTC time value"
      ({ 
          Rxpk rxpkStruct;
          SysTime sysTime = SysTime(DateTime(2017, 6, 3, 22, 22, 52));
          sysTime.timezone(PosixTimeZone.getTimeZone("Africa/Freetown"));
                    
          when!"Function 'setTime' is called"
          ({  
              then!"Get throw with message"
              ({
                  (rxpkStruct.setTime(sysTime)).shouldThrowWithMessage("'time' should be in UTC format, not in 'Africa/Freetown'");
              });
          });
      });
  });
  
  scenario!("Set not UTC time for stat structure", ["gateway"])
  ({
      given!"stat structure and no UTC time value"
      ({ 
          Stat statStruct;
          SysTime sysTime = SysTime(DateTime(2017, 6, 3, 22, 22, 52));
          sysTime.timezone(PosixTimeZone.getTimeZone("Africa/Freetown"));
                    
          when!"Function 'setTime' is called"
          ({  
              then!"Get throw with message"
              ({
                  (statStruct.setTime(sysTime)).shouldThrowWithMessage("'time' should be in UTC format, not in 'Africa/Freetown'");
              });
          });
      });
  });
    
  scenario!("Transformation an array of bytes that represending the PUSH_DATA packet correctly into PUSH_DATA packet", ["gateway"])
  ({
      given!"Array of bytes that represending the PUSH_DATA packet correctly"
      ({
          PushDataPacket expected = new PushDataPacket;
          
          ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
          GatewayID gatewayID = [1, 2, 3, 4, 5, 6, 7, 8];
          Rxpk[] rxpkArray = [];
          Stat statStruct;
          
          Rxpk rxpkStruct;
          
          SysTime sysTime = SysTime(DateTime(2017, 6, 3, 22, 22, 52), hnsecs(45), UTC());
          MacPacket data = new MacPacket;
          data.setData("-DS4CGaDCdG+48eJNM3Vai-zDpsR71Pn9CPA9uCON84");
          
          rxpkStruct.setTime(sysTime);
          rxpkStruct.setTmms(ulong.max);
          rxpkStruct.setTmst(3512348611);
          rxpkStruct.setChan(2);
          rxpkStruct.setRfch(0);
          rxpkStruct.setFreq(866.349812);
          rxpkStruct.setStat(CrcStatus.OK);
          rxpkStruct.setModu(ModulationIdentifier.LORA);
          rxpkStruct.setDatr(LoraDatarate.SF_7_BW_125);
          rxpkStruct.setCodr(CyclicCodingRate.CR_4_6);
          rxpkStruct.setRssi(-35);
          rxpkStruct.setLsnr(5.1);
          rxpkStruct.setSize(32);
          rxpkStruct.setData(data);
          
          statStruct.setTime(sysTime);
          statStruct.setLatn(46.24000);
          statStruct.setLate(3.25230);
          statStruct.setAlti(145);
          statStruct.setRxnb(2);
          statStruct.setRxok(2);
          statStruct.setRxfw(2);
          statStruct.setAckr(100.0);
          statStruct.setDwnb(2);
          statStruct.setTxnb(2);
          
          rxpkArray ~= rxpkStruct;
          
          expected.setProtocolVersion(ProtocolVersion.VERSION_2);
          expected.setToken(randomToken);
          expected.setGatewayID(gatewayID);
          expected.setRxpkArray(rxpkArray);
          expected.setStatStruct(statStruct);
          
          ubyte[] pushDataArray = expected.toByteArray;
          
          when!"Function 'parse' is called"
          ({
              auto pushDataPacket = Lora.parse(pushDataArray);
              
              then!"Get the correct PUSH_DATA packet"
              ({
                  pushDataPacket.shouldNotBeNull();
                  pushDataPacket.shouldBeInstanceOf!PushDataPacket();
                  
                  PushDataPacket gotPushDataPacket = cast(PushDataPacket)pushDataPacket;
                  
                  (gotPushDataPacket.getGatewayID).shouldEqual(expected.getGatewayID);
                  (gotPushDataPacket.getStatStruct).shouldEqual(expected.getStatStruct);
                  (gotPushDataPacket.getProtocolVersion).shouldEqual(expected.getProtocolVersion);
                  (gotPushDataPacket.getToken).shouldEqual(expected.getToken);
                  (gotPushDataPacket.getPacketType).shouldEqual(expected.getPacketType);
                  (gotPushDataPacket.getRxpkArray).shouldEqual(expected.getRxpkArray);
              });
          });
      });
  });

  scenario!("Transformation an array of bytes that represending the PUSH_DATA packet uncorrectly into PUSH_DATA packet", ["gateway"])
  ({
      given!"Arrays of bytes that represending the PUSH_DATA packet uncorrectly"
      ({  
          // incorrect packet type (forth byte should equal 0)
          ubyte[] incorrectPushDataArray1 = [2, uniform!ubyte, uniform!ubyte, 1, 1, 2, 3, 4, 5, 6, 7, 8, 99];
          // incorrect protocol version (first byte should equal 2)
          ubyte[] incorrectPushDataArray2 = [1, uniform!ubyte, uniform!ubyte, 0, 1, 2, 3, 4, 5, 6, 7, 8, 99];
          // incorrect array length (array length should be more than '12')
          ubyte[] incorrectPushDataArray3 = [1, uniform!ubyte, uniform!ubyte, 0, 1, 2, 3, 4, 5, 6, 7, 8];
          
          //json object should not be null!
          string incorrectJsonString1 = ``;
          //json object should contain at least on of this: "rxpk array" or "stat structure"!
          string incorrectJsonString2 = `{"test" : 1}`;
          //field "stat" of json object should have "OBJECT" type, not "ARRAY"!
          string incorrectJsonString3 = `{"stat" : [1, 2, 3]}`;
          //field "time" of stat structure should have "STRING" type, not "ARRAY"!
          string incorrectJsonString4 = `{"stat" : {"time" : [1, 2, 3]}}`;
          //field "rxpk" of json object should have "ARRAY" type, not "INTEGER"!
          string incorrectJsonString5 = `{"rxpk" : 99}`;     
          //rxpk array should contain elements only with "OBJECT" type, not "INTEGER"!
          string incorrectJsonString6 = `{"rxpk" : [1, 2, 3]}`;   
          //field "stat" of rxpk structure should have "INTEGER" type, not "STRING"!
          string incorrectJsonString7 = `{"rxpk" : [{"stat" : "hello"}]}`;
          //field "stat" of rxpk structure should have one of this values: "1", "0" or "-1", not "2"!
          string incorrectJsonString8 = `{"rxpk" : [{"stat" : 2}]}`;
          //rxpk structure from json object should have field "stat"!
          string incorrectJsonString9 = `{"rxpk" : [{}]}`;
          //field "modu" of rxpk structure should have "STRING" type, not "INTEGER"!
          string incorrectJsonString10 = `{"rxpk" : [{"stat" : 1, "modu" : 99}]}`;
          //field "modu" of rxpk structure should have one of this values: "LORA" or "FSK", not "hello"!
          string incorrectJsonString11 = `{"rxpk" : [{"stat" : 1, "modu" : "hello"}]}`;          
          //rxpk structure from json object should have field "modu"!
          string incorrectJsonString12 = `{"rxpk" : [{"stat" : 1}]}`;   
          //field "datr" of rxpk structure in "LORA" mode should have "STRING" type, not "INTEGER"!
          string incorrectJsonString13 = `{"rxpk" : [{"stat" : 1, "modu" : "LORA", "datr" : 99}]}`; 
          /*field "datr" of rxpk structure from json object in "LORA" mode should have
           *"SF" value from 6 to 12 and one of this "BW" value: "125", "250" or "500"
           *(for example: "SF11BW250"), not "hello"
           */
          string incorrectJsonString14 = `{"rxpk" : [{"stat" : 1, "modu" : "LORA", "datr" : "hello"}]}`;
          //rxpk structure from json object should have field "datr"!
          string incorrectJsonString15 = `{"rxpk" : [{"stat" : 1, "modu" : "LORA"}]}`;
          //field "codr" of rxpk structure should have "STRING" type, not "INTEGER"!
          string incorrectJsonString16 = `{"rxpk" : [{"stat" : 1, "modu" : "LORA", "datr" : "SF12BW500", "codr" : 99}]}`;
          //field "codr" of rxpk structure should have one of this values: "4/5", "4/6", "4/7" or "4/8", not "hello"!
          string incorrectJsonString17 = `{"rxpk" : [{"stat" : 1, "modu" : "LORA", "datr" : "SF12BW500", "codr" : "hello"}]}`;          
          //rxpk structure from json object should have field "codr"!
          string incorrectJsonString18 = `{"rxpk" : [{"stat" : 1, "modu" : "LORA", "datr" : "SF12BW500"}]}`;
          //field "datr" of rxpk structure in "FSK" mode should have "UINTEGER" type, not "STRING"!
          string incorrectJsonString19 = `{"rxpk" : [{"stat" : 1, "codr" : "4/6", "modu" : "FSK", "datr" : "hello"}]}`;
          //field "time" of rxpk structure should have "STRING" type, not "INTEGER"!
          string incorrectJsonString20 = `{"rxpk" : [{"stat" : 1, "modu" : "LORA", "datr" : "SF12BW500", "codr" : "4/6", "time" : 99}]}`;
          //field "data" of rxpk structure should have "STRING" type, not "INTEGER"!
          string incorrectJsonString21 = `{"rxpk" : [{"stat" : 1, "modu" : "LORA", "datr" : "SF12BW500", "codr" : "4/6", "data" : 99}]}`;
          //json object should contain one of this: not empty stat structure or not empty rxpk array!
          string incorrectJsonString22 = `{"rxpk" : [], "stat" : {}}`;
          //field "lsnr" of rxpk structure should have "FLOAT" type, not "STRING"!
          string incorrectJsonString23 = `{"rxpk" : [{"stat" : 1, "modu" : "LORA", "datr" : "SF12BW500", "codr" : "4/6", "lsnr" : "hello"}]}`;
          
          ubyte[] getIncorrectPushDataArrayWithJson(string incorrectJsonString)
          {
            JSONValue incorrectJsonValue = parseJSON(incorrectJsonString);
            ubyte[] incorrectByteArray = cast(ubyte[]) toJSON(incorrectJsonValue);
            ubyte[] notJsonPart = cast(ubyte[]) [2, uniform!ubyte, uniform!ubyte, 0, 1, 2, 3, 4, 5, 6, 7, 8];
            ubyte[] incorrectPushDataArrayWithJson = notJsonPart ~ incorrectByteArray;
            return incorrectPushDataArrayWithJson;
          }
               
          ubyte[] incorrectPushDataArrayWithJson1 = getIncorrectPushDataArrayWithJson(incorrectJsonString1);
          ubyte[] incorrectPushDataArrayWithJson2 = getIncorrectPushDataArrayWithJson(incorrectJsonString2);
          ubyte[] incorrectPushDataArrayWithJson3 = getIncorrectPushDataArrayWithJson(incorrectJsonString3);
          ubyte[] incorrectPushDataArrayWithJson4 = getIncorrectPushDataArrayWithJson(incorrectJsonString4);
          ubyte[] incorrectPushDataArrayWithJson5 = getIncorrectPushDataArrayWithJson(incorrectJsonString5);
          ubyte[] incorrectPushDataArrayWithJson6 = getIncorrectPushDataArrayWithJson(incorrectJsonString6);
          ubyte[] incorrectPushDataArrayWithJson7 = getIncorrectPushDataArrayWithJson(incorrectJsonString7);
          ubyte[] incorrectPushDataArrayWithJson8 = getIncorrectPushDataArrayWithJson(incorrectJsonString8);
          ubyte[] incorrectPushDataArrayWithJson9 = getIncorrectPushDataArrayWithJson(incorrectJsonString9);
          ubyte[] incorrectPushDataArrayWithJson10 = getIncorrectPushDataArrayWithJson(incorrectJsonString10);
          ubyte[] incorrectPushDataArrayWithJson11 = getIncorrectPushDataArrayWithJson(incorrectJsonString11);
          ubyte[] incorrectPushDataArrayWithJson12 = getIncorrectPushDataArrayWithJson(incorrectJsonString12);
          ubyte[] incorrectPushDataArrayWithJson13 = getIncorrectPushDataArrayWithJson(incorrectJsonString13);
          ubyte[] incorrectPushDataArrayWithJson14 = getIncorrectPushDataArrayWithJson(incorrectJsonString14);
          ubyte[] incorrectPushDataArrayWithJson15 = getIncorrectPushDataArrayWithJson(incorrectJsonString15);
          ubyte[] incorrectPushDataArrayWithJson16 = getIncorrectPushDataArrayWithJson(incorrectJsonString16);
          ubyte[] incorrectPushDataArrayWithJson17 = getIncorrectPushDataArrayWithJson(incorrectJsonString17);
          ubyte[] incorrectPushDataArrayWithJson18 = getIncorrectPushDataArrayWithJson(incorrectJsonString18);
          ubyte[] incorrectPushDataArrayWithJson19 = getIncorrectPushDataArrayWithJson(incorrectJsonString19);
          ubyte[] incorrectPushDataArrayWithJson20 = getIncorrectPushDataArrayWithJson(incorrectJsonString20);
          ubyte[] incorrectPushDataArrayWithJson21 = getIncorrectPushDataArrayWithJson(incorrectJsonString21);
          ubyte[] incorrectPushDataArrayWithJson22 = getIncorrectPushDataArrayWithJson(incorrectJsonString22);
          ubyte[] incorrectPushDataArrayWithJson23 = getIncorrectPushDataArrayWithJson(incorrectJsonString23);
          
          when!"Function 'parse' is called"
          ({
              auto pushDataPacket1 = Lora.parse(incorrectPushDataArray1);
              auto pushDataPacket2 = Lora.parse(incorrectPushDataArray2);
              auto pushDataPacket3 = Lora.parse(incorrectPushDataArray3);
              
              then!"Get a return value different from the PUSH_DATA packet or exception message"
              ({
                  pushDataPacket1.shouldBeNull();
                  pushDataPacket2.shouldBeNull();
                  pushDataPacket3.shouldBeNull();
                  
                  (Lora.parse(incorrectPushDataArrayWithJson1)).shouldThrowWithMessage("byte array should contain " ~ 
                    "json object, but recieved array contain only \"null\" json object!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson2)).shouldThrowWithMessage("json object should contain at " ~ 
                    "least on of this: \"rxpk array\" or \"stat structure\"!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson3)).shouldThrowWithMessage("field \"stat\" of json object " ~
                    "should have \"OBJECT\" type, but it have \"ARRAY\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson4)).shouldThrowWithMessage("field \"time\" of stat structure " ~
                    "from json object should have \"STRING\" type, but it have \"ARRAY\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson5)).shouldThrowWithMessage("field \"rxpk\" of json object " ~
                    "should have \"ARRAY\" type, but it have \"INTEGER\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson6)).shouldThrowWithMessage("rxpk array should can only " ~
                    "contain elements with \"OBJECT\" type, but it have element with \"INTEGER\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson7)).shouldThrowWithMessage("field \"stat\" of rxpk structure " ~
                    "from json object should have \"INTEGER\" type, but it have \"STRING\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson8)).shouldThrowWithMessage("field \"stat\" of rxpk structure " ~
                    "from json object should have one of this values: \"1\", \"-1\" or \"0\", but it has the value \"2\"");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson9)).shouldThrowWithMessage("rxpk structure from json object " ~
                    "should have field \"stat\"!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson10)).shouldThrowWithMessage("field \"modu\" of rxpk structure " ~
                    "from json object should have \"STRING\" type, but it have \"INTEGER\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson11)).shouldThrowWithMessage("field \"modu\" of rxpk structure " ~
                    "from json object should have one of this values: \"LORA\" or \"FSK\", but it has the value \"hello\"");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson12)).shouldThrowWithMessage("rxpk structure from json object " ~
                    "should have field \"modu\"!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson13)).shouldThrowWithMessage("field \"datr\" of rxpk structure " ~
                    "from json object in \"LORA\" mode should have \"STRING\" type, but it have \"INTEGER\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson14)).shouldThrowWithMessage("field \"datr\" of rxpk structure " ~
                    "from json object should have one of this values: \"SF6BW125\", \"SF6BW250\", \"SF6BW500\", \"SF7BW125\"," ~
                    " \"SF7BW250\", \"SF7BW500\", \"SF8BW125\", \"SF8BW250\", \"SF8BW500\", \"SF9BW125\", \"SF9BW250\", " ~
                    "\"SF9BW500\", \"SF10BW125\", \"SF10BW250\", \"SF10BW500\", \"SF11BW125\", \"SF11BW250\", \"SF11BW500\"," ~
                    " \"SF12BW125\", \"SF12BW250\" or \"SF12BW500\", but it has the value \"hello\"");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson15)).shouldThrowWithMessage("rxpk structure from json object in " ~
                    "\"LORA\" mode should have field \"datr\"!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson16)).shouldThrowWithMessage("field \"codr\" of rxpk structure " ~
                    "from json object should have \"STRING\" type, but it have \"INTEGER\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson17)).shouldThrowWithMessage("field \"codr\" of rxpk structure " ~
                    "from json object should have one of this values: \"4/5\", \"4/6\", \"4/7\" or \"4/8\", but it has the " ~
                    "value \"hello\"");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson18)).shouldThrowWithMessage("rxpk structure from json object " ~
                    "should have field \"codr\"!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson19)).shouldThrowWithMessage("field \"datr\" of rxpk structure " ~
                    "from json object in \"FSK\" mode should have \"UINTEGER\" type, but it have \"STRING\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson20)).shouldThrowWithMessage("field \"time\" of rxpk structure " ~
                    "from json object should have \"STRING\" type, but it have \"INTEGER\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson21)).shouldThrowWithMessage("field \"data\" of rxpk structure " ~
                    "from json object should have \"STRING\" type, but it have \"INTEGER\" type!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson22)).shouldThrowWithMessage("json object should contain one of " ~
                    "this: \"not empty stat structure\" or \"not empty rxpk array\"!");
                  
                  (Lora.parse(incorrectPushDataArrayWithJson23)).shouldThrowWithMessage("field \"lsnr\" of rxpk structure " ~
                    "from json object should have \"FLOAT\" type, but it have \"STRING\" type!");
              });
          });
      });
  });
  
  scenario!("Transformation an arrays of bytes that represending the PUSH_DATA packet correctly and have different " ~
    "CRC status into PUSH_DATA packet", ["gateway"])
  ({
      given!"Array of bytes that represending the PUSH_DATA packet correctly and have different CRC status"
      ({
          when!"Function 'parse' is called"
          ({
              then!"Get the correct PUSH_DATA packet"
              ({
                  void verifyTheCorrectnessOfParsingForDifferentValue(CrcStatus crcStatus)
                  {
                    PushDataPacket expected = new PushDataPacket;
                    Rxpk rxpkStruct;
                    rxpkStruct.setStat(crcStatus);
                    expected.setRxpkArray([rxpkStruct]);
                    ubyte[] pushDataArray = expected.toByteArray;
                    auto pushDataPacket = Lora.parse(pushDataArray);
                    pushDataPacket.shouldNotBeNull();
                    pushDataPacket.shouldBeInstanceOf!PushDataPacket();
                    PushDataPacket gotPushDataPacket = cast(PushDataPacket)pushDataPacket;
                    gotPushDataPacket.shouldEqual(expected);
                  }
                  
                  verifyTheCorrectnessOfParsingForDifferentValue(CrcStatus.OK);
                  verifyTheCorrectnessOfParsingForDifferentValue(CrcStatus.FAIL);
                  verifyTheCorrectnessOfParsingForDifferentValue(CrcStatus.NO_CRC);
              });
          });
      });
  });
  
  scenario!("Transformation an arrays of bytes that represending the PUSH_DATA packet correctly and have different " ~
    "datr value in \"LORA\" mode into PUSH_DATA packet", ["gateway"])
  ({
      given!"Array of bytes that represending the PUSH_DATA packet correctly and have datr value in \"LORA\" mode"
      ({  
          when!"Function 'parse' is called"
          ({  
              then!"Get the correct PUSH_DATA packet"
              ({
                  void verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate loraDatarate)
                  {
                    PushDataPacket expected = new PushDataPacket;
                    Rxpk rxpkStruct;
                    rxpkStruct.setModu(ModulationIdentifier.LORA);
                    rxpkStruct.setDatr(loraDatarate);
                    expected.setRxpkArray([rxpkStruct]);
                    ubyte[] pushDataArray = expected.toByteArray;
                    auto pushDataPacket = Lora.parse(pushDataArray);
                    pushDataPacket.shouldNotBeNull();
                    pushDataPacket.shouldBeInstanceOf!PushDataPacket();
                    PushDataPacket gotPushDataPacket = cast(PushDataPacket)pushDataPacket;
                    gotPushDataPacket.shouldEqual(expected);
                  }
                  
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_6_BW_125);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_6_BW_250);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_6_BW_500);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_7_BW_125);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_7_BW_250);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_7_BW_500);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_8_BW_125);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_8_BW_250);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_8_BW_500);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_9_BW_125);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_9_BW_250);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_9_BW_500);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_10_BW_125);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_10_BW_250);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_10_BW_500);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_11_BW_125);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_11_BW_250);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_11_BW_500);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_12_BW_125);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_12_BW_250);
                  verifyTheCorrectnessOfParsingForDifferentValue(LoraDatarate.SF_12_BW_500);
              });
          });
      });
  });
  
  scenario!("Transformation an arrays of bytes that represending the PUSH_DATA packet correctly and have different " ~
    "cyclic coding rate into PUSH_DATA packet", ["gateway"])
  ({
      given!"Array of bytes that represending the PUSH_DATA packet correctly and have different cyclic coding rate"
      ({
          when!"Function 'parse' is called"
          ({
              then!"Get the correct PUSH_DATA packet"
              ({
                  void verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate cyclicCodingRate)
                  {
                    PushDataPacket expected = new PushDataPacket;
                    Rxpk rxpkStruct;
                    rxpkStruct.setCodr(cyclicCodingRate);
                    expected.setRxpkArray([rxpkStruct]);
                    ubyte[] pushDataArray = expected.toByteArray;
                    auto pushDataPacket = Lora.parse(pushDataArray);
                    pushDataPacket.shouldNotBeNull();
                    pushDataPacket.shouldBeInstanceOf!PushDataPacket();
                    PushDataPacket gotPushDataPacket = cast(PushDataPacket)pushDataPacket;
                    gotPushDataPacket.shouldEqual(expected);
                  }
                  
                  verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate.CR_4_5);
                  verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate.CR_4_6);
                  verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate.CR_4_7);
                  verifyTheCorrectnessOfParsingForDifferentValue(CyclicCodingRate.CR_4_8);
              });
          });
      });
  });
  
  scenario!("Transformation an arrays of bytes that represending the PUSH_DATA packet in \"FSK\" mode correctly", ["gateway"])
  ({
      given!"Array of bytes that represending the PUSH_DATA packet in \"FSK\" mode correctly"
      ({
          PushDataPacket expected = new PushDataPacket;
          Rxpk rxpkStruct;
          rxpkStruct.setModu(ModulationIdentifier.FSK);
          rxpkStruct.setDatr(3_294_967_295);
          expected.setRxpkArray([rxpkStruct]);          
          ubyte[] pushDataArray = expected.toByteArray;
          
          when!"Function 'parse' is called"
          ({
              auto pushDataPacket = Lora.parse(pushDataArray);
              
              then!"Get the correct PUSH_DATA packet"
              ({
                  pushDataPacket.shouldNotBeNull();
                  pushDataPacket.shouldBeInstanceOf!PushDataPacket();
                  PushDataPacket gotPushDataPacket = cast(PushDataPacket)pushDataPacket;
                  gotPushDataPacket.shouldEqual(expected);  
              });
          });
      });
  });
}