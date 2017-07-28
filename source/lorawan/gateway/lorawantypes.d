/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.lorawantypes;

/// Enumeration of protocol versions
enum ProtocolVersion: ubyte
{
  /// Protocol version 2
  VERSION_2 = 0x02
}

/// Enumeration of packet types
enum PacketType: ubyte
{
  /// PUSH_DATA packet type
  PUSH_DATA = 0x00,
  /// PUSH_ACK packet type
  PUSH_ACK = 0x01
}