// Here's an example of testing the fruit contract in JavaScript. It does a simple
// check of setting a plantDate.

var Fruit = artifacts.require("Fruit");

contract('Fruit', function(accounts) {
    it("should plant a fruit at a specific time", function() {
	return Fruit.deployed().then(function(instance) {
	    return instance.plantDate();
	}).then(function(plantDate) {
	    assert.equal(plantDate.valueOf(), 1532615474, "Incorrect plant date");
	});
    });
});
