pragma solidity 0.4.24;

import "truffle/Assert.sol";


/**
 * @title ThrowProxy
 *
 * This contract allows us to write unit tests around failing calls
 * Based off of the following sources:
 * https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
 * https://medium.com/kscarbrough1/writing-solidity-unit-tests-for-testing-assert-require-and-revert-conditions-using-truffle-2e182d91a40f
 */
contract ThrowProxy {
  address public target;
  bytes data;

/**
 * @dev Make the ThrowProxy
 * @param _target :  The address of the contract to call
 */
  constructor(address _target) {
    target = _target;
  }

  //prime the data using the fallback function.
  function() {
    data = msg.data;
  }

/**
 * @dev Runs a contract at the target address on behalf of the sender
 * @return : true if successful, otherwise false
 */
  function execute() returns (bool) {
    return target.call(data);
  }
}
