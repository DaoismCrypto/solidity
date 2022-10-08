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
            hackTokenInstance.mint(accounts[1], "1234321312", "CO2", "Singapore East", "ton", 100,
                {
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
            "Sinagore West",
            "ton",
            100,
            {
                from: accounts[0],
            }
        );

        const minted_token_2 = await hackTokenInstance.mint(
            accounts[2],
            "12345678",
            "C02",
            "Sinagore West",
            "ton",
            100,
            {
                from: accounts[0],
            }
        );
    });

    it("Check token unit", async () => {
        let unit = await tokenMarketInstance.getUnit(1);

        assert.notStrictEqual(
            unit,
            undefined,
            "Failed to check unit"
        );
    })

    it("Transfer ownership of tokenn", async () => {
        let transfer_1 = await hackTokenInstance.transferFrom(
            accounts[1],
            accounts[2],
            0,
            { from: accounts[1] }
        );

        truffleAssert.eventEmitted(transfer_1, "transferEvent");
    });

    it("Transfer to Market", async () => {
        const minted_token_2 = await hackTokenInstance.mint(
            accounts[1],
            "12345678",
            "C02",
            "Sinagore West",
            "ton",
            100,
            {
                from: accounts[0],
            }
        );

        await truffleAssert.passes(
            hackTokenInstance.transferFrom(accounts[1], tokenMarketInstance.address, 2, { from: accounts[1] })
        );
    });

    it('List the token', async () => {
        await truffleAssert.passes(
            tokenMarketInstance.list(2, '1000000000000000000', { from: accounts[1] })
        );
    });

    it("Check Unit in market", async () => {
        let unit = await tokenMarketInstance.getUnit(2);

        assert.notStrictEqual(
            unit,
            undefined,
            "Failed to check unit"
        );
    })

    it('Change the list price of Token', async () => {
        await truffleAssert.passes(
            tokenMarketInstance.changePrice(2, '2000000000000000000', { from: accounts[1] })
        );
    });

    it('Unlist the token', async () => {
        await truffleAssert.passes(
            tokenMarketInstance.unlist(2, { from: accounts[1] })
        );
    });

    it('Check Market Price', async () => {
        tokenMarketInstance.list(2, '1000000000000000000', { from: accounts[1] })
        let price = await tokenMarketInstance.getPrice(2);

        assert.notStrictEqual(
            price,
            undefined,
            "Failed to check price"
        );
    });

    it("Buy token", async () => {
        await truffleAssert.passes(
            tokenMarketInstance.buyToken(2, { from: accounts[2], value: 1000000000000000000 })
        );
    })

});