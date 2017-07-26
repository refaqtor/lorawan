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
    /// Default constructor
    this(ProtocolVersion protocolVersion, PacketType packetType, ubyte[2] token)
    {
      _protocolVersion = protocolVersion;
      _packetType = packetType;
      _token = token;
    }
  
    /// Converts the packet to an array of bytes
    abstract ubyte[] toByteArray();
    
    final ProtocolVersion getProtocolVersion(){ return _protocolVersion; }
    final AbstractPacket setProtocolVersion(ProtocolVersion protocolVersion)
    { 
      _protocolVersion = protocolVersion;
       return this;
    }
    
    final ubyte[2] getToken(){ return _token; }
    final AbstractPacket setToken(ubyte[2] token)
    { 
      _token = token; 
      return this; 
    }
    
    final PacketType getPacketType(){ return _packetType; }
    final AbstractPacket setPacketType(PacketType packetType){
       _packetType = packetType; 
       return this; 
    }
    
  protected:
    /// Protocol version between Lora gateway and server
    ProtocolVersion _protocolVersion;
    /// Random token to acknowledge
    ubyte[2] _token;
    /// Packet type identifier
    PacketType _packetType;
}