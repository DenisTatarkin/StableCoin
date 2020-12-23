pragma solidity ^0.5.1;
import "./Ownable.sol";

contract CDPRules is Ownable{
    constructor() public {
        coeff = 4;
    }

    uint256 private coeff;

    function getCoeff() public returns (uint256 coeff){
        return coeff;
    }

    function setCoeff(uint256 _coeff) onlyOwner public {
        coeff = _coeff;
    }
}