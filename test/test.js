const _deploy_contracts = require("../migrations/1_migration");
const truffleAssert = require("truffle-assertions");
var assert = require('assert');

var HackToken = artifacts.require("../contracts/HackToken.sol");
var TokenMarket = artifacts.require("../contracts/TokenMarket.sol");

contract('TokenMarket', function (accounts) {

    before(async () => {
        hackTokenInstance = await HackToken.deployed();
        tokenMarketInstance = await TokenMarket.deployed();
    });

    it("Only admin can Mint", async () => {
        await truffleAssert.reverts(
            hackTokenInstance.mint(accounts[1], "1234321312", "CO2", "Singapore East", {
                from: accounts[3],
            }),
            "Admin only function"
        );
    });

    it("Mint tokens", async () => {
        const minted_token_1 = await hackTokenInstance.mint(
            accounts[1],
            "12345678",
            "C02",
            "Sinagore West", {
            from: accounts[0],
        }
        );

        const minted_token_2 = await hackTokenInstance.mint(
            accounts[2],
            "12345999",
            "C02",
            "Sinagore West", {
            from: accounts[0],
        }
        );

        const totalSupply = await hackTokenInstance.getSupply();
        assert.equal(totalSupply, 2);
    });

    // it("Transfer ownership of tokenn", async () => {
    //     let transfer_1 = await hackTokenInstance.transferFrom(
    //         accounts[1],
    //         accounts[2],
    //         0,
    //         { from: accounts[1] }
    //     ); // valid token id

    //     let transfer_2 = await hackTokenInstance.transferFrom(
    //         accounts[3],
    //         accounts[4],
    //         2,
    //         { from: accounts[3] }
    //     ); // invalid token id

    //     truffleAssert.eventEmitted(transfer_1, "transferEvent");
    //     assert.equal(await hackTokenInstance.ownerOf(0), accounts[2]);
    //     assert.equal(await hackTokenInstance.ownerOf(2), accounts[4]);
    // });
});