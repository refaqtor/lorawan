/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.txackpacket;

import lorawan.gateway.abstractpacket;
import lorawan.gateway.lorawantypes;
import std.conv;
import std.json;
//import std.typecons;

/// Structure contains the downlink request error
struct TxpkAck
{
  public:
    /**Get indication about success or type of failure that occured for downlink request
      
       Returns:
        $(D DownlinkRequestError)
    */
    DownlinkRequestError getError(){ return _error; }
    
    /**Set indication about success or type of failure that occured for downlink request
    
      Params:
        error = value used to initialize indication about success or type of failure that occured for downlink request

    */
    void setError(DownlinkRequestError error){ _error = error; }
    
  private:
    DownlinkRequestError _error; //Indication about success or type of failure that occured for downlink request
}

/// The class represending the TX_ACK packet
class TxAckPacket : AbstractPacket
{
  public:   
    /// Used to initialize PUSH_DATA packet
    this()
    {
      super(ProtocolVersion.VERSION_2, PacketType.TX_ACK, [0, 0]);
      _txpkAckStruct = TxpkAck();
    }
    
    /** Used to converts TX_ACK packet to an array of bytes
    
      Returns:
        $(D ubyte[])
    */
    override ubyte[] toByteArray()
    {
      ubyte[] result = _protocolVersion ~ _token ~ _packetType ~ _gatewayID;
      JSONValue jsonValue = getJsonValue(_txpkAckStruct);
      
      result ~= cast(ubyte[]) toJSON(jsonValue);
      return result;
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
    
    /** Used to get the txpk ack structure
    
      Returns:
        $(D Rxpk[])
    */
    TxpkAck getTxpkAckStruct(){ return _txpkAckStruct; }
    
    /** Used to set the txpk ack structure
    
      Params:
        txpkAckStruct = value used to initialize txpk ack structure
    */
    void setTxpkAckStruct(TxpkAck txpkAckStruct){ _txpkAckStruct = txpkAckStruct; }
    
  private:
    ubyte[8] _gatewayID;
    TxpkAck _txpkAckStruct;
    
    JSONValue getJsonValue(TxpkAck txpkAckStruct)
    {
      JSONValue jsonValue;
      jsonValue["txpk_ack"] = parseTxpkAck(txpkAckStruct);
      return jsonValue;
    }
    
    JSONValue parseTxpkAck(TxpkAck txpkAckStruct)
    {
      JSONValue txpkAckVal;
      
      const DownlinkRequestError error = txpkAckStruct.getError;
      txpkAckVal["error"] = to!string(error);
      
      return txpkAckVal;
    }
}