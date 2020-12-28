pragma solidity ^0.5.1;
import './Ownable.sol';
import './DAIToken.sol';

contract CDPImpl{

     constructor(address _borrower, uint256 _daiCount) public {
         borrower = _borrower;
         daiCount = _daiCount;
    }

    address public borrower;
    uint256 public daiCount;
}