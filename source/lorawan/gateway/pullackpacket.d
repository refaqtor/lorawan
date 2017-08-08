/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pullackpacket;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;

/// The class represending the PULL_ACK packet
class PullAckPacket : AbstractPacket
{
  public:
    /** Used to initialize protocol version, packet type and token.
    
      Params:
        protocolVersion = protocol version between Lora gateway and server, default value is ProtocolVersion.VERSION_2.
        token = random token, default falue is [0, 0].
    */  
    this()
    {
      super(ProtocolVersion.VERSION_2, PacketType.PULL_ACK, [0, 0]);
    }
  
    /** Used to converts PULL_ACK packet to an array of bytes
    
      Returns:
        $(D ubyte[])
    */
    override ubyte[] toByteArray()
    {
      return _protocolVersion ~ _token ~ _packetType;
    }
}