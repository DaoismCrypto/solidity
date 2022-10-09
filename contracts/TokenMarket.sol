// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./HackToken.sol";

contract TokenMarket {
    HackToken tokenContract;
    mapping(uint256 => uint256) listPrice;
    mapping(uint256 => uint256) listIndex;
    mapping(uint256 => uint256) isListed;
    uint256 listNum = 0;

    uint[] listedToken;

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
        listedToken.push(id);
        isListed[id] = listNum;
        listPrice[id] = price;
        listNum += 1;
    }

    function changePrice(uint256 id, uint256 price) public preOwnerOnly(id) {
        listPrice[id] = price;
    }

   function remove(uint index) private returns(uint[] memory) {
        if (listedToken.length == 1) {
            listedToken.pop();
            return listedToken;
        }

        uint256 lastElement = listedToken[listedToken.length - 1];

        listIndex[lastElement] = index;
        listedToken[index] = lastElement;
        listedToken.pop();

        return listedToken;
    }

    function unlist(uint256 id) public preOwnerOnly(id) {
        require(listPrice[id] == 0, "Token is not listed");
        listIndex[id] = 0;
        listedToken = remove(listIndex[id]);
        listNum -= 1;
        listPrice[id] = 0;
    }

    function transferBack(uint256 id) public preOwnerOnly(id) {
        require(listPrice[id] == 0, "Token must be unlist first");
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

    function getAllListedToken() public view returns (uint[] memory) {
        return listedToken;
    }
}
