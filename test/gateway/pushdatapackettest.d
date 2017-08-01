module lorawan.test.gateway.pushdatapackettest;

import std.random;
import std.json;

import lorawan.gateway.pushdatapacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.lora;
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
          
          rxpkStruct.setTime("2013-03-31T16:21:17.528002Z");
          rxpkStruct.setTmms(1232645156);
          rxpkStruct.setTmst(3512348611);
          rxpkStruct.setChan(2);
          rxpkStruct.setRfch(0);
          rxpkStruct.setFreq(866.349812);
          rxpkStruct.setStat(CrcStatus.OK);
          rxpkStruct.setModu(ModulationIdentifier.LORA);
          rxpkStruct.setDatrs("SF7BW125");
          rxpkStruct.setDatrn(500000);
          rxpkStruct.setCodr("4/6");
          rxpkStruct.setRssi(-35);
          rxpkStruct.setLsnr(5.1);
          rxpkStruct.setSize(32);
          rxpkStruct.setData("-DS4CGaDCdG+48eJNM3Vai-zDpsR71Pn9CPA9uCON84");
          
          statStruct.setTime("2014-01-12 08:59:28 GMT");
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
          
          rxpkValue["time"] = rxpkStruct.getTime;
          rxpkValue["tmms"] = rxpkStruct.getTmms;
          rxpkValue["tmst"] = rxpkStruct.getTmst;
          rxpkValue["freq"] = cast(double)rxpkStruct.getFreq;
          rxpkValue["chan"] = rxpkStruct.getChan;
          rxpkValue["rfch"] = rxpkStruct.getRfch;
          rxpkValue["stat"] = cast(byte)rxpkStruct.getStat;
          rxpkValue["modu"] = rxpkStruct.getModu;
          rxpkValue["datrs"] = rxpkStruct.getDatrs;
          rxpkValue["datrn"] = rxpkStruct.getDatrn;
          rxpkValue["codr"] = rxpkStruct.getCodr;
          rxpkValue["rssi"] = rxpkStruct.getRssi;
          rxpkValue["lsnr"] = cast(float)rxpkStruct.getLsnr;
          rxpkValue["size"] = rxpkStruct.getSize;
          rxpkValue["data"] = rxpkStruct.getData;
          
          rxpkPackets ~= rxpkValue;
          
          statValue["time"] = statStruct.getTime;
          statValue["latn"] = cast(float)statStruct.getLatn;
          statValue["late"] = cast(float)statStruct.getLate;
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
            "modu":"LORA"
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
}