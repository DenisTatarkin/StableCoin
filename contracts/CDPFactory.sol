pragma solidity ^0.5.1;
import "./CDPImpl.sol";
import './DAIToken.sol';

contract CDPFactory {
    constructor() public{
        dai = new DAIToken();
        daiAddress = address(dai);
    }
    
    address public implementation;
    address public daiAddress;
    DAIToken private dai;
    address[] public cdps; //for testing!!!

    function createCDP(uint256 _daiCount) public returns (address){
        address cdp = address(new CDPImpl(msg.sender, _daiCount, daiAddress));
        dai.mint(cdp, _daiCount);
        cdps.push(cdp);
        return cdp;
    }
}