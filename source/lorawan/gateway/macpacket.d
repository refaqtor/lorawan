/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.macpacket;

/// The class representing the data of the packets
class MacPacket
{
  public:
    string getData(){ return _data; } //TODO: add docs
    void setData(string data){ _data = data; } //TODO: add docs
    
  private:
    string _data;
}