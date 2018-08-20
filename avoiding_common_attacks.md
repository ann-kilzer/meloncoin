

1. Avoid sending to invalid addresses such as the contract address or 0x0. I
implemented the validDestination modifier based on [ConsenSys's best
practice guide for tokens.](https://consensys.github.io/smart-contract-best-practices/tokens/)


2. Locked pragmas to specific compiler version 0.4.24

3. Consider front - running attacks on ERC20. TODO
https://consensys.github.io/smart-contract-best-practices/tokens/

4. Integer overflow / underflow

  [ ] check possible overflow on initial supply calculation
  
  [X] Overflow check on internal transfer

5. Safety of using timestamps:
The granularity of meloncoin is by the day, which is a wide enough timespan to tolerate clock skew or potential manipulation by nodes without compromising integrity.

6. Emergency stop
I made meloncoin implement OpenZeppelin's Pausable.sol to instrument emergency stop
