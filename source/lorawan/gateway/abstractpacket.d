/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.abstractpacket;

import lorawan.gateway.lorawantypes;

/// Abstract class for all types of packets
class AbstractPacket
{
  public:
    /** Used to initialize protocol version, packet type and token.
    
      Params:
        protocolVersion = protocol version between Lora gateway and server.
        packetType = packet type.
        token = random token.
    */
    this(ProtocolVersion protocolVersion, PacketType packetType, ubyte[2] token)
    {
      _protocolVersion = protocolVersion;
      _packetType = packetType;
      _token = token;
    }
  
    /** Used to converts packet to an array of bytes
    
      Returns:
        $(D ubyte[])
    */
    abstract ubyte[] toByteArray();
    
    /** Used to get the protocol version
    
      Returns:
        $(D ProtocolVersion)
    */
    final ProtocolVersion getProtocolVersion(){ return _protocolVersion; }
    
    /** Used to set the protocol version
    
      Params:
        protocolVersion = value used to initialize protocol version
        
      Returns:
        $(D AbstractPacket)
    */
    final AbstractPacket setProtocolVersion(ProtocolVersion protocolVersion)
    { 
      _protocolVersion = protocolVersion;
       return this;
    }
    
    /** Used to get the token
    
      Returns:
        $(D ubyte[2])
    */    
    final ubyte[2] getToken(){ return _token; }
    
    /** Used to set the token
    
      Params:
        token = value used to initialize token
        
      Returns:
        $(D AbstractPacket)
    */    
    final AbstractPacket setToken(ubyte[2] token)
    { 
      _token = token; 
      return this; 
    }
    
    /** Used to get the packet type
    
      Returns:
        $(D PacketType)
    */        
    final PacketType getPacketType(){ return _packetType; }
    
  protected:
    /// Protocol version between Lora gateway and server
    ProtocolVersion _protocolVersion;
    /// Random token to acknowledge
    ubyte[2] _token;
    /// Packet type identifier
    PacketType _packetType;
}