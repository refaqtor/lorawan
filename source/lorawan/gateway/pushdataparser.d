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
          CrcStatus crcStatus;
          ModulationIdentifier modulationIdentifier;
          LoraDatarate loraDatarate;
          CyclicCodingRate cyclicCodingRate;
          
          if(("stat" in jsonRxpkArrayElement) !is null)
          {
            if(jsonRxpkArrayElement["stat"].type != JSON_TYPE.INTEGER)
            {
              throw new LorawanException("field \"stat\" of rxpk structure from json object should have \"INTEGER\" " ~
                "type, but it have \"" ~ to!string(jsonRxpkArrayElement["stat"].type) ~ "\" type!");
            }
            byte statByte = to!byte(jsonRxpkArrayElement["stat"].integer);
            switch(statByte)
            {
              case 0 : crcStatus = CrcStatus.NO_CRC; break;
              case 1 : crcStatus = CrcStatus.OK; break;
              case -1 : crcStatus = CrcStatus.FAIL; break;
              default: 
                throw new LorawanException("field \"stat\" of rxpk structure from json object should have one of " ~
                  "this values: \"0\" - NO_CRC, \"1\" - OK, \"-1\" - FAIL, but it has the value \"" ~
                  to!string(statByte) ~ "\"");
            }
          }
          else
          {
            throw new LorawanException("rxpk structure from json object should have field \"stat\"!");
          }        
          
          if(("modu" in jsonRxpkArrayElement) !is null)
          {
            if(jsonRxpkArrayElement["modu"].type != JSON_TYPE.STRING)
            {
              throw new LorawanException("field \"modu\" of rxpk structure from json object should have " ~
                "\"STRING\" type, but it have \"" ~ to!string(jsonRxpkArrayElement["modu"].type) ~ "\" type!");
            }
            const string moduString = jsonRxpkArrayElement["modu"].str;
            switch(moduString)
            {
              case "LORA" : modulationIdentifier = ModulationIdentifier.LORA; break;
              case "FSK" : modulationIdentifier = ModulationIdentifier.FSK; break;
              default: 
                throw new LorawanException("field \"modu\" of rxpk structure from json object should have " ~
                  "one of this values: \"LORA\" or \"FSK\", but it has the value \"" ~ moduString ~ "\"");
            }
          }
          else
          {
            throw new LorawanException("rxpk structure from json object should have field \"modu\"!");
          }
          
          if(modulationIdentifier == ModulationIdentifier.LORA)
          {
            if(("datr" in jsonRxpkArrayElement) !is null)
            {              
              if(jsonRxpkArrayElement["datr"].type != JSON_TYPE.STRING)
              {
                throw new LorawanException("field \"datr\" of rxpk structure from json object in " ~
                  "\"LORA\" mode should have \"STRING\" type, but it have \"" ~
                  to!string(jsonRxpkArrayElement["datr"].type) ~ "\" type!");
              }
              const string datrString = jsonRxpkArrayElement["datr"].str;
              switch(datrString)
              {
                case "SF6BW125" : loraDatarate = LoraDatarate.SF_6_BW_125; break;
                case "SF6BW250" : loraDatarate = LoraDatarate.SF_6_BW_250; break;
                case "SF6BW500" : loraDatarate = LoraDatarate.SF_6_BW_500; break;
                case "SF7BW125" : loraDatarate = LoraDatarate.SF_7_BW_125; break;
                case "SF7BW250" : loraDatarate = LoraDatarate.SF_7_BW_250; break;
                case "SF7BW500" : loraDatarate = LoraDatarate.SF_7_BW_500; break;
                case "SF8BW125" : loraDatarate = LoraDatarate.SF_8_BW_125; break;
                case "SF8BW250" : loraDatarate = LoraDatarate.SF_8_BW_250; break;
                case "SF8BW500" : loraDatarate = LoraDatarate.SF_8_BW_500; break;
                case "SF9BW125" : loraDatarate = LoraDatarate.SF_9_BW_125; break;
                case "SF9BW250" : loraDatarate = LoraDatarate.SF_9_BW_250; break;
                case "SF9BW500" : loraDatarate = LoraDatarate.SF_9_BW_500; break;
                case "SF10BW125" : loraDatarate = LoraDatarate.SF_10_BW_125; break;
                case "SF10BW250" : loraDatarate = LoraDatarate.SF_10_BW_250; break;
                case "SF10BW500" : loraDatarate = LoraDatarate.SF_10_BW_500; break;
                case "SF11BW125" : loraDatarate = LoraDatarate.SF_11_BW_125; break;
                case "SF11BW250" : loraDatarate = LoraDatarate.SF_11_BW_250; break;
                case "SF11BW500" : loraDatarate = LoraDatarate.SF_11_BW_500; break;
                case "SF12BW125" : loraDatarate = LoraDatarate.SF_12_BW_125; break;
                case "SF12BW250" : loraDatarate = LoraDatarate.SF_12_BW_250; break;
                case "SF12BW500" : loraDatarate = LoraDatarate.SF_12_BW_500; break;
                default: 
                  throw new LorawanException("field \"datr\" of rxpk structure from json object in \"LORA\" " ~
                    "mode should have \"SF\" value from 6 to 12 and one of this \"BW\" value: \"125\", \"250\" " ~
                    "or \"500\" (for example: \"SF11BW250\"), but it has the value \"" ~ datrString ~ "\"");
              }
            }
            else
            {
              throw new LorawanException("rxpk structure from json object in \"LORA\" mode should " ~
                "have field \"datr\"!");
            }
          }
          
          if(("codr" in jsonRxpkArrayElement) !is null)
          {
            if(jsonRxpkArrayElement["codr"].type != JSON_TYPE.STRING)
            {
              throw new LorawanException("field \"codr\" of rxpk structure from json object should " ~
                "have \"STRING\" type, but it have \"" ~ to!string(jsonRxpkArrayElement["codr"].type) ~
                "\" type!");
            }
            const string codrString = jsonRxpkArrayElement["codr"].str;
            switch(codrString)
            {
              case "4/5" : cyclicCodingRate = CyclicCodingRate.CR_4_5; break;
              case "4/6" : cyclicCodingRate = CyclicCodingRate.CR_4_6; break;
              case "4/7" : cyclicCodingRate = CyclicCodingRate.CR_4_7; break;
              case "4/8" : cyclicCodingRate = CyclicCodingRate.CR_4_8; break;
              default: 
                throw new LorawanException("field \"codr\" of rxpk structure from json object should " ~
                  "have one of this values: \"4/5\", \"4/6\", \"4/7\" or \"4/8\", but it has the value \"" ~
                  codrString ~ "\"");
            }
          }
          else
          {
            throw new LorawanException("stat structure from json object should have field \"codr\"!");
          }
          
          Rxpk newRxpk;
          
          newRxpk.setStat(crcStatus);
          newRxpk.setModu(modulationIdentifier);
          newRxpk.setDatr(loraDatarate);
          newRxpk.setCodr(cyclicCodingRate);
          
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
          
          import std.stdio;
          if(("tmms" in jsonRxpkArrayElement) !is null)writeln(to!string(jsonRxpkArrayElement["tmms"].type));
          
          Nullable!ulong tmms = getValueFromJsonByKey!ulong("tmms", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint tmst = getValueFromJsonByKey!uint("tmst", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!double freq = getValueFromJsonByKey!double("freq", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!ubyte chan = getValueFromJsonByKey!ubyte("chan", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint rfch = getValueFromJsonByKey!uint("rfch", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!short rssi = getValueFromJsonByKey!short("rssi", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!float lsnr = getValueFromJsonByKey!float("lsnr", jsonRxpkArrayElement, Structures.RXPK);
          Nullable!uint size = getValueFromJsonByKey!uint("size", jsonRxpkArrayElement, Structures.RXPK);
          
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
}