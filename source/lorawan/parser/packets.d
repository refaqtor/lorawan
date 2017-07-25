module lorawan.parser.packets;

/// Structure corresponding to the PUSH_ACK package
struct PUSH_ACK{
  /// Protocol version between Lora gateway and server
  ubyte protocolVersion = 2;
  /// Same token as the PUSH_DATA packet to acknowledge
  ubyte[2] token;
  ///PUSH_ACK identifier 0x01
  ubyte pushAckID = 1;
}