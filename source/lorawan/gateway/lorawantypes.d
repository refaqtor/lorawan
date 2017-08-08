/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.lorawantypes;

import std.json;

alias GatewayID = ubyte[8];

///Initializes an associative array that connects the types of 'd' language and types of json format
static this()
{
  dlangToJsonTypes =
  [
    "string" : JSON_TYPE.STRING,
    "byte" : JSON_TYPE.INTEGER,
    "short" : JSON_TYPE.INTEGER,
    "int" : JSON_TYPE.INTEGER,
    "long" : JSON_TYPE.INTEGER,
    "ubyte" : JSON_TYPE.UINTEGER,
    "ushort" : JSON_TYPE.UINTEGER,
    "uint" : JSON_TYPE.UINTEGER,
    "ulong" : JSON_TYPE.UINTEGER,
    "float" : JSON_TYPE.FLOAT,
    "double" : JSON_TYPE.FLOAT,
    "real" : JSON_TYPE.FLOAT
  ];
}

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
  PUSH_ACK = 0x01,
  /// PULL_ACK packet type
  PULL_ACK = 0x04 
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
  ///SF6BW125 lora datarate value
  SF_6_BW_125 = "SF6BW125",
  ///SF6BW250 lora datarate value
  SF_6_BW_250 = "SF6BW250",
  ///SF6BW500 lora datarate value
  SF_6_BW_500 = "SF6BW500",

  ///SF7BW125 lora datarate value
  SF_7_BW_125 = "SF7BW125",
  ///SF7BW250 lora datarate value
  SF_7_BW_250 = "SF7BW250",
  ///SF7BW500 lora datarate value
  SF_7_BW_500 = "SF7BW500",
  
  ///SF8BW125 lora datarate value
  SF_8_BW_125 = "SF8BW125",
  ///SF8BW250 lora datarate value
  SF_8_BW_250 = "SF8BW250",
  ///SF8BW500 lora datarate value
  SF_8_BW_500 = "SF8BW500",
  
  ///SF9BW125 lora datarate value
  SF_9_BW_125 = "SF9BW125",
  ///SF9BW250 lora datarate value
  SF_9_BW_250 = "SF9BW250",
  ///SF9BW500 lora datarate value
  SF_9_BW_500 = "SF9BW500",
  
  ///SF10BW125 lora datarate value
  SF_10_BW_125 = "SF10BW125",
  ///SF10BW250 lora datarate value
  SF_10_BW_250 = "SF10BW250",
  ///SF10BW500 lora datarate value
  SF_10_BW_500 = "SF10BW500",

  ///SF11BW125 lora datarate value
  SF_11_BW_125 = "SF11BW125",
  ///SF11BW250 lora datarate value
  SF_11_BW_250 = "SF11BW250",
  ///SF11BW500 lora datarate value
  SF_11_BW_500 = "SF11BW500",
  
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

///Associative array that connects the types of 'd' language and types of json format
immutable JSON_TYPE[string] dlangToJsonTypes;