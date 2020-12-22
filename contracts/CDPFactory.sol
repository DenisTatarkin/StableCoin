pragma solidity ^0.5.1;
import "@openzeppelin/upgrades/contracts/upgradeability/ProxyFactory.sol";
import "./DAIToken.sol";

contract CDPFactory is ProxyFactory{
    constructor (address _impl) public {
        _implementation = _impl;
        _dai = new DAIToken();
    }

    address private _implementation;
    DAIToken private _dai;

    function getCDPImplementationAddress() public view returns (address implementation){
        return _implementation;
    }

    function getDaiAddress() public view returns (address implementation){
        return address(_dai);
    }

    function createCDP(uint32 _daiCount) public returns (address cdp){
        bytes memory args = abi.encodeWithSignature("initialize(address,uint32, address)", msg.sender, _daiCount, address(_dai));
        address cdp = deployMinimal(_implementation, args);
        _dai.mint(cdp, _daiCount);
        return cdp;
    }
}