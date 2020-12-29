pragma solidity ^0.5.1;
import "./CDPImpl.sol";
import './DAIToken.sol';
import './CDPAuction.sol';

contract CDPFactory {
    constructor() public{
        dai = new DAIToken();
        daiAddress = address(dai);
        auction = new CDPAuction();
        auctionAddress = address(auction);
    }
    
    address public implementation;
    address public daiAddress;
    address public auctionAddress;
    DAIToken private dai;
    CDPAuction private auction;
    address[] public cdps; //for testing!!!

    function createCDP(uint256 _daiCount) public returns (address){
        address cdp = address(new CDPImpl(msg.sender, _daiCount, daiAddress));
        dai.mint(cdp, msg.sender, _daiCount);
        auction.addCDP(cdp);
        cdps.push(cdp); // for testing!
        return cdp;
    }
}