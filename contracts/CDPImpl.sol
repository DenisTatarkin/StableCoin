pragma solidity ^0.5.1;
import './Ownable.sol';
import './DAIToken.sol';

contract CDPImpl{

     constructor(address _borrower, uint256 _daiCount, address _daiAddress) public {
         borrower = _borrower;
         daiCount = _daiCount;
         daiAddress = _daiAddress;
         dai = DAIToken(_daiAddress);
         isOpened = false;
    }

    address public borrower;
    uint256 public daiCount;
    DAIToken private dai;
    address public daiAddress;
    bool public isOpened;
    
    function open() external{
        require(msg.sender == borrower);
        require(!isOpened);
        dai.transfer(borrower, daiCount);
        isOpened = true;
    }
}