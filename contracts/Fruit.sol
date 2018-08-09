/**
 * Created on: August 2018
 * @summary: A fruit is an expiring product with a plant date, and period of ripeness.
 * @author: Ann Kilzer
 * akilzer@gmail.com
 */
pragma solidity 0.4.24;

/**
 * @title Fruit
 */
contract Fruit {
    uint public plantDate; // When the fruit is planted
    uint public ripeStart; // Start of redeemable period
    uint public ripeEnd; // End of redeemable period

/**
 * @dev constructor for a Fruit contract.
 * @param _plantDate : When the fruits are planted
 * @param _growingPeriod : How long the fruits take to grow in days
 * @param _ripePeriod : The shelf life of the fruits in days.
 */
    constructor(
        uint _plantDate,
        uint8 _growingPeriod,
        uint8 _ripePeriod
        ) public {
            plantDate = _plantDate;
            ripeStart = plantDate + _growingPeriod * 1 days;
            ripeEnd = ripeStart + _ripePeriod * 1 days;
        }

/**
 * @dev When the fruit is good for eating
 * @return : true if done growing, but not expired
 */
    function isRipe() public view returns (bool) {
      return isRipeAt(now);
    }

/**
 * @dev Is the fruit ripe at a particular time?
 * @param _t : timestamp to check in seconds since the epoch
 * @return : true if fruit is done growing, but not expired at time _t
 */
    function isRipeAt(uint _t) public view returns (bool) {
      return _t >= ripeStart && _t < ripeEnd;
    }

/**
 * @dev Is the fruit still growing
 * @return : true if fruit has been planted, but is not yet ripe
 */
    function isGrowing() public view returns (bool) {
      return isGrowingAt(now);
    }

/**
 * @dev Is the fruit growing at a particular time?
 * @param _t : timestamp to check in seconds since the epoch
 * @return : true if fruit has been planted, but is not yet ripe at time _t
 */
    function isGrowingAt(uint _t) public view returns (bool) {
        return _t >= plantDate && _t < ripeStart;
    }

/**
 * @dev Is the fruit expired or rotten?
 * @return : true if the fruit is no longer ripe, and therefore inedible
 */
    function isExpired() public view returns (bool) {
      return isExpiredAt(now);
    }

/**
 * @dev Is the fruit expired or rotten at a particular time?
 * @param _t : timestamp to check in seconds since the epoch
 * @return : true if the fruit is no longer ripe at time _t
 */
    function isExpiredAt(uint _t) public view returns (bool) {
        return _t >= ripeEnd;
    }

    modifier whenRipe() {
        require(
            isRipe(),
            "Fruit must be ripe"
        );
        _;
    }

    modifier whenGrowing() {
        require(
            isGrowing(),
            "Fruit must be growing"
        );
        _;
    }

    modifier whenExpired() {
        require(
            isExpired(),
            "Fruit must be expired"
        );
        _;
    }
}
