/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.parserinterface;

import lorawan.gateway.abstractpacket;

/// Interface for different parsers
interface ParserInterface
{
  /** An abstract method that must be implemented for each parser
    
    Params:
      data = byte array for parsing
      
    Returns:
      $(D AbstractPacket)  
  */
  AbstractPacket parse(in ubyte[] data);
}