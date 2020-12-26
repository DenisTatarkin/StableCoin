const CDPImpl = artifacts.require("CDPImpl");
const CDPFactory = artifacts.require("CDPFactory");

module.exports = function(deployer) {
    deployer.deploy(CDPImpl).then(
        () => deployer.deploy(CDPFactory, CDPImpl.address). then(
            () => console.log("CDPFactory address : " + CDPFactory.address)
        )
    )
}