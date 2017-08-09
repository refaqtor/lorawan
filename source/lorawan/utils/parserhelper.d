/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.utils.parserhelper;

import lorawan.gateway.lorawanexception;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.macpacket;
import std.conv;
import std.json;
import std.traits;
import std.typecons;

static Nullable!T getValueFromJsonByKey(T)(string key, JSONValue jsonValue, NamesOfStructures structureName)
{
  Nullable!T result;
   
  if((key in jsonValue) !is null)
  {
    JSON_TYPE expectedJsonType = dlangToJsonTypes[T.stringof];
    JSON_TYPE realJsonType = jsonValue[key].type;
    if(realJsonType != expectedJsonType)
    {
      if(!((realJsonType == JSON_TYPE.INTEGER && expectedJsonType == JSON_TYPE.UINTEGER) ||
      ((realJsonType == JSON_TYPE.INTEGER || realJsonType == JSON_TYPE.UINTEGER) &&
      expectedJsonType == JSON_TYPE.FLOAT)))
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

static Nullable!E getEnumValueFromJsonByKey(T, E)(string key, JSONValue jsonValue, NamesOfStructures structureName)
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
    throw new LorawanException(structureName ~ " structure from json object should have field \"" ~ key ~ "\"!");
  }
    
  return result;
}

static Nullable!LoraDatarate getLoraDatarate(ModulationIdentifier modulationIdentifier,
  JSONValue jsonValue, NamesOfStructures structureName)
{
  Nullable!LoraDatarate result;
   
  if(modulationIdentifier == ModulationIdentifier.LORA)
  {
    try
    {
      result = getEnumValueFromJsonByKey!(string, LoraDatarate)("datr", jsonValue, structureName);
    }
    catch(LorawanException lorawanException)
    {
      if(lorawanException.msg == "field \"datr\" of " ~ structureName ~ " structure from json object should have " ~
        "\"STRING\" type, but it have \"INTEGER\" type!")
      {
        throw new LorawanException("field \"datr\" of " ~ structureName ~ " structure from json object in " ~
          "\"LORA\" mode should have \"STRING\" type, but it have \"" ~ to!string(jsonValue["datr"].type) ~
          "\" type!");
      }
      else
      {
        if(lorawanException.msg ==  structureName ~ " structure from json object should have field \"datr\"!")
        {
          throw new LorawanException(structureName ~ " structure from json object in \"LORA\" mode " ~
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

static Nullable!uint getFskDatarate(ModulationIdentifier modulationIdentifier,
  JSONValue jsonValue, NamesOfStructures structureName)
{
  Nullable!uint result;
  
  if(modulationIdentifier == ModulationIdentifier.FSK)
  {
    try
    {
      result = getValueFromJsonByKey!uint("datr", jsonValue, structureName);
    }
    catch(LorawanException lorawanException)
    {
      if(lorawanException.msg == "field \"datr\" of " ~ structureName ~ " structure from json object should have " ~
        "\"UINTEGER\" type, but it have \"STRING\" type!")
      {
        throw new LorawanException("field \"datr\" of " ~ structureName ~ " structure from json object in " ~
          "\"FSK\" mode should have \"UINTEGER\" type, but it have \"" ~ to!string(jsonValue["datr"].type) ~
          "\" type!");
      }
    }
    catch(Exception exception)
    {
      throw new Exception(exception.msg);
    }
  }  

  return result; 
}

static Nullable!MacPacket getData(JSONValue jsonValue, NamesOfStructures structureName)
{
  Nullable!MacPacket result;
   
  if(("data" in jsonValue) !is null)
  {
    if(jsonValue["data"].type != JSON_TYPE.STRING)
    {
      throw new LorawanException("field \"data\" of " ~ structureName ~ " structure from json object should have " ~
        "\"STRING\" type, but it have \"" ~ to!string(jsonValue["data"].type) ~"\" type!");
    }
    result = new MacPacket;
    result.setData(jsonValue["data"].str);
  }
   
  return result;
}