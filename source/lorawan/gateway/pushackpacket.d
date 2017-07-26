module lorawan.gateway.pushackpacket;

import lorawan.gateway.abstractpacket;

/// The class corresponding to the PUSH_ACK packet
class PushAckPacket : AbstractPacket
{
  public:
    override ubyte[] toUbyteArray()
    {
      return _protocolVersion ~ _token ~ _packetTypeID;
    }
}