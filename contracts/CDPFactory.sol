pragma solidity ^0.5.1;
import "@openzeppelin/upgrades/contracts/upgradeability/ProxyFactory.sol";
import "./DAIToken.sol";
import "./CDPAuction.sol";
import "./CDPOracleInterface.sol";
import "./CDPRules.sol";

contract CDPFactory is ProxyFactory{
    constructor (address _impl) public {
        _implementation = _impl;
        _dai = new DAIToken();
        _oracle = new CDPOracleInterface();
        _rules = new CDPRules();
        _auction = new CDPAuction(address(_dai), address(_oracle), address(_rules));
    }

    address private _implementation;
    CDPAuction private _auction;
    DAIToken private _dai;
    CDPOracleInterface private _oracle;
    CDPRules private _rules;

    function getCDPImplementationAddress() public view returns (address implementation){
        return _implementation;
    }

    function getDaiAddress() public view returns (address implementation){
        return address(_dai);
    }

    function createCDP(uint32 _daiCount) public returns (address cdp){
        bytes memory args = abi.encodeWithSignature("initialize(address, address, uint32, address, address)", 
                                                    msg.sender, address(_auction), _daiCount, address(_dai), address(_oracle));
        address cdp = deployMinimal(_implementation, args);
        _dai.mint(cdp, _daiCount);
        return cdp;
    }
}