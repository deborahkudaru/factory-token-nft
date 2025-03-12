// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract ERC721FromScratch {
    string private name;
    string private symbol;
    uint private deedId;
    address private owner;

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    mapping(uint => address) private owners;
    mapping(address => uint) private balances;
    mapping(uint => address) private tokenApprovals;
    mapping(address => mapping(address => bool)) private operatorApprovals;
    mapping(uint => string) tokenUris;

    constructor(string memory _name, string memory _symbol, address _owner) {
        name = _name;
        symbol = _symbol;
        owner = _owner;
    }

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed _deedId
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed _deedId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    error NotOwnerOfToken();
    error NotApproved();
    error NotApprovedForAll();
    error TokenDoesNotExist();
    error NotOwnerOrApproved();
    error InvalidRecipient();
    error CannotApproveSelf();
    error NonERC721Receiver();
    error InvalidAddress();

    function ownerOf(uint256 _deedId) external view returns (address _owner) {
        address owner_ = owners[_deedId];
        if (owner_ == address(0)) revert TokenDoesNotExist();
        return owner_;
    }

    function transfer(address _to, uint256 _deedId) external payable {
        if (_to == address(0)) revert InvalidRecipient();
        if (msg.sender != owners[_deedId]) revert NotOwnerOfToken();

        balances[msg.sender] -= 1;
        balances[_to] += 1;
        owners[_deedId] = _to;

        delete tokenApprovals[_deedId];

        emit Transfer(msg.sender, _to, _deedId);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }

    function approve(address _to, uint256 _deedId) public {
        address owner_ = owners[_deedId];
        if (owner_ == address(0)) revert TokenDoesNotExist();
        if (msg.sender != owner_) revert NotOwnerOfToken();
        if (_to == owner_) revert CannotApproveSelf();

        tokenApprovals[_deedId] = _to;
        emit Approval(owner_, _to, _deedId);
    }

    function transferFrom(address _from, address _to, uint256 _deedId) public {
        address owner_ = owners[_deedId];

        if (owner == address(0)) revert TokenDoesNotExist();
        if (
            msg.sender != owner_ &&
            msg.sender != tokenApprovals[_deedId] &&
            !operatorApprovals[owner_][msg.sender]
        ) {
            revert NotOwnerOrApproved();
        }
        if (_to == address(0)) revert InvalidRecipient();

        balances[_from] -= 1;
        balances[_to] += 1;
        owners[_deedId] = _to;

        delete tokenApprovals[_deedId];

        emit Transfer(_from, _to, _deedId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        if (_operator == msg.sender) revert CannotApproveSelf();

        operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool) {
        return operatorApprovals[_owner][_operator];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) external pure returns (bool) {
        return
            interfaceId == _INTERFACE_ID_ERC165 ||
            interfaceId == _INTERFACE_ID_ERC721 ||
            interfaceId == _INTERFACE_ID_ERC721_METADATA;
    }

    function isApprovedOrOwner(
        address _spender,
        uint256 _deedId
    ) internal view returns (bool) {
        address owner_ = owners[_deedId];
        return (_spender == owner_ ||
            tokenApprovals[_deedId] == _spender ||
            operatorApprovals[owner_][_spender]);
    }

    function _mint(
        address to,
        uint256 _deedId,
        string memory uri
    ) internal onlyOwner {
        if (to == address(0)) revert InvalidAddress();

        balances[to] += 1;
        owners[_deedId] = to;
        tokenUris[_deedId] = uri;

        emit Transfer(address(0), to, _deedId);
    }

    function _burn(uint256 _deedId) internal {
        address owner_ = owners[_deedId];
        if (owner_ == address(0)) revert TokenDoesNotExist();
        if (!isApprovedOrOwner(msg.sender, _deedId))
            revert NotOwnerOrApproved();

        balances[owner_] -= 1;
        delete owners[_deedId];
        delete tokenUris[_deedId];

        emit Transfer(owner_, address(0), _deedId);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You're not the owner!");
        _;
    }
}