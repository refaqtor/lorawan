/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.lora;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.parserinterface;
import lorawan.gateway.pullackparser;
import lorawan.gateway.pulldataparser;
import lorawan.gateway.pullrespparser;
import lorawan.gateway.pushackparser;
import lorawan.gateway.pushdataparser;

/// A static class that is used to parse byte arrays into the required packets
final static class Lora
{
  public:
    /// A static constructor that is called automatically and used to add parsers
    static this()
    {
      addParser!PushAckParser;
      addParser!PushDataParser;
      addParser!PullAckParser;
      addParser!PullDataParser;
      addParser!PullRespParser;
    }
    
    /** Used to parse byte array into the required packet
    
      Params:
        data = byte array for parsing
        
      Returns:
        $(D AbstractPacket)  
    */
    static AbstractPacket parse(ubyte[] data)
    {
      foreach(ParserInterface parser; _parsers)
      {
        AbstractPacket result = parser.parse(data);
        if(result !is null)
        {
          return result;
        }
      }
      return null;
    }
  
  private:
    static void addParser(T)()
    {
      const T newParser = new T;
      if((cast(ParserInterface) newParser) !is null)
      {
        if(T.stringof in _parsers)
        {
          // New parser alredy in parser array
          return;
        }
       
        _parsers[T.stringof] = cast(ParserInterface) newParser;
      }
    }  
    
    static ParserInterface[string] _parsers;
}