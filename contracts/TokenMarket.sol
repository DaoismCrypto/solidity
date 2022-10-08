// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./HackToken.sol";

contract TokenMarket {
    HackToken tokenContract;
    mapping(uint256 => uint256) listPrice;

    constructor(HackToken tokenAddress) {
        tokenContract = tokenAddress;
    }

    modifier preOwnerOnly(uint256 id) {
        require(
            msg.sender == tokenContract.getPrevOwner(id),
            "Must be previous Owner"
        );
        _;
    }

    function list(uint256 id, uint256 price) public preOwnerOnly(id) {
        listPrice[id] = price;
    }

    function changePrice(uint256 id, uint256 price) public preOwnerOnly(id) {
        listPrice[id] = price;
    }

    function unlist(uint256 id) public preOwnerOnly(id) {
        listPrice[id] = 0;
    }

    function transferBack(uint256 id) public preOwnerOnly(id) {
        address preOwner = tokenContract.getPrevOwner(id);
        tokenContract.transferFrom(address(this), preOwner, id);
    }

    function buyToken(uint256 id) public payable {
        require(listPrice[id] != 0, "Invalid token id");
        require(msg.value >= listPrice[id], "Not Enough Value to Buy");

        address recipient = tokenContract.getPrevOwner(id);
        payable(recipient).transfer(msg.value);
        tokenContract.transferFrom(address(this), msg.sender, id);
    }

    function getPrice(uint256 id) public view returns (uint256) {
        return listPrice[id];
    }

    function getInfo(uint256 id) public view returns (string memory) {
        return tokenContract.getInfo(id);
    }

    function getUnit(uint256 id) public view returns (string memory) {
        return tokenContract.getUnit(id);
    }

    function getQuota(uint256 id) public view returns (uint256) {
        return tokenContract.getQuota(id);
    }
}
