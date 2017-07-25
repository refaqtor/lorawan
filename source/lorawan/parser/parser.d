module lorawan.parser.parser;

import lorawan.parser.packets;

/// A class that provides parsing of structures corresponding to different types of packets, and parsing the input byte array into a structure of the required type
class Parser{
  /// Parsing a structure into an array of bytes
  ubyte[] parseStructure(PUSH_ACK pushAckStruct){
    ubyte[] pushAckArray = pushAckStruct.protocolVersion ~ pushAckStruct.token ~ pushAckStruct.pushAckID;
    return pushAckArray;
  }
}