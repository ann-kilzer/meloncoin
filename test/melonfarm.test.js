var MelonFarm = artifacts.require("MelonFarm");
var Meloncoin = artifacts.require("Meloncoin");

contract('MelonFarm', function(accounts) {
    it("should launch a meloncoin", function() {
	var initialSupply = 10;
	var plantTime = Math.floor((new Date).getTime() / 1000); // seconds since the epoch
	var growingPeriod = 90;
	var ripePeriod = 10;
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
});
