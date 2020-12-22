pragma solidity ^0.5.1;
import "@openzeppelin/upgrades/contracts/upgradeability/ProxyFactory.sol";
import "./DAIToken.sol";
import "./CDPAuction.sol";

contract CDPFactory is ProxyFactory{
    constructor (address _impl) public {
        _implementation = _impl;
        _dai = new DAIToken();
        _auction = new CDPAuction(address(_dai));
    }

    address private _implementation;
    CDPAuction private _auction;
    DAIToken private _dai;

    function getCDPImplementationAddress() public view returns (address implementation){
        return _implementation;
    }

    function getDaiAddress() public view returns (address implementation){
        return address(_dai);
    }

    function createCDP(uint32 _daiCount) public returns (address cdp){
        bytes memory args = abi.encodeWithSignature("initialize(address, address, uint32, address)", 
                                                    msg.sender, address(_auction), _daiCount, address(_dai));
        address cdp = deployMinimal(_implementation, args);
        _dai.mint(cdp, msg.sender, _daiCount);
        return cdp;
    }
}