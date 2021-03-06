/**
 * Created on: August 2018
 * @summary: Test Meloncoin
 * @author: Ann Kilzer
 * akilzer@gmail.com
 *
 * This file performs a breadth of tests on success cases in solidity. It tests
 * all functions of Meloncoin, but solidity is unable to handle failure cases, so
 * those tests are in meloncoin.test.js.
 */
pragma solidity 0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Meloncoin.sol";
import "../contracts/MelonFarm.sol";
import "./MelonSpenderProxy.sol";

contract TestMeloncoin {
  address fox = 0x284A84baA00626e2773a1138D53923b4acAED2F4;
  uint16 melons = 3;
  uint supply = melons * 10 ** uint(18);

  uint plantDate = 1533192407;

  function testConstructor() public {
    MelonFarm farm = MelonFarm(DeployedAddresses.MelonFarm());
    Meloncoin melon = farm.launchMeloncoin(melons, plantDate, 90, 20);

    Assert.equal(melon.totalSupply(), supply, "Total supply");
    Assert.equal(uint(melon.decimals()), uint(18), "Decimals");
    Assert.equal(melon.plantDate(), plantDate, "Plant date");
    Assert.isTrue(melon.isGrowingAt(plantDate), "Plant date growing");
    Assert.isFalse(melon.isRipeAt(plantDate), "Plant date not ripe");
    Assert.isFalse(melon.isExpiredAt(plantDate), "Plant date not expired");
    Assert.equal(melon.balanceOf(this), supply, "Owner should have all the meloncoin initially");
  }

  // Since we can only burn when the melon is ripe, make a melon planted in the past
  function testBurn() public {
    MelonFarm farm = MelonFarm(DeployedAddresses.MelonFarm());

    // This will be right in the middle of the ripe period
    uint pastPlantDate = now - 95 days;
    Meloncoin melon = farm.launchMeloncoin(melons, pastPlantDate, 90, 10);

    uint myBalance = melon.balanceOf(this);
    Assert.equal(myBalance, supply, "Initial supply of main address");

    melon.burn(1);

    uint expectedBalance = melon.melonToMusk(2);
    uint actualBalance = melon.balanceOf(this);
    Assert.equal(actualBalance, expectedBalance, "Balance after burning 1 melon");
  }

  function testBalanceOf() public {
    MelonFarm farm = MelonFarm(DeployedAddresses.MelonFarm());
    Meloncoin melon = farm.launchMeloncoin(melons, plantDate, 90, 20);

    uint myBalance = melon.balanceOf(this);
    Assert.equal(myBalance, supply, "Initial supply of main address");

    uint foxBalance = melon.balanceOf(fox);
    Assert.equal(foxBalance, 0, "Other addresses start with 0");
  }

  function testAllowanceAndApprove() public {
    MelonFarm farm = MelonFarm(DeployedAddresses.MelonFarm());
    Meloncoin melon = farm.launchMeloncoin(melons, plantDate, 90, 20);

    uint tokens = 32;
    Assert.equal(melon.allowance(this, fox), 0, "Initial allowance is zero");
    Assert.isTrue(melon.approve(fox, tokens), "Approval");
    Assert.equal(melon.allowance(this, fox), tokens, "Ending allowance");
  }

  function testTransfer() public {
    MelonFarm farm = MelonFarm(DeployedAddresses.MelonFarm());
    Meloncoin melon = farm.launchMeloncoin(3, now, 90, 10);

    uint startingBalance = melon.balanceOf(this);

    Assert.equal(melon.balanceOf(fox), 0, "Initial fox balance");

    Assert.isFalse(melon.isExpired(), "Not yet expired");

    // empty transfer
    uint tokens = 0;
    Assert.isTrue(melon.transfer(fox, tokens), "Transfer succeeded");
    Assert.equal(melon.balanceOf(fox), tokens, "Fox balance after empty transfer");
    Assert.equal(melon.balanceOf(this), startingBalance, "Sender balance after empty transfer");

    // actual transfer
    tokens = 12;
    Assert.isTrue(melon.transfer(fox, tokens), "Transfer succeeded");
    Assert.equal(melon.balanceOf(fox), tokens, "Fox balance after transfer");
    Assert.equal(melon.balanceOf(this), startingBalance - tokens, "Sender balance after transfer");
  }

  function testTransferFrom() public {
    MelonFarm farm = MelonFarm(DeployedAddresses.MelonFarm());
    Meloncoin melon = farm.launchMeloncoin(melons, plantDate, 90, 20);

    uint tokens = 1999;

    MelonSpenderProxy spender = new MelonSpenderProxy();
    address spenderAddr = address(spender);

    melon.approve(spenderAddr, tokens);

    // Sanity checks
    Assert.equal(melon.balanceOf(this), melon.melonToMusk(melons), "We have the melons");
    Assert.notEqual(this, spenderAddr, "Spender proxy has a different address");
    Assert.equal(melon.allowance(this, spenderAddr), tokens, "Spender proxy has an allowance");

    Assert.isTrue(spender.spendMelonAllowance(melon, this, fox, 11), "TransferFrom proxy");
  }
}
