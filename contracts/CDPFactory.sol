pragma solidity ^0.5.1;
import "@openzeppelin/upgrades/contracts/upgradeability/ProxyFactory.sol";
import "./DAIToken.sol";
import "./CDPAuction.sol";
import "./CDPOracleInterface.sol";
import "./CDPRules.sol";
import "./CDPImpl.sol";

contract CDPFactory is ProxyFactory{
    constructor () public {
       // _implementation = _impl;
        _dai = new DAIToken();
        _oracle = new CDPOracleInterface();
        _rules = new CDPRules();
        _auction = new CDPAuction(address(_dai), address(_oracle), address(_rules));
    }

    address private _implementation;
    address[] public adresses;
    CDPAuction private _auction;
    DAIToken private _dai;
    CDPOracleInterface private _oracle;
    CDPRules private _rules;

    function getCDPImplementationAddress() public view returns (address implementation){
        return _implementation;
    }

    function getDaiAddress() public view returns (address dai){
        return address(_dai);
    }

    function getCDPOracleInterface() public view returns (address oracle){
        return address(_oracle);
    }

    function getCDPRulesAddress() public view returns (address rules){
        return address(_rules);
    }

    function getAuctionAddress() public view returns (address auction){
        return address(_auction);
    }

    function createCDP(uint256 _daiCount) public returns (address){
        bytes memory payload = abi.encodeWithSignature("initialize(address, address, address, address, uint256)", 
                                                  msg.sender, address(_auction), address(_dai), address(_oracle), _daiCount);
        address cdp = deployMinimal(_implementation, payload);
        CDPImpl cdp = new CDPImpl(msg.sender, address(_auction), address(_dai), address(_oracle), address(_rules), _daiCount);
        _dai.mint(cdp, _daiCount);
        adresses.push(address(cdp));
        return address(cdp);
    }
}