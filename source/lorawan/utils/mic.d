/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.utils.mic;

import lorawan.gateway.macpacket;
import lorawan.utils.cryptohelper;
import std.conv;

static ubyte[4] calculateMic(PHYPayload payload, ubyte[16] nwkSKey)
{
  bool isDownlink = payload.getIsDownlink();
   
  ubyte[] msg = payload.getMhdr.toByteArray ~ payload.getMacPayload.getFhdr.toByteArray(isDownlink) ~
  payload.getMacPayload.getFPort ~ payload.getMacPayload.getPayload;
  
  ubyte[] b0 = [0x49, 0x00, 0x00, 0x00, 0x00];
  isDownlink ? b0 ~= 0x01 : b0 ~= 0x00;
  b0 ~= payload.getMacPayload.getFhdr.getDevAddress;
  b0 ~= payload.getMacPayload.getFhdr.getFCnt;
  b0 ~= 0x00;
  b0 ~= to!ubyte(msg.length);
    
  ubyte[] mac = processAES128(true, b0 ~ msg, nwkSKey);
    
  ubyte[4] mic = mac[0..4];
  
  return mic;
}

static bool verifyMic(PHYPayload payload, ubyte[16] nwkSKey)
{
  ubyte[4] mic = payload.getMic;
  ubyte[4] calculatedMic = calculateMic(payload, nwkSKey);
  return (mic == calculatedMic);
}