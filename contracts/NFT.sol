// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
contract NFT {
    // string public name = "BEE NFT";
    // string public symbol = "BEE";
    mapping(address => uint256) private balances;
    mapping(uint256 => address) private owners;
    mapping(uint256 => address) private tokenApprovals;
    mapping(address => mapping(address => bool)) private operatorApprovals;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    constructor(string memory _name, string memory _symbol) {
        // name = _name;
        // symbol = _symbol;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return owners[_tokenId];
    }

    function transfer(address _to, uint256 _tokenId) external {
        require(owners[_tokenId] == msg.sender, "NFT: not owner");
        require(_to != address(0), "NFT: transfer to the zero address");

        balances[msg.sender] -= 1;
        balances[_to] += 1;
        owners[_tokenId] = _to;

        emit Transfer(msg.sender, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external {
        require(owners[_tokenId] == _from, "NFT: not owner");
        require(_to != address(0), "NFT: transfer to the zero address");

        balances[_from] -= 1;
        balances[_to] += 1;
        owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) external {
        address owner = owners[_tokenId];
        require(msg.sender == owner, "NFT: not owner");

        emit Approval(owner, _to, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        emit ApprovalForAll(msg.sender, 
        _operator, _approved);
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool) {
        return operatorApprovals[_owner][_operator];
    }
}
