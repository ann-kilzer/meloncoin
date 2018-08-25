/**
 * Created on: August 2018
 * @summary: An expiring token backed by the expensive Hokkaido Melon
 * @author: Ann Kilzer
 * akilzer@gmail.com
 */
pragma solidity 0.4.24;

import './Fruit.sol';
import './ERC20Interface.sol';
import 'openzeppelin-solidity/contracts/lifecycle/Pausable.sol';
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * Inspired by the ethereum.org token, but modified to
 * demonstrate an expiring token.
 * denomination names
 * 10^0: musk
 * 10^12: hokkaido
 * 10^15: yubari
 * 10^18: melon
 *
 * @title Meloncoin
 */
contract Meloncoin is Fruit, ERC20Interface, Pausable {

  uint public totalSupply;
  uint8 public decimals = 18; // recommended by Ethereum.org

  // balanceOf keeps track of each address's value
  mapping (address => uint) public balanceOf;
  // allowance grants other owners control over a portion of the tokens
  // This is a map of owners to spenders to allowance
  mapping (address => mapping (address => uint)) public allowance;

/**
 * @dev Constructs a new meloncoin season. To be created upon planting a new crop.
 * @param _initialSupply : How many melon seeds are planted
 * @param _plantDate : When the melons are planted
 * @param _growingPeriod : How long the melons take to grow in days
 * @param _ripePeriod : The shelf life of the melons in days. This is the
 * period in which meloncoin can be redeemed for an investment-grade melon
 * @param _initialOwner : The account to grant the initial supply of coins
 */
  constructor(uint16 _initialSupply,
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
 * @dev Burn represents exchanging tokens for a physical, investment-grade melon.
 * You can only burn entire melons when they are ripe.
 * There is no mint. If you want more melons, you have to launch another contract
 * with a new growing season. See the MelonFarm contract.
 * @param _melons :  The number of melons to burn
 * @return : true if successful
 */
  function burn(uint16 _melons) whenRipe whenNotPaused public returns (bool) {
    uint value = melonToMusk(_melons);
    require(balanceOf[msg.sender] >= value);
    balanceOf[msg.sender] -= value;
    totalSupply -= value;
    emit Burn(msg.sender, _melons, value);
    return true;
  }

/**
 * @dev Helper method that converts whole melons into musk. Recall that
 * 1 melon = 10^decimals musk
 * @param _melons : Number of melons
 * @return : Equivalent number of musk
 */
  function melonToMusk(uint16 _melons) public view returns (uint) {
    return SafeMath.mul(uint(_melons), (10 ** uint(decimals)));
  }

/**
 * @dev Total meloncoin supply in musk
 * @return : Total supply in musk
 */
  function totalSupply() public view returns (uint) {
    return totalSupply;
  }

/**
 * @dev Retrieves the balance of a given address
 * @param _tokenOwner :  The address to look up
 * @return : Number of tokens owned by the account, in musk
 */
  function balanceOf(address _tokenOwner) public view returns (uint balance) {
    return balanceOf[_tokenOwner];
  }

/**
 * @dev Returns a spender's allowance from a token owner
 * @param _tokenOwner : The owner of the tokens
 * @param _spender : The party spending the tokens
 * @return : The number of tokens that the spender can spend on the tokenOwner's behalf
 */
  function allowance(address _tokenOwner, address _spender) public view returns (uint remaining) {
    if (isExpired()) {
      return 0;
    }
    return allowance[_tokenOwner][_spender];
  }

  /**
   * @dev Internal helper for transfer, can only be called by this contract.
   * @param _from : The address of the sender
   * @param _to : The address of the recipient
   * @param _tokens : The number of tokens to send, in musk
   */
  function _transfer(address _from, address _to, uint _tokens)
  whenNotPaused
  validDestination(_to)
  internal {
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
 * @dev Sends tokens from the caller to a recipient
 * @param _to :  The address of the recipient
 * @param _tokens :  The number of tokens to send, in musk
 * @return : true if successful
 */
  function transfer(address _to, uint _tokens) whenNotPaused public returns (bool success) {
    _transfer(msg.sender, _to, _tokens);
    return true;
  }

  /**
   * @dev Grants the spender an allowance of _tokens to spend on the sender's behalf
   * Note that this doesn't sum the tokens, it overwrites any previous allowance.
   * Method will be locked when the melon is expired.
   * @param _spender : The address to grant the allowance to
   * @param _tokens : The number of tokens to set the allowance to
   */
  function approve(address _spender, uint _tokens) whenNotPaused public returns (bool success) {
    require(msg.sender != _spender); // Don't be a dummy
    require(!isExpired()); // When the melon rots, you can't transfer it
    allowance[msg.sender][_spender] = _tokens;
    emit Approval(msg.sender, _spender, _tokens);
    return true;
  }

  /**
   * @dev transferFrom allows a sender to spend meloncoin on the from address's behalf
   * pending approval
   * @param _from : The account from which to withdraw tokens
   * @param _to : The address of the recipient
   * @param _tokens : Number of tokens to transfer in musk
   */
  function transferFrom(address _from, address _to, uint _tokens) public
  whenNotPaused
  validDestination(_to)
  returns (bool success) {
    require(_tokens <= allowance[_from][msg.sender]);
    allowance[_from][msg.sender] -= _tokens;
    _transfer(_from, _to, _tokens);
    return true;
  }

  event Burn(address indexed from, uint16 melons, uint value);
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

  modifier validDestination( address _to ) {
    require(_to != address(0x0));
    require(_to != address(this));
    _;
  }
}
