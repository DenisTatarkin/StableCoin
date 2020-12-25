pragma solidity ^0.5.1;
import "./Ownable.sol";


contract DAIToken is Ownable{
    
    string public name = "DAI token";
    string public symbol = "DAI";
    uint32 constant public decimals = 18;
    
    uint256 public totalSupply ;
    uint32 public maxSupply = 1000;
    mapping(address=>uint256) public balances;
    
    mapping (address => mapping(address => uint)) allowed;
    
    
  function mint(address _to, uint _value) public onlyOwner {
    assert(totalSupply + _value <= maxSupply || (totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]));
    balances[_to] += _value;
    totalSupply += _value;
  }

  function balanceOf(address _owner) public returns (uint balance) {
    return balances[_owner];
  }

  function transfer(address _to, uint _value) public returns (bool success) {
    if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      emit Transfer(msg.sender, _to, _value);
      return true;
    }
    return false;
  }

  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
    if( allowed[_from][msg.sender] >= _value &&
    balances[_from] >= _value
    && balances[_to] + _value >= balances[_to]) {
      allowed[_from][msg.sender] -= _value;
      balances[_from] -= _value;
      balances[_to] += _value;
      emit Transfer(_from, _to, _value);
      return true;
    }
    return false;
  }

  function approve(address _spender, uint _value) public returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public returns (uint remaining) {
    return allowed[_owner][_spender];
  }

  event Transfer(address indexed _from, address indexed _to, uint _value);

  event Approval(address indexed _owner, address indexed _spender, uint _value);


}