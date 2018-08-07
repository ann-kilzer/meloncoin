var Fruit = artifacts.require("Fruit");
var MelonFarm = artifacts.require("MelonFarm");

module.exports = function(deployer) {
    deployer.deploy(Fruit, 1532615474, 90, 10);
    deployer.deploy(MelonFarm);
};
