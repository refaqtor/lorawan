/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pushackpacket;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;

/// The class represending the PUSH_ACK packet
class PushAckPacket : AbstractPacket
{
  public:
    /// Default constructor
    this(ubyte[2] token = [0, 0], ProtocolVersion protocolVersion = ProtocolVersion.VERSION_2)
    {
      super(protocolVersion, PacketType.PUSH_ACK, token);
    }
  
    override ubyte[] toByteArray()
    {
      return _protocolVersion ~ _token ~ _packetType;
    }
}