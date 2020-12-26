pragma solidity ^0.5.1;
import "./Ownable.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
/*
This contract is intended to provide off-chain information 
about the current dollar exchange rate in relation to the Ethereum.
*/
contract CDPOracleInterface is Ownable{
    constructor() public {
        priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    }

    AggregatorV3Interface internal priceFeed;
    function getDollarRate() public view returns(int dollarRate){
        
        return 3000;
    }
}