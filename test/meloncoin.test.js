var Meloncoin = artifacts.require("Meloncoin.sol");

contract('Meloncoin', function(accounts) {

    beforeEach(async function () {
	this.plantTime = Math.floor((new Date).getTime() / 1000); // seconds since the epoch
	this.meloncoin = await Meloncoin.new(3, this.plantTime, 90, 10, accounts[0]);
    });
    
    it("should launch a new meloncoin", async function() {
	var total = await this.meloncoin.totalSupply();
	assert.equal(total.valueOf(), 3000000000000000000, "Total supply wasn't 3*10^18");
	var decimals = await this.meloncoin.decimals();
	assert.equal(decimals.valueOf(), 18, "Decimals wasn't 18");
	var plantTime = await this.meloncoin.plantDate();
	assert.equal(plantTime, this.plantTime, "Plant date doesn't match what we recorded");
    });
});
