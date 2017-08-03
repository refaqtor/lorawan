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

/// Enumeration of lora datarate values
enum LoraDatarate : string
{
  ///SF6BW62.5 lora datarate value
  SF_6_BW_62_5 = "SF6BW62.5",
  ///SF6BW125 lora datarate value
  SF_6_BW_125 = "SF6BW125",
  ///SF6BW250 lora datarate value
  SF_6_BW_250 = "SF6BW250",
  ///SF6BW500 lora datarate value
  SF_6_BW_500 = "SF6BW500",
  
  ///SF7BW62.5 lora datarate value
  SF_7_BW_62_5 = "SF7BW62.5",
  ///SF7BW125 lora datarate value
  SF_7_BW_125 = "SF7BW125",
  ///SF7BW250 lora datarate value
  SF_7_BW_250 = "SF7BW250",
  ///SF7BW500 lora datarate value
  SF_7_BW_500 = "SF7BW500",
  
  ///SF8BW62.5 lora datarate value
  SF_8_BW_62_5 = "SF8BW62.5",
  ///SF8BW125 lora datarate value
  SF_8_BW_125 = "SF8BW125",
  ///SF8BW250 lora datarate value
  SF_8_BW_250 = "SF8BW250",
  ///SF8BW500 lora datarate value
  SF_8_BW_500 = "SF8BW500",
  
  ///SF9BW62.5 lora datarate value
  SF_9_BW_62_5 = "SF9BW62.5",
  ///SF9BW125 lora datarate value
  SF_9_BW_125 = "SF9BW125",
  ///SF9BW250 lora datarate value
  SF_9_BW_250 = "SF9BW250",
  ///SF9BW500 lora datarate value
  SF_9_BW_500 = "SF9BW500",
  
  ///SF10BW62.5 lora datarate value
  SF_10_BW_62_5 = "SF10BW62.5",
  ///SF10BW125 lora datarate value
  SF_10_BW_125 = "SF10BW125",
  ///SF10BW250 lora datarate value
  SF_10_BW_250 = "SF10BW250",
  ///SF10BW500 lora datarate value
  SF_10_BW_500 = "SF10BW500",
  
  ///SF11BW62.5 lora datarate value
  SF_11_BW_62_5 = "SF11BW62.5",
  ///SF11BW125 lora datarate value
  SF_11_BW_125 = "SF11BW125",
  ///SF11BW250 lora datarate value
  SF_11_BW_250 = "SF11BW250",
  ///SF11BW500 lora datarate value
  SF_11_BW_500 = "SF11BW500",
  
  ///SF12BW62.5 lora datarate value
  SF_12_BW_62_5 = "SF12BW62.5",
  ///SF12BW125 lora datarate value
  SF_12_BW_125 = "SF12BW125",
  ///SF12BW250 lora datarate value
  SF_12_BW_250 = "SF12BW250",
  ///SF12BW500 lora datarate value
  SF_12_BW_500 = "SF12BW500",
}

/// Enumeration of cyclic coding rate values
enum CyclicCodingRate : string
{
  CR_4_5 = "4/5",
  CR_4_6 = "4/6",
  CR_4_7 = "4/7",
  CR_4_8 = "4/8"
}