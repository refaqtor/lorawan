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
          ubyte[8] gatewayID = [1, 2, 3, 4, 5, 6, 7, 8];
          Rxpk[] rxpkArray = [];
          Stat statStruct;
          
          Rxpk rxpkStruct;
          
          SysTime sysTime = SysTime(DateTime(2017, 6, 3, 22, 22, 52), hnsecs(45), UTC());
          MacPacket data = new MacPacket;
          data.setData("-DS4CGaDCdG+48eJNM3Vai-zDpsR71Pn9CPA9uCON84");
          
          rxpkStruct.setTime(sysTime);
          rxpkStruct.setTmms(1232645156);
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
          ubyte[8] gatewayID = [0, 0, 0, 0, 0, 0, 0, 0];
          
          string jsonString = `{"rxpk" : [{
            "stat":1,
            "modu":"LORA",
            "datr":"SF6BW62.5",
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
}