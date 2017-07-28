/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pushdatapacket;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import std.json;

/// The class represending the PUSH_DATA packet
class PushDataPacket : AbstractPacket
{
  public:
    /** Used to initialize PUSH_DATA packet
    
      Params:
        token = random token, default falue is [0, 0].
        protocolVersion = protocol version between Lora gateway and server, default value is ProtocolVersion.VERSION_2.
        gatewayID = gateway unique identifier (MAC address), default value is [0, 0, 0, 0, 0, 0, 0, 0]. 
        jsonValue = json value can contains metadata or/and the status of the gateway, default value is null.        
    */  
    this(ubyte[2] token = [0, 0], ProtocolVersion protocolVersion = ProtocolVersion.VERSION_2,
       ubyte[8] gatewayID = [0, 0, 0, 0, 0, 0, 0, 0], JSONValue jsonValue = null)
    {
      super(protocolVersion, PacketType.PUSH_DATA, token);
      _jsonObject = jsonValue;
    }
  
    /** Used to converts PUSH_DATA packet to an array of bytes
    
      Returns:
        $(D ubyte[])
    */
    override ubyte[] toByteArray()
    {
      ubyte[] result = _protocolVersion ~ _token ~ _packetType ~ _gatewayID;
      if(_jsonObject.type() !is JSON_TYPE.NULL)
      {
        result ~= cast(ubyte[]) toJSON(_jsonObject);
      }
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
        
      Returns:
        $(D PushDataPacket)
    */    
    PushDataPacket setGatewayID(ubyte[8] gatewayID)
    { 
      _gatewayID = gatewayID; 
      return this; 
    }
    
    /** Used to get the json object
    
      Returns:
        $(D JSONValue)
    */     
    JSONValue getJsonObject(){ return _jsonObject; }
    
    /** Used to set the json object
    
      Params:
        jsonObject = value used to initialize json object
        
      Returns:
        $(D PushDataPacket)
    */    
    PushDataPacket setJsonObject(JSONValue jsonObject)
    { 
      _jsonObject = jsonObject; 
      return this; 
    }    
    
  private:
    ubyte[8] _gatewayID;
    JSONValue _jsonObject;
}