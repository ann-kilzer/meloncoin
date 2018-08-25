

1. Avoid sending to invalid addresses such as the contract address or 0x0. I
implemented the validDestination modifier based on [ConsenSys's best
practice guide for tokens.](https://consensys.github.io/smart-contract-best-practices/tokens/)


2. Locked pragmas to specific compiler version 0.4.24

3. Integer overflow / underflow
I use the SafeMath library, and restrict the initial melon supply to a uint16. 65535 is a big enough
number to represent a melon crop, and it also keeps the token balance from overflowing with 18 decimal places.  

  - [x] I checked possible overflow on initial supply calculation via a unit test in meloncoin.test.js
  - [x] There is an overflow check on internal transfer

4. Safety of using timestamps:
The granularity of meloncoin is by the day, which is a wide enough timespan to tolerate clock skew or potential manipulation by nodes without compromising integrity.

5. Emergency stop
I made meloncoin implement OpenZeppelin's Pausable.sol to instrument emergency stop

6. Consider front - running attacks on ERC20. TODO
https://consensys.github.io/smart-contract-best-practices/tokens/
