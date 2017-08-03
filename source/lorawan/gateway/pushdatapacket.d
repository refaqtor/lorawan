/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pushdatapacket;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.macpacket;
import std.conv;
import std.datetime;
import std.json;
import std.typecons;

/// Structure contains the RF packet
struct Rxpk
{
  public:
    /**Get UTC time of pkt RX, us precision, ISO 8601 'compact' format
      
       Returns:
        $(D Nullable!SysTime)
    */
    Nullable!SysTime getTime(){ return _time; }
    
    /**Set UTC time of pkt RX, us precision, ISO 8601 'compact' format
    
      Params:
        time = value used to initialize UTC time of pkt RX, us precision, ISO 8601 'compact' format
        
      Returns:
        $(D bool)
    */
    bool setTime(SysTime time)
    {
      if(time.timezone().name != "UTC"){ return false; }
      _time = time;
      return true;
    }

    
    /**Get GPS time of pkt RX, number of milliseconds since 06.Jan.1980
      
       Returns:
        $(D Nullable!ulong)
    */    
    Nullable!ulong getTmms(){ return _tmms; }    
    
    /**Set GPS time of pkt RX, number of milliseconds since 06.Jan.1980
    
      Params:
        tmms = value used to initialize GPS time of pkt RX, number of milliseconds since 06.Jan.1980
    */
    void setTmms(ulong tmms){ _tmms = tmms; }

    
    /**Get internal timestamp of "RX finished" event (32b unsigned)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getTmst(){ return _tmst; }    
    
    /**Set internal timestamp of "RX finished" event (32b unsigned)
    
      Params:
        tmst = value used to initialize internal timestamp of "RX finished" event
    */
    void setTmst(uint tmst){ _tmst = tmst; }

    
    /**Get RX central frequency in MHz (double, Hz precision)
      
       Returns:
        $(D Nullable!double)
    */    
    Nullable!double getFreq(){ return _freq; }    
    
    /**Set RX central frequency in MHz (double, Hz precision)
    
      Params:
        freq = value used to initialize RX central frequency
    */
    void setFreq(double freq){ _freq = freq; }

    
    /**Get concentrator "IF" channel used for RX (unsigned integer)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getChan(){ return _chan; }    
    
    /**Set concentrator "IF" channel used for RX (unsigned integer)
    
      Params:
        chan = value used to initialize concentrator "IF" channel used for RX
    */
    void setChan(uint chan){ _chan = chan; }

    
    /**Get concentrator "RF chain" used for RX (unsigned integer)
      
       Returns:
        $(D Nullable!uint)
    */    
    Nullable!uint getRfch(){ return _rfch; }    
    
    /**Set concentrator "RF chain" used for RX (unsigned integer)
    
      Params:
        rfch = value used to initialize concentrator "RF chain" used for RX
    */
    void setRfch(uint rfch){ _rfch = rfch; }

    
    /**Get CRC status: 1 = OK, -1 = fail, 0 = no CRC
      
       Returns:
        $(D CrcStatus)
    */    
    CrcStatus getStat(){ return _stat; }    
    
    /**Set CRC status: 1 = OK, -1 = fail, 0 = no CRC
    
      Params:
        stat = value used to initialize CRC status (1 = OK, -1 = fail, 0 = no CRC)
    */
    void setStat(CrcStatus stat){ _stat = stat; }

    
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

    
    /**Get RSSI in dBm (signed short, 1 dB precision)
      
       Returns:
        $(D Nullable!short)
    */    
    Nullable!short getRssi(){ return _rssi; } 
       
    /**Set RSSI in dBm (signed short, 1 dB precision)
    
      Params:
        rssi = value used to initialize RSSI
    */
    void setRssi(short rssi){ _rssi = rssi; }

    
    /**Get Lora SNR ratio in dB (signed float, 0.1 dB precision)
      
       Returns:
        $(D Nullable!float)
    */    
    Nullable!float getLsnr(){ return _lsnr; }    
    
    /**Set Lora SNR ratio in dB (signed float, 0.1 dB precision)
    
      Params:
        lsnr = value used to initialize Lora SNR ratio
    */
    void setLsnr(float lsnr){ _lsnr = lsnr; }

    
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
    
  private:   
    Nullable!SysTime _time; //UTC time of pkt RX, us precision, ISO 8601 'compact' format
    Nullable!ulong _tmms; //GPS time of pkt RX, number of milliseconds since 06.Jan.1980
    Nullable!uint _tmst; //Internal timestamp of "RX finished" event (32b unsigned)
    Nullable!double _freq; //RX central frequency in MHz (double, Hz precision)
    Nullable!uint _chan; //Concentrator "IF" channel used for RX (unsigned integer)
    Nullable!uint _rfch; //Concentrator "RF chain" used for RX (unsigned integer)
    CrcStatus _stat; //CRC status: 1 = OK, -1 = fail, 0 = no CRC
    ModulationIdentifier _modu; //Modulation identifier "LORA" or "FSK"
    LoraDatarate _datrs; //LoRa datarate identifier (eg. SF12BW500)
    Nullable!uint _datrn; //FSK datarate (unsigned integer, in bits per second)
    CyclicCodingRate _codr; //LoRa ECC coding rate identifier
    Nullable!short _rssi; //RSSI in dBm (signed short, 1 dB precision)
    Nullable!float _lsnr; //Lora SNR ratio in dB (signed float, 0.1 dB precision)
    Nullable!uint _size; //RF packet payload size in bytes (unsigned integer)
    MacPacket _data; //Base64 encoded RF packet payload, padded
}

/// Structure contains the statistics information
struct Stat
{
  public:
    /**Get UTC 'system' time of the gateway, ISO 8601 'expanded' format
      
       Returns:
         $(D string)
    */
    Nullable!SysTime getTime(){ return _time; }
    
    /**Set UTC 'system' time of the gateway, ISO 8601 'expanded' format
    
      Params:
        time = value used to initialize UTC 'system' time of the gateway, ISO 8601 'expanded' format
    */
    bool setTime(SysTime time)
    { 
      if(time.timezone().name != "UTC"){ return false; }
      _time = time;
      return true;
    }
    
    /**Get GPS latitude of the gateway in degree (float, N is +)
      
       Returns:
         $(D Nullable!double)
    */
    Nullable!double getLatn(){ return _latn; }
    
    /**Set GPS latitude of the gateway in degree (float, N is +)
    
      Params:
        latn = value used to initialize GPS latitude of the gateway in degree (float, N is +)
    */
    void setLatn(double latn){ _latn = latn; }

    /**Get GPS latitude of the gateway in degree (float, E is +)
      
       Returns:
         $(D Nullable!double)
    */
    Nullable!double getLate(){ return _late; }
    
    /**Set GPS latitude of the gateway in degree (float, E is +)
    
      Params:
        late = value used to initialize GPS latitude of the gateway in degree (float, E is +)
    */
    void setLate(double late){ _late = late; }
    
    /**Get GPS altitude of the gateway in meter RX (integer)
      
       Returns:
         $(D Nullable!int)
    */
    Nullable!int getAlti(){ return _alti; }
    
    /**Set GPS altitude of the gateway in meter RX (integer)
    
      Params:
        alti = value used to initialize GPS altitude of the gateway in meter RX (integer)
    */
    void setAlti(int alti){ _alti = alti; }
    
    /**Get number of radio packets received (unsigned long)
      
       Returns:
         $(D Nullable!ulong)
    */
    Nullable!ulong getRxnb(){ return _rxnb; }
    
    /**Set number of radio packets received (unsigned long)
    
      Params:
        rxnb = value used to initialize number of radio packets received (unsigned long)
    */
    void setRxnb(ulong rxnb){ _rxnb = rxnb; }
    
    /**Get number of radio packets received with a valid PHY CRC
      
       Returns:
         $(D Nullable!ulong)
    */
    Nullable!ulong getRxok(){ return _rxok; }
    
    /**Set number of radio packets received with a valid PHY CRC
    
      Params:
        rxok = value used to initialize number of radio packets received with a valid PHY CRC
    */
    void setRxok(ulong rxok){ _rxok = rxok; }
    
    /**Get number of radio packets forwarded (unsigned long)
      
       Returns:
         $(D Nullable!ulong)
    */
    Nullable!ulong getRxfw(){ return _rxfw; }
    
    /**Set number of radio packets forwarded (unsigned long)
    
      Params:
        rxfw = value used to initialize number of radio packets forwarded (unsigned long)
    */
    void setRxfw(ulong rxfw){ _rxfw = rxfw; }
    
    /**Get percentage of upstream datagrams that were acknowledged
      
       Returns:
         $(D Nullable!double)
    */
    Nullable!double getAckr(){ return _ackr; }
    
    /**Set percentage of upstream datagrams that were acknowledged
    
      Params:
        ackr = value used to initialize percentage of upstream datagrams that were acknowledged
    */
    void setAckr(double ackr){ _ackr = ackr; }
    
    /**Get number of downlink datagrams received (unsigned integer)
      
       Returns:
         $(D Nullable!uint)
    */
    Nullable!uint getDwnb(){ return _dwnb; }
    
    /**Set number of downlink datagrams received (unsigned integer)
    
      Params:
        dwnb = value used to initialize number of downlink datagrams received (unsigned integer)
    */
    void setDwnb(uint dwnb){ _dwnb = dwnb; }
    
    /**Get number of packets emitted (unsigned integer)
      
       Returns:
         $(D Nullable!uint)
    */
    Nullable!uint getTxnb(){ return _txnb; }
    
    /**Set number of packets emitted (unsigned integer)
    
      Params:
        txnb = value used to initialize number of packets emitted (unsigned integer)
    */
    void setTxnb(uint txnb){ _txnb = txnb; }
    
    /**The property that determines whether the structure fields are initialized with default values or not
    
      Returns:
        $(D bool)
    */
    bool isEmpty()
    {
      return (_time.isNull && _latn.isNull && _late.isNull && _alti.isNull && _rxnb.isNull && _rxok.isNull &&
        _rxfw.isNull && _ackr.isNull && _dwnb.isNull && _txnb.isNull);
    }   

  private:
    Nullable!SysTime _time; //UTC 'system' time of the gateway, ISO 8601 'expanded' format
    Nullable!double _latn; //GPS latitude of the gateway in degree (float, N is +)
    Nullable!double _late; //GPS latitude of the gateway in degree (float, E is +)
    Nullable!int _alti; //GPS altitude of the gateway in meter RX (integer)
    Nullable!ulong _rxnb; //Number of radio packets received (unsigned integer)
    Nullable!ulong _rxok; //Number of radio packets received with a valid PHY CRC
    Nullable!ulong _rxfw; //Number of radio packets forwarded (unsigned integer)
    Nullable!double _ackr; //Percentage of upstream datagrams that were acknowledged
    Nullable!uint _dwnb; //Number of downlink datagrams received (unsigned integer)
    Nullable!uint _txnb; //Number of packets emitted (unsigned integer)
}

/// The class represending the PUSH_DATA packet
class PushDataPacket : AbstractPacket
{
  public:   
    /// Used to initialize PUSH_DATA packet
    this()
    {
      super(ProtocolVersion.VERSION_2, PacketType.PUSH_DATA, [0, 0]);
      _rxpkArray = [Rxpk()];
      _statStruct = Stat();
      _gatewayID = [0, 0, 0, 0, 0, 0, 0, 0];
    }
    
    /** Used to converts PUSH_DATA packet to an array of bytes
    
      Returns:
        $(D ubyte[])
    */
    override ubyte[] toByteArray()
    {
      ubyte[] result = _protocolVersion ~ _token ~ _packetType ~ _gatewayID;
      JSONValue jsonValue = getJsonValue(_rxpkArray, _statStruct);
      result ~= cast(ubyte[]) toJSON(jsonValue);
      return result;
    }
    
    /** Used to get the gateway identifier (MAC address)
    
      Returns:
        $(D ubyte[8])
    */     
    ubyte[8] getGatewayID(){ return _gatewayID; }
    
    /** Used to set the gateway identifier (MAC address)
    
      Params:
        gatewayID = value used to initialize gateway identifier (MAC address)
    */    
    void setGatewayID(ubyte[8] gatewayID){ _gatewayID = gatewayID; }
    
    /** Used to get the rxpk array
    
      Returns:
        $(D Rxpk[])
    */ 
    Rxpk[] getRxpkArray(){ return _rxpkArray; }
    
    /** Used to set the rxpk array
    
      Params:
        rxpkArray = value used to initialize rxpk array
        
      Returns:
        $(D bool)
    */
    bool setRxpkArray(Rxpk[] rxpkArray)
    { 
      if(rxpkArray.length != 0){ _rxpkArray = rxpkArray; }
      else
      {
        if(!_statStruct.isEmpty()){ _rxpkArray = rxpkArray; }
        else { return false; }
      }
      return true;
    }
    
    /** Used to get the stat structure which represending status of the gateway
    
      Returns:
        $(D Stat)
    */
    Stat getStatStruct(){ return _statStruct; }
    
    /** Used to set the stat stricture which represending status of the gateway
    
      Params:
        statStruct = value used to initialize stat stricture which represending status of the gateway
    */
    bool setStatStruct(Stat statStruct)
    {
      if(!statStruct.isEmpty()){ _statStruct = statStruct; }
      else
      {
        if(_rxpkArray.length != 0){ _statStruct = statStruct; }
        else{ return false; }
      }
      return true;
    }
    
  private:
    ubyte[8] _gatewayID;
    JSONValue _jsonObject;
    Rxpk[] _rxpkArray;
    Stat _statStruct;
    
    public JSONValue getJsonValue(Rxpk[] rxpkArray, Stat statStruct)
    {
      JSONValue jsonValue;
      JSONValue[] rxpkPackets;
      JSONValue statValue;
      
      rxpkPackets = parseRxpk(rxpkArray);
      statValue = parseStat(statStruct);
      
      if(rxpkPackets.length != 0){ jsonValue["rxpk"] = rxpkPackets; }
      if(!statValue.isNull()){ jsonValue.object["stat"] = statValue; }
      
      return jsonValue;
    }
    
    JSONValue[] parseRxpk(Rxpk[] rxpkArray)
    {
      JSONValue[] rxpkPackets = [];
      
      foreach(Rxpk rxpkStruct; rxpkArray)
      {
        JSONValue rxpkValue;
        
        const Nullable!SysTime time = rxpkStruct.getTime();
        const auto tmms = rxpkStruct.getTmms();
        const auto tmst = rxpkStruct.getTmst();
        const auto freq = rxpkStruct.getFreq();
        const auto chan = rxpkStruct.getChan();
        const auto rfch = rxpkStruct.getRfch();
        const CrcStatus stat = rxpkStruct.getStat();
        const ModulationIdentifier modu = rxpkStruct.getModu();
        const LoraDatarate datrs = rxpkStruct.getDatrs();
        const auto datrn = rxpkStruct.getDatrn();
        const CyclicCodingRate codr = rxpkStruct.getCodr();
        const auto rssi = rxpkStruct.getRssi();
        const auto lsnr = rxpkStruct.getLsnr();
        const auto size = rxpkStruct.getSize();
        MacPacket data = rxpkStruct.getData();
       
        if(!time.isNull){ rxpkValue["time"] = time.toISOString();}
        if(!tmms.isNull){ rxpkValue["tmms"] = tmms;}
        if(!tmst.isNull){ rxpkValue["tmst"] = tmst;}
        if(!freq.isNull){ rxpkValue["freq"] = cast(double)freq;}
        if(!chan.isNull){ rxpkValue["chan"] = chan;}
        if(!rfch.isNull){ rxpkValue["rfch"] = rfch;}
        rxpkValue["stat"] = cast(byte)stat;
        rxpkValue["modu"] = modu;
        
        if(modu == ModulationIdentifier.LORA)
        {
          rxpkValue["datr"] = datrs;
        }
        else
        {
          if(modu == ModulationIdentifier.FSK)
          {
            if(!datrn.isNull)
            { 
              rxpkValue["datr"] = datrn;
            }
          }
        }
        rxpkValue["codr"] = codr;
        if(!rssi.isNull){ rxpkValue["rssi"] = rssi;}
        if(!lsnr.isNull){ rxpkValue["lsnr"] = cast(float) lsnr;}
        if(!size.isNull){ rxpkValue["size"] = size;}
        if(data !is null){ rxpkValue["data"] = data.getData();}
        if(!rxpkValue.isNull())
        {
          rxpkPackets ~= rxpkValue;
        }
      }
      
      return rxpkPackets;
    }
    
    JSONValue parseStat(Stat statStruct)
    {
      JSONValue statVal;
      
      if(!statStruct.isEmpty())
      {   
        const Nullable!SysTime time = statStruct.getTime();
        const auto latn = statStruct.getLatn();
        const auto late = statStruct.getLate();
        const auto alti = statStruct.getAlti();
        const auto rxnb = statStruct.getRxnb();
        const auto rxok = statStruct.getRxok();
        const auto rxfw = statStruct.getRxfw();
        const auto ackr = statStruct.getAckr();
        const auto dwnb = statStruct.getDwnb();
        const auto txnb = statStruct.getTxnb();
          
        if(!time.isNull){ statVal["time"] = time.toISOExtString();}
        if(!latn.isNull){ statVal["latn"] = cast(double) latn;}
        if(!late.isNull){ statVal["late"] = cast(double) late;}
        if(!alti.isNull){ statVal["alti"] = alti;}
        if(!rxnb.isNull){ statVal["rxnb"] = rxnb;}
        if(!rxok.isNull){ statVal["rxok"] = rxok;}
        if(!rxfw.isNull){ statVal["rxfw"] = rxfw;}
        if(!ackr.isNull){ statVal["ackr"] = cast(float) ackr;}
        if(!dwnb.isNull){ statVal["dwnb"] = dwnb;}
        if(!txnb.isNull){ statVal["txnb"] = txnb;}
      }
      
      return statVal;
    }
}