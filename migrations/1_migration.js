const HackToken = artifacts.require("HackToken")
const TokenMarket = artifacts.require("TokenMarket")

module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await deployer.deploy(HackToken, "CO2", "CO");
        await deployer.deploy(TokenMarket, HackToken.address);
    });
}