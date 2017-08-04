/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.gateway.lorawanexception;

import std.exception;

/// Class is used to generate exceptions associated with the lorawan library
class LorawanException : Exception
{
  /** Creates a new instance of Exception.
    
    Params:
      msg = lorawan exception message  
  */
  this(string msg, string file = __FILE__, size_t line = __LINE__)
  {
    super(msg, file, line);
  }
}