pragma solidity ^0.5.1;

contract CourseOracle {
    
    uint256 public ETH_USD;

    function upd_ETH_USD(uint256 _new) external{
        ETH_USD = _new;
    }
}