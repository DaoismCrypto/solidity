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
        supply[_unit] += _quota;
        tokens[_newTokenId] = newToken;
        emit mintToken(_to, _serialNumber, _quota);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override adminOrOwnerOnly(_tokenId) {
        tokens[_tokenId].prevOwner = _from;
        super.transferFrom(_from, _to, _tokenId);
        emit transferEvent(_from, _to, _tokenId);
    }

    function getPrevOwner(uint256 _tokenId) public view returns (address) {
        return tokens[_tokenId].prevOwner;
    }

    function getSupply(string memory unit) public view returns (uint256) {
        return supply[unit];
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
}
