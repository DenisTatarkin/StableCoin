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
         deposit = calculateCourse(_daiCount);
    }

    address public borrower;
    uint256 public daiCount;
    DAIToken private dai;
    address public daiAddress;
    bool public isOpened;
    uint256 public deposit;
    
    function open() external payable{
        require(msg.sender == borrower);
        require(!isOpened);
        require(msg.value == deposit);
        dai.transfer(borrower, daiCount);
        isOpened = true;
    }
    
    function calculateCourse(uint256 _daiCount) private returns (uint256){
        uint256 recounted = _daiCount * (1000000000000000000 / 5000); // 1 eth = 5000$ => 1000000000000000000 wei = 5000$ => x / dai = 1000000000000000000 / 5000$ => x = dai * (1000000000000000000 / 5000$)
        return recounted;
    }
    
    
}