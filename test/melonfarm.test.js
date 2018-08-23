var MelonFarm = artifacts.require("MelonFarm");
var Meloncoin = artifacts.require("Meloncoin");

contract('MelonFarm', function(accounts) {
    var initialSupply = 10;
    var plantTime = Math.floor((new Date).getTime() / 1000); // seconds since the epoch
    var growingPeriod = 90;
    var ripePeriod = 10;
    it("should launch a meloncoin", function() {
	var farm;
	return MelonFarm.deployed().then(function(instance) {
	    farm = instance;
	    return farm.launchMeloncoin(initialSupply, plantTime, growingPeriod, ripePeriod, { from: accounts[0]});
	}).then(function() {
	    return farm.getLastDeployed();
	}).then(async function(address) {
	    var meloncoin = Meloncoin.at(address);
	    var total = await meloncoin.totalSupply();
	    var expectedTotal = 10000000000000000000;
	    assert.equal(total.valueOf(), expectedTotal, "Total supply wasn't 10*10^18"); 
	});
    });
    it("should track all meloncoins", function () {
	var farm
	return MelonFarm.deployed().then(async function(instance) {
	    farm = instance;
	    var previous = await farm.getLastDeployed();
	    var idxZero = await farm.meloncoins(0);
	    assert.equal(previous, idxZero, "Previous meloncoin wasn't at index 0");
	    return farm.launchMeloncoin(initialSupply, plantTime, growingPeriod, ripePeriod, { from: accounts[0]});
	}).then(async function () {
	    var idxOne = await farm.meloncoins(1);
	    var lastDeployed = await farm.getLastDeployed();
	    assert.equal(idxOne, lastDeployed, "Last deployed didn't match index 1");
	});
    });
});
