/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.lorawantypes;

/// Enumeration of protocol versions
enum : ubyte
{
  /// Protocol version 2
  PROTOCOL_VERSION_2 = 0x02
}

/// Enumeration of packet types
enum : ubyte
{
  /// PUSH_ACK packet type
  PUSH_ACK_PACKET_TYPE = 0x01
}