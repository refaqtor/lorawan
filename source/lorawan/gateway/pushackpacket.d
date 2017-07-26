/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pushackpacket;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;

/// The class corresponding to the PUSH_ACK packet
class PushAckPacket : AbstractPacket
{
  public:
    override ubyte[] toUbyteArray()
    {
      return _protocolVersion ~ _token ~ _packetType;
    }
}