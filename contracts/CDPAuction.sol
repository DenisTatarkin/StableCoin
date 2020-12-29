pragma solidity ^0.5.1;
import './Ownable.sol';
import './CDPImpl.sol';
import './DAIToken.sol';
import './CourseOracle.sol';

contract CDPAuction is Ownable {
    
    constructor(address _daiAddress, address _oracleAddress) public {
        dai = DAIToken(_daiAddress);
        oracle = CourseOracle(_oracleAddress);
        cdpsCount = 0;
    }
    
    struct OpenedCDP{
        address cdpAddress;
        uint256 daiCount;
        uint256 deposit;
        bool isClosed;
    }
    
    OpenedCDP[] public openedCDPs;
    OpenedCDP[] public auctionedCDPs;
    mapping(address => bool) private isAuctioned;
    uint256 private cdpsCount;
    DAIToken private dai;
    CourseOracle private oracle;
    
    address[] public testcdps; //for testing!!!
    
    function addCDP(address _cdpAddress) external onlyOwner{
        CDPImpl cdp = CDPImpl(_cdpAddress);
        require(!cdp.isOpened() && !cdp.isClosed());
        openedCDPs.push(OpenedCDP(_cdpAddress, cdp.daiCount(), cdp.deposit(), false));
        cdpsCount++;
    }
    
    function audit() external {
        for(uint i = 0; i < cdpsCount; i++){
            CDPImpl cdp = CDPImpl(openedCDPs[i].cdpAddress);
            testcdps.push(address(cdp));
            if(!cdp.isOpened())
                continue;
            uint256 calculatedCourse = calculateCourse(cdp.daiCount());
            if(cdp.deposit() - uint256(cdp.deposit() / uint256(4)) < calculatedCourse){
                auctionedCDPs.push(OpenedCDP(address(cdp), cdp.daiCount(), cdp.deposit(), false));
                isAuctioned[address(cdp)] = true;
            }
        }
    }
    
    function buyCDP(address _cdpAddress) external {
        CDPImpl cdp = CDPImpl(_cdpAddress);
        require(isAuctioned[_cdpAddress]);
        require(!cdp.isClosed());
        dai.transferFrom(msg.sender, address(this), cdp.daiCount());
        cdp.closeByAuction(msg.sender);
    }
    
     function calculateCourse(uint256 _daiCount) private returns (uint256){
        uint256 recounted = _daiCount * uint256(1000000000000000000 / uint256(oracle.ETH_USD())); // 1 eth = 5000$ => 1000000000000000000 wei = 5000$ => x / dai = 1000000000000000000 / 5000$ => x = dai * (1000000000000000000 / 5000$)
        return recounted;
    }
}