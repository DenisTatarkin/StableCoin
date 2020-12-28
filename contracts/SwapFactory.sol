pragma solidity ^0.5.1;
import '@openzeppelin/upgrades/contracts/upgradeability/ProxyFactory.sol';

contract SwapFactory is ProxyFactory {
  address public implementationContract;
  constructor (address _implementationContract) public {
    implementationContract = _implementationContract;
  }

  function createSwap(uint256 count) public returns (address){
    bytes memory payload = abi.encodeWithSignature("initialize(address, uint256)", 
                                                    msg.sender, count);
    address proxy = deployMinimal(implementationContract, payload);
    return proxy;
  }
}