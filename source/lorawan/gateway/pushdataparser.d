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
import std.conv;
import std.datetime;
import std.json;
import std.traits;
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
        
        Nullable!SysTime time = getTimeFromJson(jsonStatStructure, Structures.STAT);
        Nullable!double latn = getValueFromJsonByKey!double("latn", jsonStatStructure, Structures.STAT);
        Nullable!double late = getValueFromJsonByKey!double("late", jsonStatStructure, Structures.STAT);
        Nullable!int alti = getValueFromJsonByKey!int("alti", jsonStatStructure, Structures.STAT);
        Nullable!ulong rxnb = getValueFromJsonByKey!ulong("rxnb", jsonStatStructure, Structures.STAT);
        Nullable!ulong rxok = getValueFromJsonByKey!ulong("rxok", jsonStatStructure, Structures.STAT);
        Nullable!ulong rxfw = getValueFromJsonByKey!ulong("rxfw", jsonStatStructure, Structures.STAT);
        Nullable!int ackr = getValueFromJsonByKey!int("ackr", jsonStatStructure, Structures.STAT);
        Nullable!uint dwnb = getValueFromJsonByKey!uint("dwnb", jsonStatStructure, Structures.STAT);
        Nullable!uint txnb = getValueFromJsonByKey!uint("txnb", jsonStatStructure, Structures.STAT);
        
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
          crcStatus = getEnumValueFromJsonByKey!(byte, CrcStatus)("stat", jsonRxpkArrayElement, Structures.RXPK);
          
          modulationIdentifier = getEnumValueFromJsonByKey!(string, ModulationIdentifier)
          ("modu", jsonRxpkArrayElement, Structures.RXPK);
          
          loraDatarate = getLoraDatarate(modulationIdentifier, jsonRxpkArrayElement); 
          
          cyclicCodingRate = getEnumValueFromJsonByKey!(string, CyclicCodingRate)
          ("codr", jsonRxpkArrayElement, Structures.RXPK);
          
          // Initialize the required fields rxpk structure
          Rxpk newRxpk;
          
          newRxpk.setStat(crcStatus);
          newRxpk.setModu(modulationIdentifier);
          newRxpk.setCodr(cyclicCodingRate);
          if(!loraDatarate.isNull){ newRxpk.setDatr(loraDatarate); }
          
          // Get the optional fields of the rxpk structure
          Nullable!SysTime time = getTimeFromJson(jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint fskDatarate = getFskDatarate(modulationIdentifier, jsonRxpkArrayElement);
          Nullable!ulong tmms = getValueFromJsonByKey!ulong("tmms", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint tmst = getValueFromJsonByKey!uint("tmst", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!double freq = getValueFromJsonByKey!double("freq", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!ubyte chan = getValueFromJsonByKey!ubyte("chan", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint rfch = getValueFromJsonByKey!uint("rfch", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!short rssi = getValueFromJsonByKey!short("rssi", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!float lsnr = getValueFromJsonByKey!float("lsnr", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint size = getValueFromJsonByKey!uint("size", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!MacPacket rxpkData = getData(jsonRxpkArrayElement);
          
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
    enum Structures: string
    {
      RXPK = "rxpk",
      STAT = "stat"
    }
  
    Nullable!T getValueFromJsonByKey(T)(string key, JSONValue jsonValue, Structures structureName)
    {
      Nullable!T result;
      
      if((key in jsonValue) !is null)
      {
        JSON_TYPE expectedJsonType = dlangToJsonTypes[T.stringof];
        JSON_TYPE realJsonType = jsonValue[key].type;
        if(realJsonType != expectedJsonType)
        {
          if(!(realJsonType == JSON_TYPE.INTEGER && expectedJsonType == JSON_TYPE.UINTEGER))
          {
            throw new LorawanException("field \"" ~ key ~ "\" of " ~ structureName ~ 
              " structure from json object should have \"" ~ to!string(expectedJsonType) ~ 
              "\" type, but it have \"" ~ to!string(realJsonType) ~ "\" type!");
          }
        }
                
        switch(realJsonType)
        {
          case JSON_TYPE.INTEGER : result = to!T(jsonValue[key].integer); break;
          case JSON_TYPE.UINTEGER : result = to!T(jsonValue[key].uinteger); break;
          case JSON_TYPE.FLOAT : result = to!T(jsonValue[key].floating); break;
          default : break;
        }
      }
      
      return result;
    }
    
    Nullable!E getEnumValueFromJsonByKey(T, E)(string key, JSONValue jsonValue, Structures structureName)
    {
      Nullable!E result;
      
      if((key in jsonValue) !is null)
      {
        JSON_TYPE expectedJsonType = dlangToJsonTypes[T.stringof];
        JSON_TYPE realJsonType = jsonValue[key].type;
        if(realJsonType != expectedJsonType)
        {
          if(!(realJsonType == JSON_TYPE.INTEGER && expectedJsonType == JSON_TYPE.UINTEGER))
          {
            throw new LorawanException("field \"" ~ key ~ "\" of " ~ structureName ~
              " structure from json object should have \"" ~ to!string(expectedJsonType) ~
              "\" type, but it have \"" ~ to!string(realJsonType) ~ "\" type!");
          }
        }
        
        T valueFromJson;
        switch(realJsonType)
        {
          case JSON_TYPE.STRING : valueFromJson = to!T(jsonValue[key].str); break;
          case JSON_TYPE.INTEGER : valueFromJson = to!T(jsonValue[key].integer); break;
          default : break;
        }
        
        string[] enumStringArray = [];
        foreach (immutable enumValue; [EnumMembers!E])
        {
          enumStringArray ~= "\"" ~ to!string(cast(T)(enumValue)) ~ "\"";
        }
        
        string enumString = "";
        ulong length = enumStringArray.length;
        if(length >= 2) {  
          for(int i = 0; i < length - 2; i++)
          {
            enumString ~= enumStringArray[i] ~ ", ";
          }
          enumString ~= enumStringArray[length - 2] ~ " or "
          ~ enumStringArray[length - 1];
        }
        else
        {
          if(length == 1){ enumString ~= enumStringArray[0]; }
        }
        
        E enumValue = cast(E)(valueFromJson);
        if(to!string(enumValue) != "cast(" ~ E.stringof ~ ")" ~ to!string(valueFromJson))
        {
          result = enumValue;
        }
        else
        {
          throw new LorawanException("field \"" ~ key ~ "\" of " ~ structureName ~
            " structure from json object should have one of this values: " ~ enumString ~
            ", but it has the value \"" ~ to!string(valueFromJson) ~ "\"");
        }
      }
      else
      {
        throw new LorawanException("rxpk structure from json object should have field \"" ~ key ~ "\"!");
      }
      
      return result;
    }
    
    Nullable!SysTime getTimeFromJson(JSONValue jsonValue, Structures structureName)
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
    
    Nullable!LoraDatarate getLoraDatarate(ModulationIdentifier modulationIdentifier, JSONValue jsonRxpkArrayElement)
    {
      Nullable!LoraDatarate result;
      
      if(modulationIdentifier == ModulationIdentifier.LORA)
      {
        try
        {
          result = getEnumValueFromJsonByKey!(string, LoraDatarate)("datr", jsonRxpkArrayElement, Structures.RXPK);
        }
        catch(LorawanException lorawanException)
        {
          if(lorawanException.msg == "field \"datr\" of rxpk structure from json object should have " ~
            "\"STRING\" type, but it have \"INTEGER\" type!")
          {
            throw new LorawanException("field \"datr\" of rxpk structure from json object in \"LORA\" mode should " ~
              "have \"STRING\" type, but it have \"" ~ to!string(jsonRxpkArrayElement["datr"].type) ~ "\" type!");
          }
          else
          {
            if(lorawanException.msg == "rxpk structure from json object should have field \"datr\"!")
            {
              throw new LorawanException("rxpk structure from json object in \"LORA\" mode " ~
                "should have field \"datr\"!");
            }
            else
            {
               throw new LorawanException(lorawanException.msg);
            }  
          }
        }
        catch(Exception exception)
        {
          throw new Exception(exception.msg);
        }
      }
            
      return result; 
    }
    
    Nullable!uint getFskDatarate(ModulationIdentifier modulationIdentifier, JSONValue jsonRxpkArrayElement)
    {
      Nullable!uint result;
      
      if(modulationIdentifier == ModulationIdentifier.FSK)
      {
        try
        {
          result = getValueFromJsonByKey!uint("datr", jsonRxpkArrayElement, Structures.RXPK);
        }
        catch(LorawanException lorawanException)
        {
          if(lorawanException.msg == "field \"datr\" of rxpk structure from json object should have " ~
            "\"UINTEGER\" type, but it have \"STRING\" type!")
          {
            throw new LorawanException("field \"datr\" of rxpk structure from json object in \"FSK\" mode should " ~
             "have \"UINTEGER\" type, but it have \"" ~ to!string(jsonRxpkArrayElement["datr"].type) ~ "\" type!");
          }
        }
        catch(Exception exception)
        {
          throw new Exception(exception.msg);
        }
      }  

      return result; 
    }
    
    Nullable!MacPacket getData(JSONValue jsonRxpkArrayElement)
    {
      Nullable!MacPacket result;
      
      if(("data" in jsonRxpkArrayElement) !is null)
      {
        if(jsonRxpkArrayElement["data"].type != JSON_TYPE.STRING)
        {
          throw new LorawanException("field \"data\" of rxpk structure from json object should have " ~
            "\"STRING\" type, but it have \"" ~ to!string(jsonRxpkArrayElement["data"].type) ~"\" type!");
        }
        result = new MacPacket;
        result.setData(jsonRxpkArrayElement["data"].str);
      }
      
      return result;
    }          
}