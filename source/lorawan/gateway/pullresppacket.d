/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pullresppacket;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.macpacket;
import std.conv;
import std.json;
import std.typecons;

/// Structure contains the RF packet
struct Txpk
{
  public:
    /**Get 'immediate' flag (will ignore tmst & time)
      
       Returns:
        $(D Nullable!bool)
    */    
    Nullable!bool getImme(){ return _imme; }    
    
    /**Set 'immediate' flag (will ignore tmst & time)
    
      Params:
        imme = value used to initialize 'immediate' flag (will ignore tmst & time)
    */
    void setImme(bool imme){ _imme = imme; }
    
    /**Get send packet at a certain GPS time (GPS synchronization required)
      
       Returns:
        $(D Nullable!ulong)
    */    
    Nullable!ulong getTmms(){ return _tmms; }    
    
    /**Set send packet at a certain GPS time (GPS synchronization required)
    
      Params:
        tmms = value used to initialize send packet at a certain GPS time (GPS synchronization required)
    */
    void setTmms(ulong tmms){ _tmms = tmms; }
    
    
    /**Get send packet on a certain timestamp value (will ignore time)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getTmst(){ return _tmst; }    
    
    /**Set send packet on a certain timestamp value (will ignore time)
    
      Params:
        tmst = value used to initialize send packet on a certain timestamp value (will ignore time)
    */
    void setTmst(uint tmst){ _tmst = tmst; }
    
    
    /**Get TX central frequency in MHz (double, Hz precision)
      
       Returns:
        $(D Nullable!double)
    */    
    Nullable!double getFreq(){ return _freq; }    
    
    /**Set TX central frequency in MHz (double, Hz precision)
    
      Params:
        freq = value used to initialize TX central frequency
    */
    void setFreq(double freq){ _freq = freq; }
    
    /**Get concentrator "IF" channel used for TX (unsigned byte)
      
       Returns:
        $(D Nullable!ubyte)
    */    
    Nullable!ubyte getChan(){ return _chan; }    
    
    /**Set concentrator "IF" channel used for TX (unsigned byte)
    
      Params:
        chan = value used to initialize concentrator "IF" channel used for TX
    */
    void setChan(ubyte chan){ _chan = chan; }
    
    /**Get concentrator "RF chain" used for TX (unsigned integer)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getRfch(){ return _rfch; }    
    
    /**Set concentrator "RF chain" used for TX (unsigned integer)
    
      Params:
        rfch = value used to initialize concentrator "RF chain" used for TX
    */
    void setRfch(uint rfch){ _rfch = rfch; }
    
    /**Get TX output power in dBm (unsigned integer, dBm precision)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getPowe(){ return _powe; }    
    
    /**Set TX output power in dBm (unsigned integer, dBm precision)
    
      Params:
        powe = value used to initialize TX output power in dBm (unsigned integer, dBm precision)
    */
    void setPowe(uint powe){ _powe = powe; }

    
    /**Get modulation identifier "LORA" or "FSK"
      
       Returns:
        $(D ModulationIdentifier)
    */    
    ModulationIdentifier getModu(){ return _modu; }    
    
    /**Set modulation identifier "LORA" or "FSK"
    
      Params:
        modu = value used to initialize modulation identifier "LORA" or "FSK"
    */
    void setModu(ModulationIdentifier modu){ _modu = modu; } 

    
    /**Get LoRa datarate identifier (eg. SF12BW500)
      
       Returns:
        $(D LoraDatarate)
    */    
    LoraDatarate getDatrs(){ return _datrs; }    
    
    /**Set LoRa datarate identifier (eg. SF12BW500)
    
      Params:
        datrs = value used to initialize LoRa datarate identifier
    */
    void setDatr(LoraDatarate datrs){ _datrs = datrs; }
    
    /**Get FSK datarate (unsigned integer, in bits per second)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getDatrn(){ return _datrn; }    
    
    /**Set FSK datarate (unsigned integer, in bits per second)
    
      Params:
        datrn = value used to initialize FSK datarate
    */
    void setDatr(uint datrn){ _datrn = datrn; }
   
    /**Get LoRa ECC coding rate identifier
      
       Returns:
        $(D CyclicCodingRate)
    */    
    CyclicCodingRate getCodr(){ return _codr; }    
    
    /**Set LoRa ECC coding rate identifier
    
      Params:
        codr = value used to initialize LoRa ECC coding rate identifier
    */
    void setCodr(CyclicCodingRate codr){ _codr = codr; }
    
    /**Get FSK frequency deviation (unsigned integer, in Hz)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getFdev(){ return _fdev; }
    
    /**Set FSK frequency deviation (unsigned integer, in Hz)
    
      Params:
        fdev = value used to initialize FSK frequency deviation (unsigned integer, in Hz)
    */
    void setFdev(uint fdev){ _fdev = fdev; } 
   
    /**Get Lora modulation polarization inversion
      
       Returns:
        $(D Nullable!bool)
    */    
    Nullable!bool getIpol(){ return _ipol; }    
    
    /**Set Lora modulation polarization inversion
    
      Params:
        ipol = value used to initialize Lora modulation polarization inversion
    */
    void setIpol(bool ipol){ _ipol = ipol; }

    /**Get RF preamble size (unsigned integer)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getPrea(){ return _prea; }    
    
    /**Set RF preamble size (unsigned integer)
    
      Params:
        prea = value used to initialize RF preamble size (unsigned integer)
    */
    void setPrea(uint prea){ _prea = prea; } 
    
    /**Get RF packet payload size in bytes (unsigned integer)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getSize(){ return _size; }    
    
    /**Set RF packet payload size in bytes (unsigned integer)
    
      Params:
        size = value used to initialize RF packet payload size
    */
    void setSize(uint size){ _size = size; } 
   
    /**Get Base64 encoded RF packet payload, padded
      
       Returns:
        $(D MacPacket)
    */    
    MacPacket getData(){ return _data; }
    
    /**Set Base64 encoded RF packet payload, padded
    
      Params:
        data = value used to initialize data field
    */
    void setData(MacPacket data){ _data = data; }
    
    /**Get a flag that enable/disable the CRC of the physical layer
      
       Returns:
        $(D bool)
    */
    Nullable!bool getNcrc(){ return _ncrc; }
    
    /**Set a flag that enable/disable the CRC of the physical layer
    
      Params:
        ncrc = value used to initialize ncrc field
    */
    void setNcrc(bool ncrc){ _ncrc = ncrc; }
    
  private:
    Nullable!bool _imme; //Send packet immediately (will ignore tmst & time)...
    Nullable!uint _tmst; //Send packet on a certain timestamp value (will ignore time)...
    Nullable!ulong _tmms; //Send packet at a certain GPS time (GPS synchronization required)...
    Nullable!double _freq; //TX central frequency in MHz (double, Hz precision)
    Nullable!ubyte _chan; //Concentrator "IF" channel used for TX (unsigned byte)
    Nullable!uint _rfch; //Concentrator "RF chain" used for TX (unsigned integer)
    Nullable!uint _powe; //TX output power in dBm (unsigned integer, dBm precision)
    ModulationIdentifier _modu; //Modulation identifier "LORA" or "FSK"
    LoraDatarate _datrs; //LoRa datarate identifier (eg. SF12BW500)
    Nullable!uint _datrn; //FSK datarate (unsigned integer, in bits per second)
    CyclicCodingRate _codr; //LoRa ECC coding rate identifier
    Nullable!uint _fdev; //FSK frequency deviation (unsigned integer, in Hz)
    Nullable!bool _ipol; //Lora modulation polarization inversion
    Nullable!uint _prea; //RF preamble size (unsigned integer)
    Nullable!uint _size; //RF packet payload size in bytes (unsigned integer)
    MacPacket _data; //Base64 encoded RF packet payload, padding optional
    Nullable!bool _ncrc; //If true, disable the CRC of the physical layer (optional)
}

/// The class represending the PULL_RESP packet
class PullRespPacket : AbstractPacket
{
  public:   
    /// Used to initialize PULL_RESP packet
    this()
    {
      super(ProtocolVersion.VERSION_2, PacketType.PULL_RESP, [0, 0]);
      _txpkStruct = Txpk();
    }
    
    /** Used to converts PULL_RESP packet to an array of bytes
    
      Returns:
        $(D ubyte[])
    */
    override ubyte[] toByteArray()
    {
      ubyte[] result = _protocolVersion ~ _token ~ _packetType;
      JSONValue jsonValue = getJsonValue(_txpkStruct);
      result ~= cast(ubyte[]) toJSON(jsonValue);
      return result;
    }
    
    /** Used to get the txpk structure
    
      Returns:
        $(D Txpk)
    */ 
    Txpk getTxpkStruct(){ return _txpkStruct; }
    
    /** Used to set the txpk structure
    
      Params:
        txpkStruct = value used to initialize txpk structure
    */
    void setTxpkStruct(Txpk txpkStruct){ _txpkStruct = txpkStruct; }
    
  private:
    Txpk _txpkStruct;
    
    JSONValue getJsonValue(Txpk txpkStruct)
    {
      JSONValue jsonValue;
      JSONValue txpkValue;
      
      txpkValue = parseTxpk(txpkStruct);
      if(!txpkValue.isNull()){ jsonValue["txpk"] = txpkValue; }

      return jsonValue;
    }
    
    JSONValue parseTxpk(Txpk txpkStruct)
    {
      JSONValue txpkValue;
       
      const auto imme = txpkStruct.getImme();
      const auto tmms = txpkStruct.getTmms();
      const auto tmst = txpkStruct.getTmst();
      const auto freq = txpkStruct.getFreq();
      const auto chan = txpkStruct.getChan();
      const auto rfch = txpkStruct.getRfch();
      const auto powe = txpkStruct.getPowe();
      const ModulationIdentifier modu = txpkStruct.getModu();
      const LoraDatarate datrs = txpkStruct.getDatrs();
      const CyclicCodingRate codr = txpkStruct.getCodr();
      const auto datrn = txpkStruct.getDatrn();
      const auto fdev = txpkStruct.getFdev();
      const auto ipol = txpkStruct.getIpol();
      const auto prea = txpkStruct.getPrea();
      const auto size = txpkStruct.getSize();
      MacPacket data = txpkStruct.getData();
      const auto ncrc = txpkStruct.getNcrc();
        
      if(!imme.isNull){ txpkValue["imme"] = cast(bool) imme; }
      if(!tmms.isNull){ txpkValue["tmms"] = cast(ulong) tmms; }
      if(!tmst.isNull){ txpkValue["tmst"] = cast(uint) tmst; }
      if(!freq.isNull){ txpkValue["freq"] = cast(double) freq; }
      if(!chan.isNull){ txpkValue["chan"] = cast(ubyte) chan; }
      if(!rfch.isNull){ txpkValue["rfch"] = cast(uint) rfch; }
      if(!powe.isNull){ txpkValue["powe"] = cast(uint) powe; }
      txpkValue["modu"] = modu;
      if(modu == ModulationIdentifier.LORA)
      {
        txpkValue["datr"] = datrs;
      }
      else
      {
        if(modu == ModulationIdentifier.FSK)
        {
          if(!datrn.isNull)
          { 
            txpkValue["datr"] = cast(uint)datrn;
          }
        }
      }
      txpkValue["codr"] = codr;
      if(!fdev.isNull){ txpkValue["fdev"] = cast(uint) fdev; }
      if(!ipol.isNull){ txpkValue["ipol"] = cast(bool) ipol; }
      if(!prea.isNull){ txpkValue["prea"] = cast(uint) prea; }
      if(!size.isNull){ txpkValue["size"] = cast(uint) size; }
      if(data !is null){ txpkValue["data"] = data.getData(); }
      if(!ncrc.isNull){ txpkValue["ncrc"] = cast(bool) ncrc; }
      
      return txpkValue;
    }
}