pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Fruit.sol";


contract TestFruit {
  function testConstructor() public {
    Fruit fruit = Fruit(DeployedAddresses.Fruit());
    
    uint plantDate = 1532615474;
    uint ripeStart = plantDate + 90 days;
    uint ripeEnd = ripeStart + 10 days;


    Assert.equal(fruit.plantDate(), plantDate, "Expected Plant Date");
    Assert.equal(fruit.ripeStart(), ripeStart, "Expected first day of ripeness");
    Assert.equal(fruit.ripeEnd(), ripeEnd, "Expected last day of ripeness");
  }

  function testIsRipeAt() public {
    Fruit fruit = Fruit(DeployedAddresses.Fruit());
    uint plantDate = 1532615474;

    Assert.isFalse(fruit.isRipeAt(plantDate), "After 0 days");
    Assert.isFalse(fruit.isRipeAt(plantDate + 89 days), "After 89 days");
    Assert.isFalse(fruit.isRipeAt(plantDate + 89 days + 23 hours + 59 minutes + 59 seconds), "After 89 days 23:59:59");

    Assert.isTrue(fruit.isRipeAt(plantDate + 90 days), "After 90 days");
    Assert.isTrue(fruit.isRipeAt(plantDate + 95 days), "After 95 days");
    Assert.isTrue(fruit.isRipeAt(plantDate + 99 days), "After 99 days");
    Assert.isTrue(fruit.isRipeAt(plantDate + 99 days + 23 hours + 59 minutes + 59 seconds), "After 99 days 23:59:59");
    

    Assert.isFalse(fruit.isRipeAt(plantDate + 100 days), "After 100 days");
  }

  function testIsGrowingAt() public {
    Fruit fruit = Fruit(DeployedAddresses.Fruit());
    uint plantDate = 1532615474;

    Assert.isFalse(fruit.isGrowingAt(plantDate - 1 seconds), "1 second before");

    Assert.isTrue(fruit.isGrowingAt(plantDate), "After 0 days");
    Assert.isTrue(fruit.isGrowingAt(plantDate + 89 days), "After 89 days");
    Assert.isTrue(fruit.isGrowingAt(plantDate + 89 days + 23 hours + 59 minutes + 59 seconds), "After 89 days 23:59:59");

    Assert.isFalse(fruit.isGrowingAt(plantDate + 90 days), "After 90 days");
  }

  function testIsExpiredAt() public {
    Fruit fruit = Fruit(DeployedAddresses.Fruit());
    uint plantDate = 1532615474;

    Assert.isFalse(fruit.isExpiredAt(plantDate), "After 0 days");
    Assert.isFalse(fruit.isExpiredAt(plantDate + 90 days), "After 90 days");
    
    Assert.isTrue(fruit.isExpiredAt(plantDate + 100 days), "After 100 days");
    Assert.isTrue(fruit.isExpiredAt(plantDate + 101 days), "After 101 days");
  }

  function testIsRipe() public {
    Fruit fruit = Fruit(DeployedAddresses.Fruit());
    Assert.equal(fruit.isRipe(), fruit.isRipeAt(now), "Compare now");
  }

  function testIsGrowing() public {
    Fruit fruit = Fruit(DeployedAddresses.Fruit());
    Assert.equal(fruit.isGrowing(), fruit.isGrowingAt(now), "Compare now");
  }

  function testIsExpired() public {
    Fruit fruit = Fruit(DeployedAddresses.Fruit());
    Assert.equal(fruit.isExpired(), fruit.isExpiredAt(now), "Compare now");
  }
}
