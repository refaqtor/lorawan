/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pushackparser;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.parserinterface;
import lorawan.gateway.pushackpacket;

/// Parser for PUSH_ACK packets
class PushAckParser : ParserInterface
{
  /** Used to parse byte array which represent PUSH_ACK packet
  
    Params:
      data = byte array for parsing
      
    Returns:
      $(D AbstractPacket)  
  */
  AbstractPacket parse(in ubyte[] data)
  {
    if(data.length != 4){ return null; }
    else if(data[0] != ProtocolVersion.VERSION_2){ return null; }
    else if(data[3] != PacketType.PUSH_ACK){ return null; }
    else
    {
      PushAckPacket result = new PushAckPacket;
      result.setProtocolVersion(ProtocolVersion.VERSION_2);
      result.setToken(data[1..3]);
      return result;
    }
  }
}