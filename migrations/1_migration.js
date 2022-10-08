const HackToken = artifacts.require("HackToken")
const TokenMarket = artifacts.require("TokenMarket")

module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await deployer.deploy(HackToken, "CO2", "CO", { from: accounts[0] });
        await deployer.deploy(TokenMarket, HackToken.address);
    });
}