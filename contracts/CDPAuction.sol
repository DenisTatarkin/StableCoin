pragma solidity ^0.5.1;
import './Ownable.sol';
import './CDPImpl.sol';

contract CDPAuction is Ownable {
    
    constructor() public {
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
    mapping(address => bool) private isAdded;
    uint256 private cdpsCount;
    
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
            if(cdp.deposit() - uint256(cdp.deposit() / uint256(4)) < calculatedCourse)
                auctionedCDPs.push(OpenedCDP(address(cdp), cdp.daiCount(), cdp.deposit(), false));
        }
    }
    
     function calculateCourse(uint256 _daiCount) private returns (uint256){
        uint256 recounted = _daiCount * uint256(1000000000000000000 / uint256(2500)); // 1 eth = 5000$ => 1000000000000000000 wei = 5000$ => x / dai = 1000000000000000000 / 5000$ => x = dai * (1000000000000000000 / 5000$)
        return recounted;
    }
}