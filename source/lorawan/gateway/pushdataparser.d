/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pushdataparser;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawanexception;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.macpacket;
import lorawan.gateway.parserinterface;
import lorawan.gateway.pushdatapacket;
import lorawan.utils.parserhelper;
import std.conv;
import std.datetime;
import std.json;
import std.typecons;

/// Parser for PUSH_DATA packets
class PushDataParser : ParserInterface
{
  /** Used to parse byte array which represent PUSH_DATA packet
  
    Params:
      data = byte array for parsing
      
    Returns:
      $(D AbstractPacket)  
  */
  AbstractPacket parse(in ubyte[] data)
  {
    if(data.length <= 12)
    { 
      return null;
    }
    if(data[0] != ProtocolVersion.VERSION_2){ 
      return null;
    }
    if(data[3] != PacketType.PUSH_DATA)
    {
      return null;
    }
    else
    {
      PushDataPacket result = new PushDataPacket;
      
      Rxpk[] rxpkArray;
      Stat statStructure;
      
      JSONValue jsonValue = parseJSON(cast(string) data[12..$]);
      
      if(jsonValue.isNull())
      { 
        throw new LorawanException("byte array should contain json object, " ~
          "but recieved array contain only \"null\" json object!");
      }
      
      // jsonValue parsing...
      if((("rxpk" in jsonValue) is null) && (("stat" in jsonValue) is null))
      { 
        throw new LorawanException("json object should contain at least on of " ~
          "this: \"rxpk array\" or \"stat structure\"!");
      }
      
      if(("stat" in jsonValue) !is null)
      {
        if(jsonValue["stat"].type != JSON_TYPE.OBJECT)
        {
          throw new LorawanException("field \"stat\" of json object " ~
            "should have \"OBJECT\" type, but it have \"" ~ to!string(jsonValue["stat"].type) ~ "\" type!");
        }
        
        // parsing of the stat structure...
        JSONValue jsonStatStructure = jsonValue["stat"];
        
        Nullable!SysTime time = getTimeFromJson(jsonStatStructure, NamesOfStructures.STAT);
        Nullable!double latn = getValueFromJsonByKey!double("latn", jsonStatStructure, NamesOfStructures.STAT);
        Nullable!double late = getValueFromJsonByKey!double("late", jsonStatStructure, NamesOfStructures.STAT);
        Nullable!int alti = getValueFromJsonByKey!int("alti", jsonStatStructure, NamesOfStructures.STAT);
        Nullable!ulong rxnb = getValueFromJsonByKey!ulong("rxnb", jsonStatStructure, NamesOfStructures.STAT);
        Nullable!ulong rxok = getValueFromJsonByKey!ulong("rxok", jsonStatStructure, NamesOfStructures.STAT);
        Nullable!ulong rxfw = getValueFromJsonByKey!ulong("rxfw", jsonStatStructure, NamesOfStructures.STAT);
        Nullable!int ackr = getValueFromJsonByKey!int("ackr", jsonStatStructure, NamesOfStructures.STAT);
        Nullable!uint dwnb = getValueFromJsonByKey!uint("dwnb", jsonStatStructure, NamesOfStructures.STAT);
        Nullable!uint txnb = getValueFromJsonByKey!uint("txnb", jsonStatStructure, NamesOfStructures.STAT);
        
        if(!time.isNull){ statStructure.setTime(time); }
        if(!latn.isNull){ statStructure.setLatn(latn); }
        if(!late.isNull){ statStructure.setLate(late); }
        if(!alti.isNull){ statStructure.setAlti(alti); }
        if(!rxnb.isNull){ statStructure.setRxnb(rxnb); }
        if(!rxok.isNull){ statStructure.setRxok(rxok); }
        if(!rxfw.isNull){ statStructure.setRxfw(rxfw); }
        if(!ackr.isNull){ statStructure.setAckr(ackr); }
        if(!dwnb.isNull){ statStructure.setDwnb(dwnb); }
        if(!txnb.isNull){ statStructure.setTxnb(txnb); }
      }
            
      if(("rxpk" in jsonValue) !is null)
      {
        if(jsonValue["rxpk"].type != JSON_TYPE.ARRAY)
        {
          throw new LorawanException("field \"rxpk\" of json object should have \"ARRAY\" type, but it have \"" ~
            to!string(jsonValue["rxpk"].type) ~ "\" type!");
        }
        
        // parsing of the rxpk array...
        JSONValue jsonRxpkArray = jsonValue["rxpk"];
        
        foreach(JSONValue jsonRxpkArrayElement; jsonRxpkArray.array)
        { 
          if(jsonRxpkArrayElement.type != JSON_TYPE.OBJECT)
          {
            throw new LorawanException("rxpk array should can only contain elements with \"OBJECT\" type, " ~
              "but it have element with \"" ~ to!string(jsonRxpkArrayElement.type) ~ "\" type!");
          }
          
          // These fields have an enumeration type and they are mandatory in the rxpk structure
          Nullable!CrcStatus crcStatus;
          Nullable!ModulationIdentifier modulationIdentifier;
          Nullable!LoraDatarate loraDatarate;
          Nullable!CyclicCodingRate cyclicCodingRate;
          
          // Get the required fields rxpk structure
          crcStatus = getEnumValueFromJsonByKey!(byte, CrcStatus)("stat", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          
          modulationIdentifier = getEnumValueFromJsonByKey!(string, ModulationIdentifier)
          ("modu", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          
          loraDatarate = getLoraDatarate(modulationIdentifier, jsonRxpkArrayElement, NamesOfStructures.RXPK	); 
          
          cyclicCodingRate = getEnumValueFromJsonByKey!(string, CyclicCodingRate)
          ("codr", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          
          // Initialize the required fields rxpk structure
          Rxpk newRxpk;
          
          newRxpk.setStat(crcStatus);
          newRxpk.setModu(modulationIdentifier);
          newRxpk.setCodr(cyclicCodingRate);
          if(!loraDatarate.isNull){ newRxpk.setDatr(loraDatarate); }
          
          // Get the optional fields of the rxpk structure
          Nullable!SysTime time = getTimeFromJson(jsonRxpkArrayElement, NamesOfStructures.RXPK);
          Nullable!uint fskDatarate = getFskDatarate(modulationIdentifier, jsonRxpkArrayElement,
            NamesOfStructures.RXPK);
          Nullable!ulong tmms = getValueFromJsonByKey!ulong("tmms", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          Nullable!uint tmst = getValueFromJsonByKey!uint("tmst", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          Nullable!double freq = getValueFromJsonByKey!double("freq", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          Nullable!ubyte chan = getValueFromJsonByKey!ubyte("chan", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          Nullable!uint rfch = getValueFromJsonByKey!uint("rfch", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          Nullable!short rssi = getValueFromJsonByKey!short("rssi", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          Nullable!float lsnr = getValueFromJsonByKey!float("lsnr", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          Nullable!uint size = getValueFromJsonByKey!uint("size", jsonRxpkArrayElement, NamesOfStructures.RXPK);
          Nullable!MacPacket rxpkData = getData(jsonRxpkArrayElement, NamesOfStructures.RXPK);
          
          // Set the optional fields of the rxpk structure
          if(!time.isNull){ newRxpk.setTime(time); }
          if(!fskDatarate.isNull){ newRxpk.setDatr(fskDatarate); }
          if(!tmms.isNull){ newRxpk.setTmms(tmms); }
          if(!tmst.isNull){ newRxpk.setTmst(tmst); }
          if(!freq.isNull){ newRxpk.setFreq(freq); }
          if(!chan.isNull){ newRxpk.setChan(chan); }
          if(!rssi.isNull){ newRxpk.setRssi(rssi); }
          if(!rssi.isNull){ newRxpk.setRfch(rfch); }
          if(!lsnr.isNull){ newRxpk.setLsnr(lsnr); }
          if(!size.isNull){ newRxpk.setSize(size); }
          if(!rxpkData.isNull){ newRxpk.setData(rxpkData); }
          
          rxpkArray ~= newRxpk;
        }        
      }
      
      if(statStructure.isEmpty() && rxpkArray.length == 0)
      {
        throw new LorawanException("json object should contain one of this: "~
        "\"not empty stat structure\" or \"not empty rxpk array\"!");
      }
      
      if(!statStructure.isEmpty()) { result.setStatStruct(statStructure); }
      result.setRxpkArray(rxpkArray);
      result.setProtocolVersion(ProtocolVersion.VERSION_2);
      result.setToken(data[1..3]);
      result.setGatewayID(data[4..12]);
      
      return result;
    }
  }
  
  private:
    Nullable!SysTime getTimeFromJson(JSONValue jsonValue, NamesOfStructures structureName)
    {
      Nullable!SysTime result;
      
      if(("time" in jsonValue) !is null)
      {
        if(jsonValue["time"].type != JSON_TYPE.STRING)
        {
          throw new LorawanException("field \"time\" of " ~ structureName ~ " structure from json object " ~
            "should have \"STRING\" type, but it have \"" ~ to!string(jsonValue["time"].type) ~ "\" type!");
        }
        if(structureName == "stat")
        {
          result = SysTime.fromISOExtString(jsonValue["time"].str);
        }
        else
        {
          // structureName == "rxpk"
          result = SysTime.fromISOString(jsonValue["time"].str);
        }
      }
      
      return result;
    }
}