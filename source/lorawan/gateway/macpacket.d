/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.macpacket;

import std.conv;

/// The class representing the data of the packets
class MacPacket
{
  public:
    /** Used to get data of mac packet
    
      Returns:
        $(D string)  
    */
    string getData(){ return _data; }
    
    /** Used to set data of mac packet
    
      Params:
        data = data for initialization
    */    
    void setData(string data){ _data = data; }
    
    /** Used to compare mac packets
    
      Params:
        o = object to compare
        
      Return:
        $(D bool)  
    */    
    override bool opEquals(Object o) const
    {
      MacPacket macPacket;
      macPacket = to!MacPacket(o);
      return _data == macPacket.getData;
    }
    
    /** Used to get hash of object
        
      Return:
        $(D size_t)  
    */    
    override size_t toHash() @trusted const
    {
      return cast(size_t)cast(void*)this;
    }
    
  private:
    string _data;
}