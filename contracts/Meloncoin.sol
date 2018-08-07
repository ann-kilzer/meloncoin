pragma solidity ^0.4.24;

// Meloncoin
// Author: Ann Kilzer
// akilzer@gmail.com

import './Fruit.sol';
import './ERC20Interface.sol';

// Parts of this have been taken from the ethereum.org website, but modified to 
// demonstrate an expiring token.
// denomination names
// 10^0: musk
// 10^12: hokkaido
// 10^15: yubari
// 10^18: melon
contract Meloncoin is Fruit, ERC20Interface {
    
  uint public totalSupply;
  uint8 public decimals = 18; // recommended by Ethereum.org
  
  // balanceOf keeps track of each address's value
  mapping (address => uint) public balanceOf;
  // allowance grants other owners control over a portion of the tokens
  // This is a map of owners to spenders to allowance
  mapping (address => mapping (address => uint)) public allowance;
  
  constructor(uint _initialSupply,
              uint _plantDate, // When the melons are planted
              uint8 _growingPeriod, // How long the melons take to grow in days
              uint8 _ripePeriod, // The shelf life of the melons in days
              address _initialOwner // Who gets the coins
              ) Fruit (_plantDate,
                       _growingPeriod,
                       _ripePeriod
                       ) public {
    totalSupply = melonToMusk(_initialSupply);
    balanceOf[_initialOwner] = totalSupply;
    emit Transfer(0x0, _initialOwner, totalSupply);
  }
  
  // You can only burn entire melons when they are ripe.
  // There is no mint. If you want more melons, you have to launch another contract 
  // with a new growing season.
  function burn(uint8 _melons) whenRipe public returns (bool) {
    uint value = _melons * 10 ** uint(decimals);
    require(balanceOf[msg.sender] >= value);
    balanceOf[msg.sender] -= value;
    totalSupply -= value;
    emit Burn(msg.sender, _melons, value);
    return true;
  }
  
  // todo: risk of overflow, be careful!
  function melonToMusk(uint _melons) public view returns (uint) {
    return _melons * 10 ** uint(decimals);
  }
  
  function totalSupply() public view returns (uint) {
    return totalSupply;
  }
  
  function balanceOf(address _tokenOwner) public view returns (uint balance) {
    return balanceOf[_tokenOwner];
  }
  
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    if (isExpired()) {
      return 0;
    }
    return allowance[tokenOwner][spender];
  }
  
  /**
   * Internal transfer, only can be called by this contract
   */
  function _transfer(address _from, address _to, uint _tokens) internal {
    require(_to != 0x0);
    require(!isExpired()); // When the melon rots, you can't transfer it
    require(balanceOf[_from] >= _tokens); 
    require(balanceOf[_to] + _tokens >= balanceOf[_to]); // overflow check
    uint previousBalances = balanceOf[_from] + balanceOf[_to];
    balanceOf[_from] -= _tokens;
    balanceOf[_to] += _tokens;
    emit Transfer(_from, _to, _tokens);
    assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
  }
  
  function transfer(address _to, uint _tokens) public returns (bool success) {
    _transfer(msg.sender, _to, _tokens);
    return true; 
  }
  
  /**
   *  approve grants the spender an allowance of _tokens to spend on the sender's behalf
   *
   */
  function approve(address _spender, uint _tokens) public returns (bool success) {
    require(msg.sender != _spender); // Don't be a dummy
    require(!isExpired()); // When the melon rots, you can't transfer it
    allowance[msg.sender][_spender] = _tokens;
    emit Approval(msg.sender, _spender, _tokens);
    return true;
  }
  
  /**
   * transferFrom allows a sender to spend meloncoin on the from address's behalf
   * pending approval
   */
  function transferFrom(address _from, address _to, uint _tokens) public returns (bool success) {
    require(_tokens <= allowance[_from][msg.sender]); 
    allowance[_from][msg.sender] -= _tokens;
    _transfer(_from, _to, _tokens);
    return true;
  }
  
  event Burn(address indexed from, uint8 melons, uint value);
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
  
}
