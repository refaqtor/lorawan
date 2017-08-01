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

/// Enumeration of CRC statuses
enum CrcStatus: byte
{
  /// Ok CRC status
  OK = 0x01,
  /// Fail CRC status
  FAIL = -0x01,
  /// No CRC status
  NO_CRC = 0x00
}

/// Enumeration of modulation identifiers
enum ModulationIdentifier : string
{
  ///Lora module identifier
  LORA = "LORA",
  ///FSK module identifier
  FSK = "FSK"
}