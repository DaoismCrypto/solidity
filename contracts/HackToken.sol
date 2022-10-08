// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HackToken is ERC721 {
    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    address _owner = msg.sender;
    uint256 _supply;
    uint256 public _numTokens = 0;

    mapping(uint256 => Token) tokens;

    event mintToken(address _to, string _serNumber, uint256 _tokenId);
    event transferEvent(address _from, address _to, uint256 _tokenId);

    struct Token {
        string serialNumber;
        string name;
        string information;
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
        string memory _information
    ) public adminOnly {
        uint256 _newTokenId = _numTokens++;
        super._mint(_to, _newTokenId);

        Token memory newToken = Token(
            _serialNumber,
            _name,
            _information,
            block.timestamp,
            address(0)
        );
        _supply = _supply + 1;
        tokens[_newTokenId] = newToken;
        emit mintToken(_to, _serialNumber, _supply);
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

    function getSupply() public view adminOnly returns (uint256) {
        return _supply;
    }
}
