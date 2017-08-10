/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pullrespparser;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawanexception;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.macpacket;
import lorawan.gateway.parserinterface;
import lorawan.gateway.pullresppacket;
import lorawan.utils.parserhelper;
import std.algorithm;
import std.conv;
import std.json;
import std.typecons;

/// Parser for PULL_RESP packets
class PullRespParser : ParserInterface
{
  /** Used to parse byte array which represent PULL_RESP packet
  
    Params:
      data = byte array for parsing
      
    Returns:
      $(D AbstractPacket)  
  */
  AbstractPacket parse(in ubyte[] data)
  {
    if(data.length <= 4)
    { 
      return null;
    }
    if(data[0] != ProtocolVersion.VERSION_2)
    {
      return null;
    }
    if(data[3] != PacketType.PULL_RESP)
    {
      return null;
    }
    else
    {
      PullRespPacket result = new PullRespPacket;
      
      JSONValue jsonValue = parseJSON(cast(string) data[4..$]);
      
      if(jsonValue.isNull())
      { 
        throw new LorawanException("byte array should contain json object, " ~
          "but recieved array contain only \"null\" json object!");
      }
      
      // jsonValue parsing...
      if(("txpk" in jsonValue) is null)
      { 
        throw new LorawanException("json object should contain \"txpk\" field!");
      }
      
      if(jsonValue["txpk"].type != JSON_TYPE.OBJECT)
      {
        throw new LorawanException("field \"txpk\" of json object " ~
          "should have \"OBJECT\" type, but it have \"" ~ to!string(jsonValue["txpk"].type) ~ "\" type!");
      }
      
      // parsing of the txpk structure...
      JSONValue jsonTxpkStructure = jsonValue["txpk"];
      
      // These fields have an enumeration type and they are mandatory in the txpk structure
      Nullable!ModulationIdentifier modulationIdentifier;
      Nullable!LoraDatarate loraDatarate;
      Nullable!CyclicCodingRate cyclicCodingRate;
      
      // Get the required fields txpk structure         
      modulationIdentifier = getEnumValueFromJsonByKey!(string, ModulationIdentifier)
      ("modu", jsonTxpkStructure, NamesOfStructures.TXPK);
          
      loraDatarate = getLoraDatarate(modulationIdentifier, jsonTxpkStructure, NamesOfStructures.TXPK); 
          
      cyclicCodingRate = getEnumValueFromJsonByKey!(string, CyclicCodingRate)
      ("codr", jsonTxpkStructure, NamesOfStructures.TXPK);
          
      // Initialize the required fields txpk structure
      Txpk txpkStructure;
          
      txpkStructure.setModu(modulationIdentifier);
      txpkStructure.setCodr(cyclicCodingRate);
      if(!loraDatarate.isNull){ txpkStructure.setDatr(loraDatarate); }
      
      // Get the optional fields of the txpk structure
      Nullable!bool imme = getBoolValueFromJsonByKey("imme", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!bool ipol = getBoolValueFromJsonByKey("ipol", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!bool ncrc = getBoolValueFromJsonByKey("ncrc", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!uint powe = getValueFromJsonByKey!uint("powe", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!uint fdev = getValueFromJsonByKey!uint("fdev", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!uint prea = getValueFromJsonByKey!uint("prea", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!uint fskDatarate = getFskDatarate(modulationIdentifier, jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!ulong tmms = getValueFromJsonByKey!ulong("tmms", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!uint tmst = getValueFromJsonByKey!uint("tmst", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!double freq = getValueFromJsonByKey!double("freq", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!ubyte chan = getValueFromJsonByKey!ubyte("chan", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!uint rfch = getValueFromJsonByKey!uint("rfch", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!uint size = getValueFromJsonByKey!uint("size", jsonTxpkStructure, NamesOfStructures.TXPK);
      Nullable!MacPacket txpkData = getData(jsonTxpkStructure, NamesOfStructures.TXPK);
          
      // Set the optional fields of the txpk structure
      if(!imme.isNull){ txpkStructure.setImme(imme); }
      if(!ipol.isNull){ txpkStructure.setIpol(ipol); }
      if(!ncrc.isNull){ txpkStructure.setNcrc(ncrc); }
      if(!powe.isNull){ txpkStructure.setPowe(powe); }
      if(!fdev.isNull){ txpkStructure.setFdev(fdev); }
      if(!prea.isNull){ txpkStructure.setPrea(prea); }
      if(!fskDatarate.isNull){ txpkStructure.setDatr(fskDatarate); }
      if(!tmms.isNull){ txpkStructure.setTmms(tmms); }
      if(!tmst.isNull){ txpkStructure.setTmst(tmst); }
      if(!freq.isNull){ txpkStructure.setFreq(freq); }
      if(!chan.isNull){ txpkStructure.setChan(chan); }
      if(!rfch.isNull){ txpkStructure.setRfch(rfch); }
      if(!size.isNull){ txpkStructure.setSize(size); }
      if(!txpkData.isNull){ txpkStructure.setData(txpkData); }        
      
      result.setTxpkStruct(txpkStructure);
      result.setProtocolVersion(ProtocolVersion.VERSION_2);
      result.setToken(data[1..3]);
      
      return result;
    }
  }
  
  private:
    Nullable!bool getBoolValueFromJsonByKey(string key, JSONValue jsonValue, NamesOfStructures structureName)
    {
      Nullable!bool result;
       
      if((key in jsonValue) !is null)
      {
        JSON_TYPE[] expectedJsonTypeArr = [JSON_TYPE.TRUE, JSON_TYPE.FALSE];
        JSON_TYPE realJsonType = jsonValue[key].type;
        if(!canFind(expectedJsonTypeArr, realJsonType))
        {
          throw new LorawanException("field \"" ~ key ~ "\" of " ~ structureName ~ 
            " structure from json object should have one of this types: " ~
            "\"TRUE\" or \"FALSE\", but it have \"" ~to!string(realJsonType) ~ "\" type!");
        }
                 
        switch(realJsonType)
        {
          case JSON_TYPE.TRUE : result = true; break;
          case JSON_TYPE.FALSE : result = false; break;
          default : break;
        }
      }
       
      return result;
    }
}