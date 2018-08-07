pragma solidity ^0.4.24;

// Meloncoin
// Author: Ann Kilzer
// akilzer@gmail.com

import "../contracts/Meloncoin.sol";

// for testing, we need to try and spend melons from another address
contract MelonSpenderProxy {

  function spendMelonAllowance(Meloncoin melon, address _from, address _to, uint _tokens) public returns (bool) {
    return melon.transferFrom(_from, _to, _tokens);
  }


}
