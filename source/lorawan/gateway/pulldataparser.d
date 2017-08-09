/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pulldataparser;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import lorawan.gateway.parserinterface;
import lorawan.gateway.pulldatapacket;

/// Parser for PUSH_ACK packets
class PullDataParser : ParserInterface
{
  /** Used to parse byte array which represent PULL_DATA packet
  
    Params:
      data = byte array for parsing
      
    Returns:
      $(D AbstractPacket)  
  */
  AbstractPacket parse(in ubyte[] data)
  {
    if(data.length != 12)
    { 
      return null;
    }
    if(data[0] != ProtocolVersion.VERSION_2){
      return null;
    }
    if(data[3] != PacketType.PULL_DATA)
    {
      return null;
    }
    else
    {
      PullDataPacket result = new PullDataPacket;
      result.setProtocolVersion(ProtocolVersion.VERSION_2);
      result.setToken(data[1..3]);
      result.setGatewayID(data[4..12]);
      return result;
    }
  }
}