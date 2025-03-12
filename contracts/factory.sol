// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "./token/Token.sol";
import "./token/NFT.sol";

contract factory {
    // erc20
    address[] public tokens;
    uint256 public tokenCount;
    Token[] tokenInstance;

    // nft
    NFT[] nftInstance;
    uint256 public nftCount;
    NFT[] public nfts;

    event TokenDeployed(address tokenAddress);

    event NFTDeployed(address nftAddress);

    function deployToken(
        string calldata _name,
        string calldata _symbol,
        uint256 _supply
    ) public returns (address) {
        Token token = new Token(_name, _symbol, _supply);

        token.transfer(msg.sender, _supply);

        tokens.push(address(token));

        tokenCount++;

        emit TokenDeployed(address(token));

        return address(token);
    }

    function deployNFT(
        string calldata _name,
        string calldata _symbol
    ) public returns (address) {
        NFT nft = new NFT(_name, _symbol);

        nfts.push(nft);

        nftCount++;

        emit NFTDeployed(address(nft));

        return address(nft);
    }
}
