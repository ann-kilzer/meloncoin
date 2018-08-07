pragma solidity ^0.4.23;

import './Meloncoin.sol';

// Deploys and manages meloncoins
contract MelonFarm {


  Meloncoin[] public deployed;
  
  constructor() public {

  }

  function launchMeloncoin(uint _initialSupply,
			   uint _plantDate,
			   uint8 _growingPeriod,
			   uint8 _ripePeriod) public returns (Meloncoin) {
    Meloncoin latest = new Meloncoin(_initialSupply, _plantDate, _growingPeriod, _ripePeriod,
				     msg.sender);
    deployed.push(latest);
    return latest;
  }
}
