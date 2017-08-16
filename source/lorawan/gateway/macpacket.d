/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.macpacket;

import lorawan.gateway.lorawantypes;
import lorawan.utils.cryptohelper;
import lorawan.utils.mic;
import std.conv;

static immutable ubyte[16] nwkSKey = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

struct PHYPayload //TODO: add docs
{
  public:
    ubyte[] toByteArray()
    {
      ubyte[] result;
      result ~= _mhdr.toByteArray();
      result ~= _macPayload.toByteArray(_isDownlink);
      recalculateMic(nwkSKey);
      result ~= _mic;
      return result;
    }
    
    bool getIsDownlink(){ return _isDownlink; }
    void setIsDownlink(bool isDownlink){ _isDownlink = isDownlink; }
    
    MHDR getMhdr(){ return _mhdr; }
    void setMhdr(MHDR mhdr){ _mhdr = mhdr; }
    
    MACPayload getMacPayload(){ return _macPayload; }
    void setMacPayload(MACPayload macPayload){ _macPayload = macPayload; }
    
    ubyte[4] getMic(){ return _mic; }
    void recalculateMic(ubyte[16] nwkSKey){ _mic = calculateMic(this, nwkSKey); }//TODO: add param nwkSKey
    
  private:
    bool _isDownlink;
    MHDR _mhdr;
    MACPayload _macPayload;
    ubyte[4] _mic;
}

struct MHDR //TODO: add docs
{
  public:
    ubyte[] toByteArray()
    {
      ubyte result = 0b00000000;
      result |= (_mType & 0b00000111) << 5;
      result |= (_rfu & 0b00000111) << 2;
      result |= _major & 0b00000011;
      return [result];
    }
    
    MACMessageType getMType(){ return _mType; }
    void setMType(MACMessageType mType){ _mType = mType; }
    
    ubyte getRfu(){ return _rfu; }
    void setRfu(ubyte rfu){ _rfu = rfu; }
    
    ubyte getMajor(){ return _major; }
    void setMajor(ubyte major){ _major = major; }
  
  private:
    MACMessageType _mType;
    ubyte _rfu;
    ubyte _major;
}

struct MACPayload
{
  public:
    ubyte[] toByteArray(bool isDownlink)
    {
      ubyte[] result;
      result ~= _fhdr.toByteArray(isDownlink);
      result ~= _fPort;
      result ~= _payload;
      return result;
    }
    
    FHDR getFhdr(){ return _fhdr; }
    void setFhdr(FHDR fhdr){ _fhdr = fhdr; }
    
    ubyte getFPort(){ return _fPort; }
    void setFPort(ubyte fPort){ _fPort = fPort; }
    
    ubyte[] getPayload(){ return _payload; }
    void setPayload(ubyte[] payload, ubyte[16] nwkSKey)
    { 
      _payload = processAES128(true, payload, nwkSKey);
    }    
      
  private:
    FHDR _fhdr;
    ubyte _fPort;
    ubyte[] _payload;
}

struct FHDR
{
  public:
    ubyte[] toByteArray(bool isDownlink)
    {
      ubyte[] result;
      
      ubyte fOptsLength = 0;
      ubyte[] fOpts;
      foreach(MACCommand macCommand; _fOpts)
      {
        fOptsLength += macCommand.toByteArray.length;
        fOpts ~= macCommand.toByteArray;
      }
      _fCtrl.getDownlink().setFOptsLen(fOptsLength);
      _fCtrl.getUplink().setFOptsLen(fOptsLength);
      
      result ~= _devAddr;
      result ~= _fCtrl.toByteArray(isDownlink);
      result ~= _fCnt;
      result ~= fOpts;
      return result;
    }
    
    ubyte[4] getDevAddress(){ return _devAddr; }
    void setDevAddress(ubyte[4] devAddr){ _devAddr = devAddr; }
    
    FCtrl getFCtrl(){ return _fCtrl; }
    void setFCtrl(FCtrl fCtrl){ _fCtrl = fCtrl; }
    
    ubyte[2] getFCnt(){ return _fCnt; }
    void setFCnt(ubyte[2] fCnt){ _fCnt = fCnt; }
    
    MACCommand[] getFOpts(){ return _fOpts; }
    void setFOpts(MACCommand[] fOpts)
    in
    {
      ubyte fOptsLength = 0;
      foreach(MACCommand macCommand; fOpts)
      {
        fOptsLength += macCommand.toByteArray().length;
      }
      assert(fOptsLength <= 15);
    }
    body
    {
      _fOpts = fOpts; 
      ubyte fOptsLength = 0;
      foreach(MACCommand macCommand; _fOpts)
      {
        fOptsLength += macCommand.toByteArray.length;
      }
      Downlink downlink = _fCtrl.getDownlink();
      downlink.setFOptsLen(fOptsLength);
      _fCtrl.setDownlink(downlink);
      
      Uplink uplink = _fCtrl.getUplink();
      uplink.setFOptsLen(fOptsLength);
      _fCtrl.setUplink(uplink);
    }
  
  private:
    ubyte[4] _devAddr;
    FCtrl _fCtrl;
    ubyte[2] _fCnt;
    MACCommand[] _fOpts;
}

struct FCtrl
{
  public: 
    ubyte[] toByteArray(bool isDownlink)
    {
      ubyte[] result;
      isDownlink ? (result = _downlink.toByteArray) : (result = _uplink.toByteArray);
      return result;
    }
    
    Downlink getDownlink(){ return _downlink; }
    void setDownlink(Downlink downlink){ _downlink = downlink; }
    
    Uplink getUplink(){ return _uplink; }
    void setUplink(Uplink uplink){ _uplink = uplink; }
  
  private:
    Downlink _downlink;
    Uplink _uplink;
}

struct Downlink
{
  public:
    ubyte[] toByteArray()
    {
      ubyte result;
      result |= (_adr & 0b00000001) << 7;
      result |= (_adrAckReq & 0b00000001) << 6;
      result |= (_ack & 0b00000001) << 5;
      result |= (_rfu & 0b00000001) << 4;
      result |= _fOptsLen & 0b00001111;
      return [result];
    }
    
    ubyte getAdr(){ return _adr; }
    void setAdr(ubyte adr){ _adr = adr; }
    
    ubyte getAdrAckReq(){ return _adrAckReq; }
    void setAdrAckReq(ubyte adrAckReq){ _adrAckReq = adrAckReq; }
    
    ubyte getAck(){ return _ack; }
    void setAck(ubyte ack){ _ack = ack; }
    
    ubyte getRfu(){ return _rfu; }
    void setRfu(ubyte rfu){ _rfu = rfu; }
    
    ubyte getFOptsLen(){ return _fOptsLen; }  
    void setFOptsLen(ubyte fOptsLen){ _fOptsLen = fOptsLen;}  
    
  private:
    ubyte _adr;
    ubyte _adrAckReq;
    ubyte _ack;
    ubyte _rfu;
    ubyte _fOptsLen;
}

struct Uplink
{
  public:
    ubyte[] toByteArray()
    {
      ubyte result;
      result |= (_adr & 0b00000001) << 7;
      result |= (_adrAckReq & 0b00000001) << 6;
      result |= (_ack & 0b00000001) << 5;
      result |= (_fPending & 0b00000001) << 4;
      result |= _fOptsLen & 0b00001111;
      return [result];
    }
    
    ubyte getAdr(){ return _adr; }
    void setAdr(ubyte adr){ _adr = adr; }
    
    ubyte getAdrAckReq(){ return _adrAckReq; }
    void setAdrAckReq(ubyte adrAckReq){ _adrAckReq = adrAckReq; }
    
    ubyte getAck(){ return _ack; }
    void setAck(ubyte ack){ _ack = ack; }
    
    ubyte getFPending(){ return _fPending; }
    void setFPending(ubyte fPending){ _fPending = fPending; }
    
    ubyte getFOptsLen(){ return _fOptsLen; }
    void setFOptsLen(ubyte fOptsLen){ _fOptsLen = fOptsLen;}      
  
  private:
    ubyte _adr;
    ubyte _adrAckReq;
    ubyte _ack;
    ubyte _fPending;
    ubyte _fOptsLen;
}

struct MACCommand
{
  public:
    ubyte[] toByteArray()
    {
      ubyte[] result;
      result ~= _cid;
      result ~= _args;
      return result;
    }
    
    ubyte getCid(){ return _cid; }
    void setCid(MACCommandCid cid){ _cid = cid; }
    void setCid(ubyte cid)
    in
    {
      assert((cid >= 0x02 && cid <= 0x08) || (cid >= 0x80 && cid <= 0xff));
    }
    body
    { 
      _cid = cid; 
    }
    
    ubyte[] getArgs(){ return _args; }
    void setArgs(ubyte[] args)
    in
    {
      assert(args.length <= 4);
    }
    body
    { 
      _args = args;
    }
  
  private:
    ubyte _cid;
    ubyte[] _args;
}

/// The class representing the data of the packets
class MacPacket
{
  public:
    /** Used to get data of mac packet
    
      Returns:
        $(D string)  
    */
    string getData(){ return _data; }
    
    /** Used to set data of mac packet
    
      Params:
        data = data for initialization
    */    
    void setData(string data){ _data = data; }
    
    /** Used to compare mac packets
    
      Params:
        o = object to compare
        
      Return:
        $(D bool)  
    */    
    override bool opEquals(Object o) const
    {
      MacPacket macPacket;
      macPacket = to!MacPacket(o);
      return _data == macPacket.getData;
    }
    
    /** Used to get hash of object
        
      Return:
        $(D size_t)  
    */    
    override size_t toHash() @trusted const
    {
      return cast(size_t)cast(void*)this;
    }
    
  private:
    string _data; //TODO: connect with phypayload
    PHYPayload _phyPayload;
}