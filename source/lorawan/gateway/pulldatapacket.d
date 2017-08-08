/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.pulldatapacket;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;

/// The class represending the PUSH_ACK packet
class PullDataPacket : AbstractPacket
{
  public:
    /// Used to initialize protocol version, packet type and token.  
    this()
    {
      super(ProtocolVersion.VERSION_2, PacketType.PULL_DATA, [0, 0]);
      _gatewayID = [0, 0, 0, 0, 0, 0, 0, 0];
    }
  
    /** Used to converts PUSH_ACK packet to an array of bytes
    
      Returns:
        $(D ubyte[])
    */
    override ubyte[] toByteArray()
    {
      return _protocolVersion ~ _token ~ _packetType ~ _gatewayID;
    }
    
    /** Used to get the gateway identifier (MAC address)
    
      Returns:
        $(D GatewayID)
    */     
    GatewayID getGatewayID(){ return _gatewayID; }
    
    /** Used to set the gateway identifier (MAC address)
    
      Params:
        gatewayID = value used to initialize gateway identifier (MAC address)
    */    
    void setGatewayID(GatewayID gatewayID){ _gatewayID = gatewayID; }
    
    /** Used to get the rxpk array
    
      Returns:
        $(D Rxpk[])
    */    
    
  private:
    GatewayID _gatewayID;
}