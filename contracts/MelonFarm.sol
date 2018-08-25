/**
 * Created on: August 2018
 * @summary: MelonFarm manages different meloncoins. There will be one
 * deployment of the Meloncoin contract per crop of melon, each with its own
 * ripeness and expiration period
 * @author:
 */
pragma solidity 0.4.24;

import './Meloncoin.sol';

/**
 * @title MelonFarm deploys and manages meloncoins
 */
contract MelonFarm {
  Meloncoin[] public meloncoins;

/**
 * @dev Creates a new Meloncoin, assigning all tokens to the sender
 * @param _initialSupply : How many melon seeds are planted
 * @param _plantDate : When the melons are planted
 * @param _growingPeriod : How long the melons take to grow in days
 * @param _ripePeriod : The shelf life of the melons in days. This is the
 * period in which meloncoin can be redeemed for an investment-grade melon
 * @return : a new Meloncoin contract
 */
  function launchMeloncoin(uint16 _initialSupply,
			   uint _plantDate,
			   uint8 _growingPeriod,
			   uint8 _ripePeriod) public returns (Meloncoin) {
    Meloncoin latest = new Meloncoin(_initialSupply, _plantDate, _growingPeriod, _ripePeriod,
				     msg.sender);

    meloncoins.push(latest);
    emit NewMeloncoin(latest, _initialSupply, _plantDate, _growingPeriod, _ripePeriod);
    return latest;
  }

  function getDeployed() public view returns (Meloncoin[]) {
    return meloncoins;
  }

  function getLastDeployed() public view returns (Meloncoin) {
    uint index = meloncoins.length - 1;
    return meloncoins[index];
  }

  event NewMeloncoin(address newAddress, uint16 melons, uint plantDate, uint8 growingPeriod, uint8 ripePeriod);
}
