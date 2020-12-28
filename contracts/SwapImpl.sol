pragma solidity ^0.5.1;
import '@openzeppelin/upgrades/contracts/Initializable.sol';
import './Ownable.sol';

contract SwapImpl is Initializable{
    //Using initialize instead of constructor.
    function initialize (address _userA, uint256 count) public {  
        userA = _userA;
        tokenAcount = count;
    }
    
    uint256 public tokenAcount;  
    uint256 public tokenBcount;
    address public userA;
    address public userB;
    bool public done = false;
    
    function acceptSwap() public{
        require(!done);
        userB = msg.sender;
        done = true;
    }
}