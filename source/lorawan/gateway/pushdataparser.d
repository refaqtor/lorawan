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
        
        if(("time" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["time"].type != JSON_TYPE.STRING)
          {
            throw new LorawanException("field \"time\" of stat structure from json object " ~
              "should have \"STRING\" type, but it have \"" ~ to!string(jsonStatStructure["time"].type) ~ "\" type!");
          }
          SysTime time = SysTime.fromISOExtString(jsonStatStructure["time"].str);
          statStructure.setTime(time);
        }
        
        Nullable!double latn = getValueFromJsonByKey!double("latn", jsonStatStructure, Structures.STAT);
        Nullable!double late = getValueFromJsonByKey!double("late", jsonStatStructure, Structures.STAT);
        Nullable!int alti = getValueFromJsonByKey!int("alti", jsonStatStructure, Structures.STAT);
        Nullable!ulong rxnb = getValueFromJsonByKey!ulong("rxnb", jsonStatStructure, Structures.STAT);
        Nullable!ulong rxok = getValueFromJsonByKey!ulong("rxok", jsonStatStructure, Structures.STAT);
        Nullable!ulong rxfw = getValueFromJsonByKey!ulong("rxfw", jsonStatStructure, Structures.STAT);
        Nullable!int ackr = getValueFromJsonByKey!int("ackr", jsonStatStructure, Structures.STAT);
        Nullable!uint dwnb = getValueFromJsonByKey!uint("dwnb", jsonStatStructure, Structures.STAT);
        Nullable!uint txnb = getValueFromJsonByKey!uint("txnb", jsonStatStructure, Structures.STAT);
        
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
          
          //These fields have an enumeration type and they are mandatory in the rxpk structure
          Nullable!CrcStatus crcStatus;
          Nullable!ModulationIdentifier modulationIdentifier;
          Nullable!LoraDatarate loraDatarate;
          Nullable!CyclicCodingRate cyclicCodingRate;
          
          // get CRC status
          crcStatus = getEnumValueFromJsonByKey!(byte, CrcStatus)("stat", jsonRxpkArrayElement, Structures.RXPK);
          // get modulation identifier (LORA or FSK)
          modulationIdentifier = getEnumValueFromJsonByKey!(string, ModulationIdentifier)("modu", jsonRxpkArrayElement, Structures.RXPK);
          // get datarate in LORA mode
          if(modulationIdentifier == ModulationIdentifier.LORA)
          {
            try
            {
              loraDatarate = getEnumValueFromJsonByKey!(string, LoraDatarate)("datr", jsonRxpkArrayElement, Structures.RXPK);
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
                  throw new LorawanException("rxpk structure from json object in \"LORA\" mode should have field \"datr\"!");
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
          // get cyclic coding rate 
          cyclicCodingRate = getEnumValueFromJsonByKey!(string, CyclicCodingRate)("codr", jsonRxpkArrayElement, Structures.RXPK);
          
          // get the optional fields of the rxpk structure
          Rxpk newRxpk;
          
          if(("time" in jsonRxpkArrayElement) !is null)
          {
            if(jsonRxpkArrayElement["time"].type != JSON_TYPE.STRING)
            {
              throw new LorawanException("field \"time\" of rxpk structure from json object should have \"STRING\" " ~
              "type, but it have \"" ~ to!string(jsonRxpkArrayElement["time"].type) ~"\" type!");
            }
            SysTime time = SysTime.fromISOString(jsonRxpkArrayElement["time"].str);
            newRxpk.setTime(time);
          }

          if(modulationIdentifier == ModulationIdentifier.FSK)
          {
            try
            {
              Nullable!uint datr = getValueFromJsonByKey!uint("datr", jsonRxpkArrayElement, Structures.RXPK);
              if(!datr.isNull){ newRxpk.setDatr(datr); }
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
          
          Nullable!ulong tmms = getValueFromJsonByKey!ulong("tmms", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint tmst = getValueFromJsonByKey!uint("tmst", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!double freq = getValueFromJsonByKey!double("freq", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!ubyte chan = getValueFromJsonByKey!ubyte("chan", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint rfch = getValueFromJsonByKey!uint("rfch", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!short rssi = getValueFromJsonByKey!short("rssi", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!float lsnr = getValueFromJsonByKey!float("lsnr", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint size = getValueFromJsonByKey!uint("size", jsonRxpkArrayElement, Structures.RXPK);
          
          if(!crcStatus.isNull){ newRxpk.setStat(crcStatus); }
          if(!modulationIdentifier.isNull){ newRxpk.setModu(modulationIdentifier); }
          if(!loraDatarate.isNull){ newRxpk.setDatr(loraDatarate); }
          if(!cyclicCodingRate.isNull){ newRxpk.setCodr(cyclicCodingRate); }
          if(!tmms.isNull){ newRxpk.setTmms(tmms); }
          if(!tmst.isNull){ newRxpk.setTmst(tmst); }
          if(!freq.isNull){ newRxpk.setFreq(freq); }
          if(!chan.isNull){ newRxpk.setChan(chan); }
          if(!rssi.isNull){ newRxpk.setRssi(rssi); }
          if(!rssi.isNull){ newRxpk.setRfch(rfch); }
          if(!lsnr.isNull){ newRxpk.setLsnr(lsnr); }
          if(!size.isNull){ newRxpk.setSize(size); }
          
          if(("data" in jsonRxpkArrayElement) !is null)
          {
            if(jsonRxpkArrayElement["data"].type != JSON_TYPE.STRING)
            {
              throw new LorawanException("field \"data\" of rxpk structure from json object should have " ~
                "\"STRING\" type, but it have \"" ~ to!string(jsonRxpkArrayElement["data"].type) ~"\" type!");
            }
            MacPacket macPacket = new MacPacket;
            macPacket.setData(jsonRxpkArrayElement["data"].str);
            newRxpk.setData(macPacket);
          }
          
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
            throw new LorawanException("field \"" ~ key ~ "\" of " ~ structureName ~ " structure from json object should have \"" ~
              to!string(expectedJsonType) ~ "\" type, but it have \"" ~ to!string(realJsonType) ~ "\" type!");
          }
        }
        
        T valueFromJson;
        switch(realJsonType)
        {
          case JSON_TYPE.STRING : valueFromJson = to!T(jsonValue[key].str); break;
          case JSON_TYPE.INTEGER : valueFromJson = to!T(jsonValue[key].integer); break;
          case JSON_TYPE.UINTEGER : valueFromJson = to!T(jsonValue[key].uinteger); break;
          case JSON_TYPE.FLOAT : valueFromJson = to!T(jsonValue[key].floating); break;
          default : break;
        }
        
        import std.traits;
        string[] enumStringArray = [];
        foreach (immutable enumValue; [EnumMembers!E])
        {
          enumStringArray ~= "\"" ~ to!string(cast(T)(enumValue)) ~ "\"";
        }
        
        string enumString = "";
        for(int i = 0; i < enumStringArray.length - 2; i++)
        {
          enumString ~= enumStringArray[i] ~ ", ";
        }
        enumString ~= enumStringArray[enumStringArray.length - 2] ~ " or " ~ enumStringArray[enumStringArray.length - 1];
        
        
        E enumValue = cast(E)(valueFromJson);
        if(to!string(enumValue) != "cast(" ~ E.stringof ~ ")" ~ to!string(valueFromJson))
        {
          result = enumValue;
        }
        else
        {
          throw new LorawanException("field \"" ~ key ~ "\" of " ~ structureName ~ " structure from json object should have " ~
            "one of this values: " ~ enumString ~ ", but it has the value \"" ~ to!string(valueFromJson) ~ "\"");
        }
        
//        try
//        {
//          E enumValue = to!E(valueFromJson);
//          result = enumValue;
//        }
//        catch(Exception exception)
//        {
//          import std.stdio;
//          writeln(valueFromJson);
//          throw new LorawanException("field \"" ~ key ~ "\" of " ~ structureName ~ " structure from json object should have " ~
//            "one of this values: " ~ enumString ~ ", but it has the value \"" ~ to!string(valueFromJson) ~ "\"");
//        }
      }
      else
      {
        throw new LorawanException("rxpk structure from json object should have field \"" ~ key ~ "\"!");
      }
      
      return result;
    }
}