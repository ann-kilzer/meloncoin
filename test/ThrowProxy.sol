pragma solidity 0.4.24;

import "truffle/Assert.sol";


// This contract allows us to write unit tests around failing calls
// Based off of the following sources:
// https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
// https://medium.com/@kscarbrough1/writing-solidity-unit-tests-for-testing-assert-require-and-revert-conditions-using-truffle-2e182d91a40f
contract ThrowProxy {
  address public target;
  bytes data;

  constructor(address _target) {
    target = _target;
  }

  //prime the data using the fallback function.
  function() {
    data = msg.data;
  }

  function execute() returns (bool) {
    return target.call(data);
  }
}
