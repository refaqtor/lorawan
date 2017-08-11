/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module lorawan.utils.cryptohelper;

import dcrypt.blockcipher.aes;

/**The function is used to encrypt or decrypt the input byte array using the AES128 method

  Params:
    encryptNow = if true, the function will encrypt the input data, else the function will decrypt the input data
    input = input data
    key = secret key for encryption/decryption
    
  Returns:
    $(D ubyte[])
*/
ubyte[] processAES128(bool encryptNow, ubyte[] input, ubyte[16] key)
{
  ubyte[] result;
  
  auto engine = new AESEngine();
  engine.start(encryptNow, key, null);
  
  ubyte[] temp = input.dup;
  ubyte[16] resultTempBlock;
  while(temp.length > 16)
  {
    ubyte[16] tempBlock = temp[0..16];
   
    engine.processBlock(tempBlock, resultTempBlock);
    
    result ~= resultTempBlock;
    temp = temp[16..$];
  }
  
  if(temp.length)
  {
    engine.processBlock(temp ~ (new ubyte[16 - temp.length]), resultTempBlock);
    result ~= resultTempBlock;
  }
  
  return result;
}