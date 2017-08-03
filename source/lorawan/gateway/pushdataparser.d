/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pushdataparser;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawanexception;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.parserinterface;
import lorawan.gateway.pushdatapacket;
import std.conv;
import std.datetime;
import std.json;

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
    if(data.length <= 12){ return null; }
    else if(data[0] != ProtocolVersion.VERSION_2){ return null; }
    else if(data[3] != PacketType.PUSH_DATA){ return null; }
    else
    {
      PushDataPacket result = new PushDataPacket;
      
      Rxpk[] rxpkArray;
      Stat statStructure;
      
      JSONValue jsonValue = parseJSON(cast(string) data[12..$]);
      if(jsonValue.isNull()){ return null; }
      
      // jsonValue parsing...
      if((("rxpk" in jsonValue) is null) && (("stat" in jsonValue) is null))
      { 
        throw new LorawanException("json object should contain at least on of this: rxpk array or stat structure!");
      }
      
      if(("stat" in jsonValue) !is null)
      {
        if(jsonValue["stat"].type != JSON_TYPE.OBJECT)
        {
          throw new LorawanException("field \"stat\" of json object should have OBJECT type, but it have '" ~
            jsonValue["stat"].type ~ "' type!");
        }
        
        // parsing of the stat structure...
        JSONValue jsonStatStructure = jsonValue["stat"];
        
        if(("time" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["time"].type != JSON_TYPE.STRING)
          {
            throw new LorawanException("field \"time\" of stat structure from json object should have STRING type, but it have '" ~
              jsonStatStructure["time"].type ~"' type!");
          }
          SysTime time = SysTime.fromISOExtString(jsonStatStructure["time"].str);
          statStructure.setTime(time);
        }
        
        if(("latn" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["latn"].type != JSON_TYPE.FLOAT)
          {
            throw new LorawanException("field \"latn\" of stat structure from json object should have FLOAT type, but it have '" ~
              jsonStatStructure["latn"].type ~ "' type!");
          }
          double latn = jsonStatStructure["latn"].floating;
          statStructure.setLatn(latn);
        }
        
        if(("late" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["late"].type != JSON_TYPE.FLOAT)
          {
            throw new LorawanException("field \"late\" of stat structure from json object should have FLOAT type, but it have '" ~
              jsonStatStructure["late"].type ~ "' type!");
          }
          double late = jsonStatStructure["late"].floating;
          statStructure.setLate(late);
        }        
 
        if(("alti" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["alti"].type != JSON_TYPE.INTEGER)
          {
            throw new LorawanException("field \"alti\" of stat structure from json object should have INTEGER type, but it have '" ~
              jsonStatStructure["alti"].type ~ "' type!");
          }
          int alti = to!int(jsonStatStructure["alti"].integer);
          statStructure.setAlti(alti);
        }
        
        if(("rxnb" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["rxnb"].type != JSON_TYPE.UINTEGER)
          {
            throw new LorawanException("field \"rxnb\" of stat structure from json object should have UINTEGER type, but it have '" ~
              jsonStatStructure["rxnb"].type ~ "' type!");
          }
          ulong rxnb = jsonStatStructure["rxnb"].uinteger;
          statStructure.setRxnb(rxnb);
        }
        
        if(("rxok" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["rxok"].type != JSON_TYPE.UINTEGER)
          {
            throw new LorawanException("field \"rxok\" of stat structure from json object should have UINTEGER type, but it have '" ~
              jsonStatStructure["rxok"].type ~ "' type!");
          }
          ulong rxok = jsonStatStructure["rxok"].uinteger;
          statStructure.setRxok(rxok);
        }
        
        if(("rxfw" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["rxfw"].type != JSON_TYPE.UINTEGER)
          {
            throw new LorawanException("field \"rxfw\" of stat structure from json object should have UINTEGER type, but it have '" ~
              jsonStatStructure["rxfw"].type ~ "' type!");
          }
          ulong rxfw = jsonStatStructure["rxfw"].uinteger;
          statStructure.setRxfw(rxfw);
        }
        
        if(("ackr" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["ackr"].type != JSON_TYPE.INTEGER)
          {
            throw new LorawanException("field \"ackr\" of stat structure from json object should have INTEGER type, but it have '" ~
              jsonStatStructure["ackr"].type ~ "' type!");
          }
          int ackr = to!int(jsonStatStructure["ackr"].integer);
          statStructure.setAckr(ackr);
        }
        
        if(("dwnb" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["dwnb"].type != JSON_TYPE.UINTEGER)
          {
            throw new LorawanException("field \"dwnb\" of stat structure from json object should have UINTEGER type, but it have '" ~
              jsonStatStructure["dwnb"].type ~ "' type!");
          }
          uint dwnb = to!uint(jsonStatStructure["dwnb"].uinteger);
          statStructure.setDwnb(dwnb);
        }
        
        if(("txnb" in jsonStatStructure) !is null)
        {
          if(jsonStatStructure["txnb"].type != JSON_TYPE.UINTEGER)
          {
            throw new LorawanException("field \"txnb\" of stat structure from json object should have UINTEGER type, but it have '" ~
              jsonStatStructure["txnb"].type ~ "' type!");
          }
          uint txnb = to!uint(jsonStatStructure["txnb"].uinteger);
          statStructure.setTxnb(txnb);
        }
      }
            
      if(("rxpk" in jsonValue) !is null)
      {
        if(jsonValue["rxpk"].type != JSON_TYPE.ARRAY)
        {
          throw new LorawanException("field \"rxpk\" of json object should have ARRAY type, but it have '" ~
            jsonValue["rxpk"].type ~ "' type!");
        }
        
        // parsing of the rxpk array...
        JSONValue jsonRxpkArray = jsonValue["rxpk"];
        foreach(JSONValue jsonRxpkArrayElement; jsonRxpkArray)
        {
          CrcStatus crcStatus;
          ModulationIdentifier modulationIdentifier;
          LoraDatarate loraDatarate;
          uint fskDatarate;
          
          if(("stat" in jsonRxpkArrayElement) !is null)
          {
            if(jsonRxpkArrayElement["stat"].type != JSON_TYPE.INTEGER)
            {
              throw new LorawanException("field \"stat\" of stat structure from json object should have INTEGER type, but it have '" ~
                jsonRxpkArrayElement["stat"].type ~ "' type!");
            }
            byte statByte = to!byte(jsonRxpkArrayElement["stat"].integer);
            switch(statByte)
            {
              case 0 : crcStatus = CrcStatus.NO_CRC; break;
              case 1 : crcStatus = CrcStatus.OK; break;
              case -1 : crcStatus = CrcStatus.FAIL; break;
              default: 
                throw new LorawanException("field \"stat\" of stat structure from json object should have one of this values:
                0 - NO_CRC, 1 - OK, -1 - FAIL, but it has the value '" ~ to!string(statByte) ~ "'");
            }
          }
          else
          {
            throw new LorawanException("stat structure from json object should have field \"stat\"!");
          }        
          
          if(("modu" in jsonRxpkArrayElement) !is null)
          {
            if(jsonRxpkArrayElement["modu"].type != JSON_TYPE.STRING)
            {
              throw new LorawanException("field \"modu\" of stat structure from json object should have STRING type, but it have '" ~
                jsonRxpkArrayElement["modu"].type ~ "' type!");
            }
            string moduString = jsonRxpkArrayElement["modu"].str;
            switch(moduString)
            {
              case "LORA" : modulationIdentifier = ModulationIdentifier.LORA; break;
              case "FSK" : modulationIdentifier = ModulationIdentifier.FSK; break;
              default: 
                throw new LorawanException("field \"modu\" of stat structure from json object should have one of this values:
                \"LORA\" or \"FSK\", but it has the value '" ~ moduString ~ "'");
            }
          }
          else
          {
            throw new LorawanException("stat structure from json object should have field \"modu\"!");
          }
          
          if(("datr" in jsonRxpkArrayElement) !is null)
          {
            if(modulationIdentifier == ModulationIdentifier.LORA)
            {
              // Moulation identifier == "LORA"
              
              if(jsonRxpkArrayElement["datr"].type != JSON_TYPE.STRING)
              {
                throw new LorawanException("field \"datr\" of stat structure from json object in \"LORA\" mode should have STRING type, but it have '" ~
                  jsonRxpkArrayElement["datr"].type ~ "' type!");
              }
              string datrString = jsonRxpkArrayElement["datr"].str;
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
                  throw new LorawanException("field \"datr\" of stat structure from json object in \"LORA\" mode should 
                  have 'SF' value from 6 to 12 and one of this 'BW' value: '125, '250' or '500' (for example: \"SF11BW250\"), but it has the value '" ~
                  datrString ~ "'");
              }
            }
            else
            {
              // Moulation identifier == "FSK"
              
              if(jsonRxpkArrayElement["datr"].type != JSON_TYPE.UINTEGER)
              {
                throw new LorawanException("field \"datr\" of stat structure from json object in \"FSK\" mode should have UINTEGER type, but it have '" ~
                  jsonRxpkArrayElement["datr"].type ~ "' type!");
              }
              fskDatarate = to!uint(jsonRxpkArrayElement["datr"].uinteger);
            }
          }
          else
          {
            throw new LorawanException("stat structure from json object should have field \"datr\"!");
          }
          
          
          Rxpk newRxpk;
        }
        
//    Nullable!SysTime _time; //UTC time of pkt RX, us precision, ISO 8601 'compact' format
//    Nullable!ulong _tmms; //GPS time of pkt RX, number of milliseconds since 06.Jan.1980
//    Nullable!uint _tmst; //Internal timestamp of "RX finished" event (32b unsigned)
//    Nullable!double _freq; //RX central frequency in MHz (double, Hz precision)
//    Nullable!ubyte _chan; //Concentrator "IF" channel used for RX (unsigned byte)
//    Nullable!uint _rfch; //Concentrator "RF chain" used for RX (unsigned integer)
//    CyclicCodingRate _codr; //LoRa ECC coding rate identifier
//    Nullable!short _rssi; //RSSI in dBm (signed short, 1 dB precision)
//    Nullable!float _lsnr; //Lora SNR ratio in dB (signed float, 0.1 dB precision)
//    Nullable!uint _size; //RF packet payload size in bytes (unsigned integer)
//    MacPacket _data; //Base64 encoded RF packet payload, padded
        
      } 
      
      result.setProtocolVersion(ProtocolVersion.VERSION_2);
      result.setToken(data[1..3]);
      result.setGatewayID(data[4..12]);
      result.setStatStruct(statStructure);
      
      return result;
    }
  }
}