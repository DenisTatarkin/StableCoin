pragma solidity ^0.5.1;
import "@openzeppelin/upgrades/contracts/upgradeability/ProxyFactory.sol";

contract CDPFactory is ProxyFactory{
    constructor (address _impl) public {
        _implementation = _impl;
    }

    address private _implementation;

    function getImplementationAddress() public view returns (address implementation){
        return _implementation();
    }

    function createCDP(uint32 _daiCount) public returns (address cdp){
        bytes memory args = abi.encodeWithSignature("initialize(address,uint32)", msg.sender, _daiCount);
        return deployMinimal(_implementation, args);
    }
}