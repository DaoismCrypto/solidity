// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HackToken is ERC721 {
    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {
        _owner = msg.sender;
    }

    address _owner;
    uint256 public _numTokens = 0;
    uint256 _totalSupply;

    mapping(uint256 => Token) tokens;
    mapping(string => uint256) supply;
    mapping(address => uint256[]) accounts;

    mapping(uint256 => uint256) tokenIndex;
    

    event mintToken(address _to, string _serNumber, uint256 _tokenId);
    event transferEvent(address _from, address _to, uint256 _tokenId);

    struct Token {
        string serialNumber;
        string name;
        string information;
        string unit;
        uint256 quota;
        uint256 time;
        address prevOwner;
    }

    modifier adminOnly() {
        require(msg.sender == _owner, "Admin only function");
        _;
    }

    modifier adminOrOwnerOnly(uint256 _tokenId) {
        require(
            msg.sender == _owner || msg.sender == ownerOf(_tokenId),
            "Admin or owner only function"
        );
        _;
    }

    function mint(
        address _to,
        string memory _serialNumber,
        string memory _name,
        string memory _information,
        string memory _unit,
        uint256 _quota
    ) public adminOnly {
        uint256 _newTokenId = _numTokens++;
        super._mint(_to, _newTokenId);

        Token memory newToken = Token(
            _serialNumber,
            _name,
            _information,
            _unit,
            _quota,
            block.timestamp,
            address(0)
        );
        supply[_name] += _quota;
        tokens[_newTokenId] = newToken;
        accounts[_to].push(_newTokenId);
        tokenIndex[_newTokenId] = accounts[_to].length - 1;
        emit mintToken(_to, _serialNumber, _quota);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override adminOrOwnerOnly(_tokenId) {
        tokens[_tokenId].prevOwner = _from;
        super.transferFrom(_from, _to, _tokenId);
        if (accounts[_from].length == 1) {
            accounts[_from];
        } else {
            accounts[_from][tokenIndex[_tokenId]] = accounts[_from][accounts[_from].length - 1];
            tokenIndex[accounts[_from][accounts[_from].length - 1]] = tokenIndex[_tokenId];
            tokenIndex[_tokenId] = 0;
            accounts[_from].pop();
            
        }
        accounts[_to].push(_tokenId);
        tokenIndex[_tokenId] = accounts[_to].length-1;
        emit transferEvent(_from, _to, _tokenId);
    }


    function getPrevOwner(uint256 _tokenId) public view returns (address) {
        return tokens[_tokenId].prevOwner;
    }

    function getSupply(string memory _name) public view returns (uint256) {
        return supply[_name];
    }

    function getInfo(uint256 _tokenId) public view returns (string memory) {
        return tokens[_tokenId].information;
    }

    function getQuota(uint256 _tokenId) public view returns (uint256) {
        return tokens[_tokenId].quota;
    }

    function getUnit(uint256 _tokenId) public view returns (string memory) {
        return tokens[_tokenId].unit;
    }

    function getToken(uint256 _tokenId) public view returns (string memory, string memory, string memory, string memory, uint256, uint256, address) {
        return (tokens[_tokenId].serialNumber, tokens[_tokenId].name, tokens[_tokenId].information, tokens[_tokenId].unit, tokens[_tokenId].quota, tokens[_tokenId].time, tokens[_tokenId].prevOwner);
    }

    function getTokenWithOwner(uint256 _tokenId) public view returns (string memory, string memory, string memory, string memory, uint256, uint256, address) {
        return (tokens[_tokenId].serialNumber, tokens[_tokenId].name, tokens[_tokenId].information, tokens[_tokenId].unit, tokens[_tokenId].quota, tokens[_tokenId].time, ownerOf(_tokenId));
    }

    function getTokenList() public view returns (uint256[] memory ){
        return accounts[msg.sender];
    }
}
