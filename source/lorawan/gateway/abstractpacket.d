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
    /// Converts the corresponding packet type to an array of bytes
    ubyte[] toUbyteArray();
    
    final ubyte getProtocolVersion(){ return _protocolVersion; }
    final void setProtocolVersion(ubyte protocolVersion){ _protocolVersion = protocolVersion; }
    
    final ubyte[2] getToken(){ return _token; }
    final void setToken(ubyte[2] token){ _token = token; }
    
    final ubyte getPacketType(){ return _packetType; }
    final void setPacketType(ubyte packetType){ _packetType = packetType;}
    
  protected:
    /// Protocol version between Lora gateway and server
    ubyte _protocolVersion;
    /// Random token to acknowledge
    ubyte[2] _token;
    /// Packet type identifier
    ubyte _packetType;
}