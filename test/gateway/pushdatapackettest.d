module lorawan.test.gateway.pushdatapackettest;

//TODO: remove
import std.stdio;
import std.json;

import lorawan.gateway.pushdatapacket;
import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.lora;
import std.random;

//static bool isEqual(PushAckPacket pushAckPacket1, PushAckPacket pushAckPacket2)
//{
//  if(pushAckPacket1.getProtocolVersion() != pushAckPacket2.getProtocolVersion()){ return false; }
//  if(pushAckPacket1.getToken() != pushAckPacket2.getToken()){ return false; }
//  if(pushAckPacket1.getPacketType() != pushAckPacket2.getPacketType()){ return false; }
//  return true;
//}

unittest
{
  // When we have a PUSH_DATA packet and the function 'toByteArray' is called
  // Then we get the correct byte array
  
  PushDataPacket pushDataPacket = new PushDataPacket;
  
  string jsonString = `{"rxpk":[
	{
		"time":"2013-03-31T16:21:17.528002Z",
		"tmst":3512348611,
		"chan":2,
		"rfch":0,
		"freq":866.349812,
		"stat":1,
		"modu":"LORA",
		"datr":"SF7BW125",
		"codr":"4/6",
		"rssi":-35,
		"lsnr":5.1,
		"size":32,
		"data":"-DS4CGaDCdG+48eJNM3Vai-zDpsR71Pn9CPA9uCON84"
	},{
		"time":"2013-03-31T16:21:17.530974Z",
		"tmst":3512348514,
		"chan":9,
		"rfch":1,
		"freq":869.1,
		"stat":1,
		"modu":"FSK",
		"datr":50000,
		"rssi":-75,
		"size":16,
		"data":"VEVTVF9QQUNLRVRfMTIzNA=="
	}
  ]}`;
  
  ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
  ubyte[8] gatewayID = [1, 2, 3, 4, 5, 6, 7, 8];
  JSONValue jsonObject = parseJSON(jsonString);
  
  pushDataPacket.setProtocolVersion(ProtocolVersion.VERSION_2);
  pushDataPacket.setToken(randomToken);
  pushDataPacket.setGatewayID(gatewayID);
  pushDataPacket.setJsonObject(jsonObject);
  
  ubyte[] pushDataArray = ProtocolVersion.VERSION_2 ~ randomToken ~ PacketType.PUSH_DATA ~ gatewayID ~ cast(ubyte[]) toJSON(jsonObject);
  
  assert(pushDataPacket.toByteArray == pushDataArray);
}

unittest
{
  // When we have a default PUSH_DATA packet and the function 'toByteArray' is called
  // Then we get the correct byte array
  
  PushDataPacket pushDataPacket = new PushDataPacket;
  
  ubyte[] pushDataArray = [2, 0, 0, 0] ~ [0, 0, 0, 0, 0, 0, 0, 0];
  
  assert(pushDataPacket.toByteArray == pushDataArray);
}
//
//unittest
//{
//  // When we have an array of bytes that represending the PUSH_ACK packet correctly and the function 'parse' is called
//  // Then we get the correct PUSH_ACK packet
//  
//  ubyte[2] randomToken = [uniform!ubyte, uniform!ubyte];
//  
//  ubyte[] pushAckArray = 2 ~ randomToken ~ 1;
//  
//  PushAckPacket pushAckPacket1 = new PushAckPacket;
//  
//  pushAckPacket1.setProtocolVersion(ProtocolVersion.VERSION_2);
//  pushAckPacket1.setToken(randomToken);
//      
//  auto pushAckPacket2 = Lora.parse(pushAckArray);
//  
//  assert(cast(PushAckPacket) pushAckPacket2 !is null);
//  assert(isEqual(pushAckPacket1, cast(PushAckPacket) pushAckPacket2));
//}
//
//unittest
//{
//  // When we have an array of bytes that represending the PUSH_ACK packet uncorrectly and the function 'parse' is called
//  // Then we get a return value different from the PUSH_ACK packet
//  
//  // incorrect packet type (forth byte should equal 1)
//  ubyte[] incorrectPushAckArray1 = [2, uniform!ubyte, uniform!ubyte, 2];
//  // incorrect protocol version (first byte should equal 2)
//  ubyte[] incorrectPushAckArray2 = [1, uniform!ubyte, uniform!ubyte, 2];
//  // incorrect array length (array length should equal 4)
//  ubyte[] incorrectPushAckArray3 = [1, 2];
//  
//  auto pushAckPacket1 = Lora.parse(incorrectPushAckArray1);
//  auto pushAckPacket2 = Lora.parse(incorrectPushAckArray2);
//  auto pushAckPacket3 = Lora.parse(incorrectPushAckArray3);
//  
//  assert(pushAckPacket1 is null);
//  assert(pushAckPacket2 is null);
//  assert(pushAckPacket3 is null);
//}