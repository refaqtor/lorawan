module lorawan.parser.packets;

struct PUSH_ACK{
  ubyte protocolVersion = 2;
  ubyte[2] token;
  ubyte pushAckID = 1;
}