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
    /// Used to initialize protocol version, packet type and token.
    this()
    {
      super(ProtocolVersion.VERSION_2, PacketType.PUSH_ACK, [0, 0]);
    }
  
    /** Used to converts PUSH_ACK packet to an array of bytes
    
      Returns:
        $(D ubyte[])
    */
    override ubyte[] toByteArray()
    {
      return _protocolVersion ~ _token ~ _packetType;
    }
}