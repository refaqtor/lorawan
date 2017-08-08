/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pullackparser;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.parserinterface;
import lorawan.gateway.pullackpacket;

/// Parser for PULL_ACK packets
class PullAckParser : ParserInterface
{
  /** Used to parse byte array which represent PULL_ACK packet
  
    Params:
      data = byte array for parsing
      
    Returns:
      $(D AbstractPacket)  
  */
  AbstractPacket parse(in ubyte[] data)
  {
    if(data.length != 4)
    { 
      return null;
    }
    if(data[0] != ProtocolVersion.VERSION_2){
      return null;
    }
    if(data[3] != PacketType.PULL_ACK)
    {
      return null;
    }
    else
    {
      PullAckPacket result = new PullAckPacket;
      result.setProtocolVersion(ProtocolVersion.VERSION_2);
      result.setToken(data[1..3]);
      return result;
    }
  }
}