const HackToken = artifacts.require("HackToken")

module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await deployer.deploy(HackToken);
        await deployer.deploy(TokenMarket, Dice.address);
    });
}