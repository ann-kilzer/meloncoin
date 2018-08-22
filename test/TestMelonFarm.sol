/**
 * Created on: August 2018
 * @summary: Test the MelonFarm contract
 * @author: Ann Kilzer
 * akilzer@gmail.com
 */
pragma solidity 0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MelonFarm.sol";
import "../contracts/Meloncoin.sol";

contract TestMelonFarm{

  function testLaunchMeloncoin() public {
    MelonFarm farm = MelonFarm(DeployedAddresses.MelonFarm());
    Meloncoin yubariSeason = farm.launchMeloncoin(10, now, 90, 10);
    Meloncoin suikaSeason = farm.launchMeloncoin(15, now, 80, 20);

    Assert.equal(yubariSeason, farm.meloncoins(0), "Check first contract");
    Assert.equal(suikaSeason, farm.meloncoins(1), "Check second contract");
  }

  function testGetLastDeployed() public {
    MelonFarm farm = MelonFarm(DeployedAddresses.MelonFarm());
    Meloncoin yubariSeason = farm.launchMeloncoin(10, now, 90, 10);
    Meloncoin lastDeployed = farm.getLastDeployed();

    Assert.equal(lastDeployed, yubariSeason, "Track last deployed");
  }

  function testStoreMeloncoins() public {
    MelonFarm farm = MelonFarm(DeployedAddresses.MelonFarm());
    uint count = farm.getDeployed().length;

    farm.launchMeloncoin(10, now, 90, 10);
    Assert.equal(farm.getDeployed().length, count + 1, "One more meloncoin");
  }
}
