const HackToken = artifacts.require("HackToken")

module.exports = (deployer, network, accounts) => {
    deployer.deploy(HackToken, "Apple", "AAPL")
}