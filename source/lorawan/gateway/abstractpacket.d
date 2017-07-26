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
    /// Converts the packet to an array of bytes
    ubyte[] toByteArray();
    
    final ProtocolVersion getProtocolVersion(){ return _protocolVersion; }
    final AbstractPacket setProtocolVersion(ProtocolVersion protocolVersion){ _protocolVersion = protocolVersion; return this;}
    
    final ubyte[2] getToken(){ return _token; }
    final AbstractPacket setToken(ubyte[2] token){ _token = token; return this; }
    
    final PacketType getPacketType(){ return _packetType; }
    final AbstractPacket setPacketType(PacketType packetType){ _packetType = packetType; return this; }
    
  protected:
    /// Protocol version between Lora gateway and server
    ProtocolVersion _protocolVersion;
    /// Random token to acknowledge
    ubyte[2] _token = [0, 0];
    /// Packet type identifier
    PacketType _packetType;
}