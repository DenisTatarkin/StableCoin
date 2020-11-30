pragma solidity ^0.5.1;
import "./Ownable.sol";

/*
This contract is intended to provide off-chain information 
about the current dollar exchange rate in relation to the Ethereum.
*/
contract CDPOracleInterface is Ownable{
    uint32 private _dollarRate;

    function setDollarRate(uint32 _rate) onlyOwner external{
        _dollarRate = _rate;
    }

    function getDollarRate() public view returns(uint32 dollarRate){
        return _dollarRate;
    }
}