var Meloncoin = artifacts.require("Meloncoin.sol");

const should = require('chai')
.should();

contract('Meloncoin', function(accounts) {

  const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

  beforeEach(async function () {
    this.plantTime = Math.floor((new Date).getTime() / 1000); // seconds since the epoch
    this.meloncoin = await Meloncoin.new(3, this.plantTime, 90, 10, accounts[0]);

    this.pastPlantTime = this.plantTime - 100 * 24 * 60 * 60; // 100 days ago
    this.expiredMeloncoin = await Meloncoin.new(3, this.pastPlantTime, 90, 10, accounts[0]);
  });

  it("should launch a new meloncoin", async function() {
    var total = await this.meloncoin.totalSupply();
    var expectedTotal = 3000000000000000000;
    assert.equal(total.valueOf(), expectedTotal, "Total supply wasn't 3*10^18");
    var decimals = await this.meloncoin.decimals();
    assert.equal(decimals.valueOf(), 18, "Decimals wasn't 18");
    var plantTime = await this.meloncoin.plantDate();
    assert.equal(plantTime, this.plantTime, "Plant date doesn't match what we recorded");
    var balance = await this.meloncoin.balanceOf(accounts[0]);
    assert.equal(balance, expectedTotal, "Balance of initial account wasn't 3*10^18");
  });

  describe("transfer", function() {
    describe("when the recipient is the zero address", function() {
      const amount = 123;
      it("reverts", async function () {
        try {
          await this.meloncoin.transfer(ZERO_ADDRESS, amount, { from: accounts[0] });
        } catch (error) {
          error.message.should.include('revert', `Expected "revert", got ${error} instead`);
          return;
        }
        should.fail('Revert did not happen');
      });
    });

    describe("when the sender does not have enough balance", function() {
      const amount = 1;
      it("reverts", async function () {
        try {
          await this.meloncoin.transfer(accounts[2], amount, { from: accounts[1] });
        } catch (error) {
          error.message.should.include('revert', `Expected "revert", got ${error} instead`);
          return;
        }
        should.fail('Revert did not happen');
      });
    });

    describe("when the melon has rotted", function() {
      const amount = 105;
      it("reverts", async function () {
        try {
          await this.expiredMeloncoin.transfer(accounts[1], amount, { from: accounts[0] });
        } catch (error) {
          error.message.should.include('revert', `Expected "revert", got ${error} instead`);
          return;
        }
        should.fail('Revert did not happen');
      });
    });

    describe("when there are the max number of melons", function() {
      const maxUint16 = 65535; // that's plenty of melons
      it("should not overflow", async function () {
        try {
          allTheMelons = await Meloncoin.new(maxUint16, this.plantTime, 90, 10, accounts[0]);
          var total = await allTheMelons.totalSupply();
          var expectedTotal = 65535000000000000000000; // still fits in uint256
          assert.equal(total.valueOf(), expectedTotal, "Total supply wasn't (2^16)*(10^18)");
        } catch (error) {
          console.log(error.message);
          should.fail(error.message);
        }
      });
    });
  });
});
