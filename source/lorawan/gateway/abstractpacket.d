/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.abstractpacket;

import lorawan.gateway.lorawantypes;

/// Abstract class for all types of packets
abstract class AbstractPacket
{
  public:
    /// Converts the packet type to an array of bytes
    ubyte[] toByteArray();
    
    final ProtocolVersion getProtocolVersion(){ return _protocolVersion; }
    final void setProtocolVersion(ProtocolVersion protocolVersion){ _protocolVersion = protocolVersion; }
    
    final ubyte[2] getToken(){ return _token; }
    final void setToken(ubyte[2] token){ _token = token; }
    
    final PacketType getPacketType(){ return _packetType; }
    final void setPacketType(PacketType packetType){ _packetType = packetType;}
    
  protected:
    /// Protocol version between Lora gateway and server
    ProtocolVersion _protocolVersion;
    /// Random token to acknowledge
    ubyte[2] _token;
    /// Packet type identifier
    PacketType _packetType;
}