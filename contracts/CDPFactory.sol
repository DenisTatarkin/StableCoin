pragma solidity ^0.5.1;
import "./CDPImpl.sol";

contract CDPFactory {
    address public implementation;

    function createCDP(uint256 _daiCount) public returns (address){
        address cdp = address(new CDPImpl(msg.sender, _daiCount));
        return cdp;
    }
}