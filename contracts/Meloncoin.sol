/**
 * Created on: August 2018
 * @summary: An expiring token backed by the expensive Hokkaido Melon
 * @author: Ann Kilzer
 * akilzer@gmail.com
 */
pragma solidity ^0.4.24;

import './Fruit.sol';
import './ERC20Interface.sol';

/**
 * Inspired by the ethereum.org token, but modified to
 * demonstrate an expiring token.
 * denomination names
 * 10^0: musk
 * 10^12: hokkaido
 * 10^15: yubari
 * 10^18: melon
 *
 * @title: Meloncoin
 */
contract Meloncoin is Fruit, ERC20Interface {

  uint public totalSupply;
  uint8 public decimals = 18; // recommended by Ethereum.org

  // balanceOf keeps track of each address's value
  mapping (address => uint) public balanceOf;
  // allowance grants other owners control over a portion of the tokens
  // This is a map of owners to spenders to allowance
  mapping (address => mapping (address => uint)) public allowance;


/**
 * @dev: Constructs a new meloncoin season. To be created upon planting a new crop.
 * @param uint _initialSupply : How many melon seeds are planted
 * @param uint _plantDate : When the melons are planted
 * @param uint _growingPeriod : How long the melons take to grow in days
 * @param uint _ripePeriod : The shelf life of the melons in days. This is the
 * period in which meloncoin can be redeemed for an investment-grade melon
 * @param address _initialOwner : The account to grant the initial supply of coins
 */
  constructor(uint _initialSupply,
              uint _plantDate,
              uint8 _growingPeriod,
              uint8 _ripePeriod,
              address _initialOwner
              ) Fruit (_plantDate,
                       _growingPeriod,
                       _ripePeriod
                       ) public {
    totalSupply = melonToMusk(_initialSupply);
    balanceOf[_initialOwner] = totalSupply;
    emit Transfer(0x0, _initialOwner, totalSupply);
  }

/**
 * @dev: Burn represents exchanging tokens for a physical, investment-grade melon.
 * You can only burn entire melons when they are ripe.
 * There is no mint. If you want more melons, you have to launch another contract
 * with a new growing season. See the MelonFarm contract.
 * @param uint8 _melons :  The number of melons to burn
 * @return : true if successful
 */
  function burn(uint8 _melons) whenRipe public returns (bool) {
    uint value = _melons * 10 ** uint(decimals);
    require(balanceOf[msg.sender] >= value);
    balanceOf[msg.sender] -= value;
    totalSupply -= value;
    emit Burn(msg.sender, _melons, value);
    return true;
  }

// todo: risk of overflow, be careful!
/**
 * @dev: Helper method that converts whole melons into musk. Recall that
 * 1 melon = 10^decimals musk
 * @param uint _melons : Number of melons
 * @return : Equivalent number of musk
 */
  function melonToMusk(uint _melons) public view returns (uint) {
    return _melons * 10 ** uint(decimals);
  }

/**
 * @dev: Total meloncoin supply in musk
 * @return : Total supply in musk
 */
  function totalSupply() public view returns (uint) {
    return totalSupply;
  }

/**
 * @dev: Retrieves the balance of a given address
 * @param address _tokenOwner :  The address to look up
 * @return : Number of tokens owned by the account, in musk
 */
  function balanceOf(address _tokenOwner) public view returns (uint balance) {
    return balanceOf[_tokenOwner];
  }

/**
 * @dev:
 * @param address tokenOwner :
 * @param address spender :
 * @return :
 */
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    if (isExpired()) {
      return 0;
    }
    return allowance[tokenOwner][spender];
  }

  /**
   * @dev: Internal helper for transfer, can only be called by this contract.
   * @param address _from : The address of the sender
   * @param address _to : The address of the recipient
   * @param uint _tokens : The number of tokens to send, in musk
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

/**
 * @dev: Sends tokens from the caller to a recipient
 * @param address _to :  The address of the recipient
 * @param uint _tokens :  The number of tokens to send, in musk
 * @return : true if successful
 */
  function transfer(address _to, uint _tokens) public returns (bool success) {
    _transfer(msg.sender, _to, _tokens);
    return true;
  }

  /**
   * @dev Grants the spender an allowance of _tokens to spend on the sender's behalf
   * Note that this doesn't sum the tokens, it overwrites any previous allowance.
   * Method will be locked when the melon is expired.
   * @param address _spender : The address to grant the allowance to
   * @param uint _tokens : The number of tokens to set the allowance to
   */
  function approve(address _spender, uint _tokens) public returns (bool success) {
    require(msg.sender != _spender); // Don't be a dummy
    require(!isExpired()); // When the melon rots, you can't transfer it
    allowance[msg.sender][_spender] = _tokens;
    emit Approval(msg.sender, _spender, _tokens);
    return true;
  }

  /**
   * @dev transferFrom allows a sender to spend meloncoin on the from address's behalf
   * pending approval
   * @param address _from : The account from which to withdraw tokens
   * @param address _to : The address of the recipient
   * @param uint _tokens : Number of tokens to transfer in musk
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
