pragma solidity ^0.4.24;

// A fruit is an expiring product with a plant date, and period of ripeness.
contract Fruit {
    uint public plantDate; // When the fruit is planted
    uint public ripeStart; // Start of redeemable period
    uint public ripeEnd; // End of redeemable period
    
    constructor(
        uint _plantDate, // When the fruits are planted
        uint8 _growingPeriod, // How long the fruits take to grow in days
        uint8 _ripePeriod // The shelf life of the fruits in days
        ) public {
            plantDate = _plantDate;
            ripeStart = plantDate + _growingPeriod * 1 days;
            ripeEnd = ripeStart + _ripePeriod * 1 days;
        }

    function isRipe() public view returns (bool) {
      return isRipeAt(now);
    }

    function isRipeAt(uint _t) public view returns (bool) {
      return _t >= ripeStart && _t < ripeEnd;
    }

    function isGrowing() public view returns (bool) {
      return isGrowingAt(now);
    }
    
    function isGrowingAt(uint _t) public view returns (bool) {
        return _t >= plantDate && _t < ripeStart;
    }

    function isExpired() public view returns (bool) {
      return isExpiredAt(now);
    }
    
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
