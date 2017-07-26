module lorawan.gateway.abstractpacket;

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
    
    final ubyte getPacketTypeID(){ return _packetTypeID; }
    final void setPacketTypeID(ubyte packetTypeID){ _packetTypeID = packetTypeID;}
    
  protected:
    /// Protocol version between Lora gateway and server
    ubyte _protocolVersion;
    /// Random token to acknowledge
    ubyte[2] _token;
    /// Packet type identifier
    ubyte _packetTypeID;
}