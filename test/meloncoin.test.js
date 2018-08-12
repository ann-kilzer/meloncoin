var Meloncoin = artifacts.require("Meloncoin.sol");

contract('Meloncoin', function(accounts) {
    it("should launch a new meloncoin", function() {
	var meloncoin;
	return Meloncoin.new(3, 0, 90, 10, accounts[0]).then(function(instance) {
	    meloncoin = instance;
	    return meloncoin.totalSupply();
	}).then(function(total) {
	    assert.equal(total.valueOf(), 3000000000000000000, "Total supply wasn't 3*10^18");
	});
    });
});
