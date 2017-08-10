/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.txackparser;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawanexception;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.parserinterface;
import lorawan.gateway.txackpacket;
import std.conv;
import std.json;
import std.traits;
import std.typecons;

/// Parser for PULL_RESP packets
class TxAckParser : ParserInterface
{
  /** Used to parse byte array which represent TX_ACK packet
  
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
    if(data[0] != ProtocolVersion.VERSION_2)
    {
      return null;
    }
    if(data[3] != PacketType.TX_ACK)
    {
      return null;
    }
    else
    {
      TxAckPacket result = new TxAckPacket;
      
      JSONValue jsonValue = parseJSON(cast(string) data[12..$]);
      
      if(jsonValue.isNull())
      { 
        throw new LorawanException("byte array should contain json object, " ~
          "but recieved array contain only \"null\" json object!");
      }
      
      // jsonValue parsing...
      if(("txpk_ack" in jsonValue) is null)
      { 
        throw new LorawanException("json object should contain \"txpk_ack\" field!");
      }
      
      if(jsonValue["txpk_ack"].type != JSON_TYPE.OBJECT)
      {
        throw new LorawanException("field \"txpk_ack\" of json object " ~
          "should have \"OBJECT\" type, but it have \"" ~ to!string(jsonValue["txpk_ack"].type) ~ "\" type!");
      }
      
      // parsing of the txpk_ack structure...
      JSONValue jsonTxpkAckStructure = jsonValue["txpk_ack"];
      
      // This field have an enumeration type and it's mandatory in the txpk_ack structure
      DownlinkRequestError downlinkRequestError;
      
      // Get the required field txpk_ack structure         
      downlinkRequestError = getErrorFromJsonByKey("error", jsonTxpkAckStructure, NamesOfStructures.TXPK_ACK);
          
      // Initialize the required fields txpk structure
      TxpkAck txpkAckStructure;
          
      txpkAckStructure.setError(downlinkRequestError);    
      
      result.setTxpkAckStruct(txpkAckStructure);
      result.setProtocolVersion(ProtocolVersion.VERSION_2);
      result.setToken(data[1..3]);
      result.setGatewayID(data[4..12]);
      
      return result;
    }
  }
  
  private:
    DownlinkRequestError getErrorFromJsonByKey(string key, JSONValue jsonValue, NamesOfStructures structureName)
    {
      DownlinkRequestError result;
        
      if((key in jsonValue) !is null)
      {
        JSON_TYPE expectedJsonType = JSON_TYPE.STRING;
        JSON_TYPE realJsonType = jsonValue[key].type;
        if(realJsonType != expectedJsonType)
        {
          throw new LorawanException("field \"" ~ key ~ "\" of " ~ structureName ~
            " structure from json object should have \"" ~ to!string(expectedJsonType) ~
            "\" type, but it have \"" ~ to!string(realJsonType) ~ "\" type!");
        }
         
        string valueFromJson = to!string(jsonValue[key].str);
          
        string[] enumStringArray = [];
        foreach (immutable enumValue; [EnumMembers!DownlinkRequestError])
        {
          enumStringArray ~= "\"" ~ to!string(enumValue) ~ "\"";
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
         
        DownlinkRequestError enumValue;
        try
        {
          enumValue = to!DownlinkRequestError(valueFromJson);
        }
        catch(Exception e)
        {
          throw new LorawanException("field \"" ~ key ~ "\" of " ~ structureName ~
            " structure from json object should have one of this values: " ~ enumString ~
            ", but it has the value \"" ~ to!string(valueFromJson) ~ "\"");
        }
      }
      else
      {
        throw new LorawanException(structureName ~ " structure from json object should have field \"" ~ key ~ "\"!");
      }
        
      return result;
    }
}