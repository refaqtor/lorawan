module lorawan.parser.parser;

import lorawan.parser.packets;

class Parser{
  ubyte[] parseStructure(PUSH_ACK pushAckStruct){
    ubyte[] pushAckArray = pushAckStruct.protocolVersion ~ pushAckStruct.token ~ pushAckStruct.pushAckID;
    return pushAckArray;
  }
}