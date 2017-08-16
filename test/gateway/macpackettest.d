module lorawan.test.gateway.macpackettest;

import lorawan.gateway.macpacket;
import lorawan.gateway.lorawantypes;
import checkit;
import std.base64;
import lorawan.utils.cryptohelper;
import std.conv;

unittest
{
  scenario!("Transformation mac packet (downlink) to an array of bytes", ["gateway"])
  ({
      given!"mac packet"
      ({
          MHDR mhdr;
          mhdr.setMType(MACMessageType.CONFIRMED_DATA_DOWN);
          mhdr.setRfu(0b00000111);
          mhdr.setMajor(0b00000011);
          
          Downlink downlink;
          downlink.setAdr(0xf0);
          downlink.setAdrAckReq(0xf1);
          downlink.setAck(0xf2);
          downlink.setRfu(0xf3);
          
          FCtrl fCtrl;
          fCtrl.setDownlink(downlink);
          
          MACCommand[] fOpts;
          MACCommand macCommand1;
          MACCommand macCommand2;
          macCommand1.setCid(MACCommandCid.RX_PARAM_SETUP_REQ);
          macCommand2.setCid(0x81);
          macCommand2.setArgs([0xff, 0xff, 0xff, 0xff]);
          fOpts ~= macCommand1;
          fOpts ~= macCommand2;
          
          FHDR fhdr;
          fhdr.setDevAddress([0xaa, 0xaa, 0xaa, 0xaa]);
          fhdr.setFCtrl(fCtrl);
          fhdr.setFCnt([0x99, 0x99]);
          fhdr.setFOpts(fOpts);
                    
          MACPayload macPayload;
          macPayload.setFhdr(fhdr);
          macPayload.setFPort(0xff);
          ubyte[16] nwkSKeyCopy = nwkSKey.dup;
          macPayload.setPayload(cast(ubyte[])"hello world!!!", nwkSKeyCopy);
          
          PHYPayload phyPayload;
          phyPayload.setIsDownlink(true);
          phyPayload.setMhdr(mhdr);
          phyPayload.setMacPayload(macPayload);
          phyPayload.recalculateMic(nwkSKey);
          
          ubyte[] expected;
          
          ubyte mhdrByte = 0x00;
          mhdrByte |= (MACMessageType.CONFIRMED_DATA_DOWN & 0b00000111) << 5;
          mhdrByte |= (0b00000111 & 0b00000111) << 2;
          mhdrByte |= 0b00000011 & 0b00000011;
          
          ubyte[] fhdrBytes;
          fhdrBytes ~= [0xaa, 0xaa, 0xaa, 0xaa]; //devAddr
          
          ubyte fCtrlByte = 0x00;
          fCtrlByte |= (0xf0 & 0b00000001) << 7;//adr
          fCtrlByte |= (0xf1 & 0b00000001) << 6;//adrAckReq
          fCtrlByte |= (0xf2 & 0b00000001) << 5;//ack
          fCtrlByte |= (0xf3 & 0b00000001) << 4;//rfu
          fCtrlByte |= 6 & 0b00001111;//foptsLength
          
          fhdrBytes ~= fCtrlByte; //fCtrl
          fhdrBytes ~= [0x99, 0x99]; //fCnt
          fhdrBytes ~= MACCommandCid.RX_PARAM_SETUP_REQ; //first maccommand cid
          fhdrBytes ~= 0x81; //second maccommand cid
          fhdrBytes ~= [0xff, 0xff, 0xff, 0xff]; //second maccommand args
          
          ubyte[] payload = processAES128(true, cast(ubyte[])"hello world!!!", nwkSKeyCopy);
          
          ubyte[4] mic;
          ubyte[] msg = mhdrByte ~ fhdrBytes ~ 0xff ~ payload;
          ubyte[] b0 = [0x49, 0x00, 0x00, 0x00, 0x00];
          b0 ~= 0x01;
          b0 ~= [0xaa, 0xaa, 0xaa, 0xaa]; //devAddr
          b0 ~= [0x99, 0x99]; //fCnt
          b0 ~= 0x00;
          b0 ~= to!ubyte(msg.length);
          ubyte[] mac = processAES128(true, b0 ~ msg, nwkSKey);
          mic = mac[0..4]; //mic
          
          expected ~= mhdrByte; //mhdr
          expected ~= fhdrBytes; //fhdr
          expected ~= 0xff; //fport
          expected ~=  payload;//payload
          expected ~= mic;
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] got = phyPayload.toByteArray;
              then!"Get the correct byte array"
              ({
                  got.shouldEqual(expected);
              });
          });
      });
  });
  
  scenario!("Transformation mac packet (uplink) to an array of bytes", ["gateway"])
  ({
      given!"mac packet"
      ({
          MHDR mhdr;
          mhdr.setMType(MACMessageType.CONFIRMED_DATA_DOWN);
          mhdr.setRfu(0b00000111);
          mhdr.setMajor(0b00000011);
          
          Uplink uplink;
          uplink.setAdr(0xf0);
          uplink.setAdrAckReq(0xf1);
          uplink.setAck(0xf2);
          uplink.setFPending(0xf3);
          
          FCtrl fCtrl;
          fCtrl.setUplink(uplink);
          
          MACCommand[] fOpts;
          MACCommand macCommand1;
          MACCommand macCommand2;
          macCommand1.setCid(MACCommandCid.RX_PARAM_SETUP_REQ);
          macCommand2.setCid(0x81);
          macCommand2.setArgs([0xff, 0xff, 0xff, 0xff]);
          fOpts ~= macCommand1;
          fOpts ~= macCommand2;
          
          FHDR fhdr;
          fhdr.setDevAddress([0xaa, 0xaa, 0xaa, 0xaa]);
          fhdr.setFCtrl(fCtrl);
          fhdr.setFCnt([0x99, 0x99]);
          fhdr.setFOpts(fOpts);
                    
          MACPayload macPayload;
          macPayload.setFhdr(fhdr);
          macPayload.setFPort(0xff);
          ubyte[16] nwkSKeyCopy = nwkSKey.dup;
          macPayload.setPayload(cast(ubyte[])"hello world!!!", nwkSKeyCopy);
          
          PHYPayload phyPayload;
          phyPayload.setIsDownlink(false);
          phyPayload.setMhdr(mhdr);
          phyPayload.setMacPayload(macPayload);
          phyPayload.recalculateMic(nwkSKey);
          
          ubyte[] expected;
          
          ubyte mhdrByte = 0x00;
          mhdrByte |= (MACMessageType.CONFIRMED_DATA_DOWN & 0b00000111) << 5;
          mhdrByte |= (0b00000111 & 0b00000111) << 2;
          mhdrByte |= 0b00000011 & 0b00000011;
          
          ubyte[] fhdrBytes;
          fhdrBytes ~= [0xaa, 0xaa, 0xaa, 0xaa]; //devAddr
          
          ubyte fCtrlByte = 0x00;
          fCtrlByte |= (0xf0 & 0b00000001) << 7;//adr
          fCtrlByte |= (0xf1 & 0b00000001) << 6;//adrAckReq
          fCtrlByte |= (0xf2 & 0b00000001) << 5;//ack
          fCtrlByte |= (0xf3 & 0b00000001) << 4;//fPending
          fCtrlByte |= 6 & 0b00001111;//fOptsLength
          
          fhdrBytes ~= fCtrlByte; //fCtrl
          fhdrBytes ~= [0x99, 0x99]; //fCnt
          fhdrBytes ~= MACCommandCid.RX_PARAM_SETUP_REQ; //first maccommand cid
          fhdrBytes ~= 0x81; //second maccommand cid
          fhdrBytes ~= [0xff, 0xff, 0xff, 0xff]; //second maccommand args
          
          ubyte[] payload = processAES128(true, cast(ubyte[])"hello world!!!", nwkSKeyCopy);
          
          ubyte[4] mic;
          ubyte[] msg = mhdrByte ~ fhdrBytes ~ 0xff ~ payload;
          ubyte[] b0 = [0x49, 0x00, 0x00, 0x00, 0x00];
          b0 ~= 0x00;
          b0 ~= [0xaa, 0xaa, 0xaa, 0xaa]; //devAddr
          b0 ~= [0x99, 0x99]; //fCnt
          b0 ~= 0x00;
          b0 ~= to!ubyte(msg.length);
          ubyte[] mac = processAES128(true, b0 ~ msg, nwkSKey);
          mic = mac[0..4]; //mic
          
          expected ~= mhdrByte; //mhdr
          expected ~= fhdrBytes; //fhdr
          expected ~= 0xff; //fport
          expected ~=  payload;//payload
          expected ~= mic;
          
          when!"Function 'toByteArray' is called"
          ({
              ubyte[] got = phyPayload.toByteArray;
              then!"Get the correct byte array"
              ({
                  got.shouldEqual(expected);
              });
          });
      });
  });  
}