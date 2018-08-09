/**
 * Created on: August 2018
 * @summary: for testing, we need to try and spend melons from another address
 * @author: Ann Kilzer
 */
pragma solidity 0.4.24;

import "../contracts/Meloncoin.sol";

/**
 * @title MelonSpenderProxy
 */
contract MelonSpenderProxy {

/**
 * @dev Calls transferFrom on an instance of meloncoin
 * @param melon :  The meloncoin contract
 * @param _from :  Whose coins are we spending?
 * @param _to :  Who are we giving the coins to?
 * @param _tokens :  How many coins are we giving, in musk.
 * @return : true if successful
 */
  function spendMelonAllowance(Meloncoin melon, address _from, address _to, uint _tokens) public returns (bool) {
    return melon.transferFrom(_from, _to, _tokens);
  }
}
