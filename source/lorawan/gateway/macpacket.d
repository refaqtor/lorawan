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
    string getData(){ return _data; } //TODO: add docs
    void setData(string data){ _data = data; } //TODO: add docs
    
    override bool opEquals(Object o) const
    {
      MacPacket macPacket;
      macPacket = to!MacPacket(o);
      return _data == macPacket.getData;
    }
    
    override size_t toHash() @trusted const
    {
      return cast(size_t)cast(void*)this;
    }
    
  private:
    string _data;
}