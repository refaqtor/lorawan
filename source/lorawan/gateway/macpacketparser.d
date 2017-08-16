/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.macpacketparser;

import lorawan.gateway.lorawanexception;
import lorawan.gateway.macpacket;

static class MACPacketParser
{
  public:
    static MacPacket parse(ubyte[] macPaketArray)
    {
      ubyte mhdrByte = macPaketArray[0];
      ubyte[] macPayloadArray = macPaketArray[1..$-4];
      ubyte[4] mic = macPaketArray[$-4..$]; //The last four bytes is 'mic'
      
      MHDR mhdr = getMhdr(mhdrByte);
      MACPayload macPayload = getMacPayload(macPayloadArray);
      
      PHYPayload phyPayload;
      phyPayload.setMhdr(mhdr);
      phyPayload.setMacPayload(macPayload);
      phyPayload.setMic(mic);
    }
  
  private:
    MHDR getMhdr(ubyte mhdrByte)
    {
      MHDR mhdr;
      MACMessageType mType;
      ubyte rfu;
      ubyte major;
    
      try
      {
        mType = to!MACMessageType((mhdrByte & 0b11100000) >> 5);
      }
      catch(Exception e)
      {
        throw new LorawanException("Unknown MAC message type!");
      }
      mhdr.setMType(mType);
     
      rfu = (mhdrByte & 0b00011100) >> 2;
      mhdr.setRfu(rfu);
      
      major = mhdrByte & 0b00000011;
      mhdr.setMajor(major);
      
      return mhdr;
    }
     
    MACPayload getMacPayload(ubyte[] macPayloadArray)
    {
      MACPayload macPayload;
      ubyte[4] devAddress = macPayloadArray[0..4];
      ubyte fCtrlByte = macPayloadArray[4];
      ubyte[2] fCnt= macPayloadArray[5..7];
      
      FCtrl fCtrl = getFCtrl(fCtrlByte); 
      fOptsLen = fCtrl.getDownlink().getFOptsLen();
      if(fOptsLen > 15)
      {
        throw new LorawanException("FOpts field can not be more than 15 bytes, but it is equal to " ~
          to!string(fOptsLen) ~ " bytes");
      }
      
      ubyte[] fOptsArray = macPayloadArray[7..7+fOptsLen];
      ubyte fPort = macPayloadArray[7+fOptsLen];
      ubyte[] payload = macPayloadArray[7+fOptsLen + 1..$];
      
      MACCommand[] fOpts = getFOpts(fOptsArray);
      
      FHDR fhdr;
      fhdr.setDevAddress(devAddr);
      fhdr.setFCtrl(fCtrl);
      fhdr.setFCnt(fCnt);
      fhdr.setFOpts(fOpts);
      
      macPayload.setFPort(fPort);
      macPayload.setFhdr(fhdr);
      macPayload.setPayload(payload, nwkSKey);
      
      return macPayload;
    }
    
    FCtrl getFCtrl(ubyte fCtrlByte)
    {
      FCtrl fCtrl;
      Downlink downlink;
      Uplink uplink;

      ubyte adr = (fCtrlByte & 0b10000000) >> 7;
      ubyte adrAckReq = (fCtrlByte & 0b01000000) >> 6;
      ubyte ack = (fCtrlByte & 0b00100000) >> 5;
      ubyte rfu = (fCtrlByte & 0b00010000) >> 4;
      ubyte fPending = rfu;
      ubyte fOptsLen = fCtrlByte & 0b00001111;
      
      downlink.setAdr(adr);
      downlink.setAdrAckReq(adrAckReq);
      downlink.setAck(ack);
      downlink.setRfu(rfu);
      downlink.setFOptsLen(fOptsLen);
      
      uplink.setAdr(adr);
      uplink.setAdrAckReq(adrAckReq);
      uplink.setAck(ack);
      uplink.setFPending(fPending);
      uplink.setFOptsLen(fOptsLen);
      
      fCtrl.setDownlink(downlink);
      fCtrl.setUplink(uplink);
      
      return fCtrl;
    }
    
    MACCommand[] getFOpts(ubyte[] fOptsArray)
    {
      
    }
}