// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Interface ID constants for ERC-165
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract NFT is IERC165 {
    string public name = "BEE NFT";
    string public symbol = "BEE";
    
    // Interface IDs
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    
    // ERC721Receiver interface constant
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
    
    mapping(address => uint256) private balances;
    mapping(uint256 => address) private owners;
    mapping(uint256 => address) private tokenApprovals;
    mapping(address => mapping(address => bool)) private operatorApprovals;
    
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
    
    // ERC-165 implementation
    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        return
            interfaceId == _INTERFACE_ID_ERC165 ||
            interfaceId == _INTERFACE_ID_ERC721 ||
            interfaceId == _INTERFACE_ID_ERC721_METADATA;
    }
    
    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "NFT: address zero is not a valid owner");
        return balances[_owner];
    }
    
    function ownerOf(uint256 _tokenId) external view returns (address) {
        address owner = owners[_tokenId];
        require(owner != address(0), "NFT: owner query for nonexistent token");
        return owner;
    }
    
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "NFT: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, data);
    }
    
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "NFT: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, "");
    }
    
    function transferFrom(address from, address to, uint256 tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "NFT: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }
    
    function approve(address to, uint256 tokenId) external {
        address owner = owners[tokenId];
        require(to != owner, "NFT: approval to current owner");
        require(
            msg.sender == owner || operatorApprovals[owner][msg.sender],
            "NFT: approve caller is not owner nor approved for all"
        );
        
        tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }
    
    function setApprovalForAll(address operator, bool approved) external {
        require(operator != msg.sender, "NFT: approve to caller");
        operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }
    
    function getApproved(uint256 tokenId) external view returns (address) {
        require(_exists(tokenId), "NFT: approved query for nonexistent token");
        return tokenApprovals[tokenId];
    }
    
    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool) {
        return operatorApprovals[owner][operator];
    }
    
    // Additional helper functions
    function _exists(uint256 tokenId) internal view returns (bool) {
        return owners[tokenId] != address(0);
    }
    
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = owners[tokenId];
        require(owner != address(0), "NFT: operator query for nonexistent token");
        return (
            spender == owner ||
            tokenApprovals[tokenId] == spender ||
            operatorApprovals[owner][spender]
        );
    }
    
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "NFT: transfer to non ERC721Receiver implementer");
    }
    
    function _transfer(address from, address to, uint256 tokenId) internal {
        require(owners[tokenId] == from, "NFT: transfer from incorrect owner");
        require(to != address(0), "NFT: transfer to the zero address");
        
        // Clear approvals
        delete tokenApprovals[tokenId];
        
        // Update balances
        balances[from] -= 1;
        balances[to] += 1;
        owners[tokenId] = to;
        
        emit Transfer(from, to, tokenId);
    }
    
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "NFT: mint to the zero address");
        require(!_exists(tokenId), "NFT: token already minted");
        
        balances[to] += 1;
        owners[tokenId] = to;
        
        emit Transfer(address(0), to, tokenId);
    }
    
    function _safeMint(address to, uint256 tokenId) internal {
        _safeMint(to, tokenId, "");
    }
    
    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "NFT: mint to non ERC721Receiver implementer"
        );
    }
    
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
                return retval == _ERC721_RECEIVED;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("NFT: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
}