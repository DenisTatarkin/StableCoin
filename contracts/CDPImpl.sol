pragma solidity ^0.5.1;
import './Ownable.sol';
import './DAIToken.sol';
import './CourseOracle.sol';

contract CDPImpl{

     constructor(address payable _borrower, uint256 _daiCount, address _daiAddress, 
                 address _auctionAddress, address _oracleAddress) public {
         borrower = _borrower;
         daiCount = _daiCount;
         daiAddress = _daiAddress;
         dai = DAIToken(_daiAddress);
         isOpened = false;
         isClosed = false;
         deposit = calculateCourse(_daiCount);
         auctionAddress = _auctionAddress;
         oracle = CourseOracle(_oracleAddress);
    }

    address payable public borrower;
    uint256 public daiCount;
    DAIToken private dai;
    CourseOracle private oracle;
    address public daiAddress;
    bool public isOpened;
    bool public isClosed;
    uint256 public deposit;
    address private auctionAddress;
    
    function open() external payable{
        require(msg.sender == borrower);
        require(!isOpened && !isClosed);
        require(msg.value == deposit);
        dai.transfer(borrower, daiCount);
        isOpened = true;
    }
    
    function close() external{
        require(msg.sender == borrower);
        require(isOpened && !isClosed);
        if(!dai.transferFrom(borrower, address(this), daiCount))
            return;
        borrower.transfer(deposit);
        isOpened = false;
        isClosed = true;
    }
    
    function closePartly(uint256 _daiCount) public{
        require(msg.sender == borrower);
        require(isOpened && !isClosed);
        require(_daiCount < daiCount);
        if(!dai.transferFrom(borrower, address(this), _daiCount))
            return;
        daiCount -= _daiCount;
        borrower.transfer(_daiCount * (1000000000000000000 / uint256(oracle.ETH_USD())));
        deposit -= _daiCount * (1000000000000000000 / uint256(oracle.ETH_USD()));
    }
    
    function closeByAuction(address payable _payer) external{
        require(msg.sender == auctionAddress);
        _payer.transfer(deposit);
    }
    
    function calculateCourse(uint256 _daiCount) private returns (uint256){
        uint256 recounted = _daiCount * uint256(1000000000000000000 / uint256(oracle.ETH_USD())); // 1 eth = 5000$ => 1000000000000000000 wei = 5000$ => x / dai = 1000000000000000000 / 5000$ => x = dai * (1000000000000000000 / 5000$)
        return recounted;
    }
    
    
}