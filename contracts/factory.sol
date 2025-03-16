// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "./token/Token.sol";
import "./token/MyNFT.sol";

contract Factory {
    struct TokenInfo {
        address tokenAddress;
        string name;
        string symbol;
    }

    struct NFTInfo {
        address nftAddress;
        string name;
        string symbol;
    }

    TokenInfo[] public tokens;
    NFTInfo[] public nfts;

    event TokenDeployed(address indexed tokenAddress, string name, string symbol);
    event NFTDeployed(address indexed nftAddress, string name, string symbol);

    function deployToken(
        string calldata _name,
        string calldata _symbol,
        uint256 _supply
    ) public returns (address) {
        Token token = new Token(_name, _symbol, _supply);
        address tokenAddress = address(token);

        tokens.push(TokenInfo(tokenAddress, _name, _symbol));

        emit TokenDeployed(tokenAddress, _name, _symbol);
        return tokenAddress;
    }

    function deployNFT(
        string calldata _name,
        string calldata _symbol
    ) public returns (address) {
        MyNFT nft = new MyNFT(_name, _symbol);
        address nftAddress = address(nft);

        nfts.push(NFTInfo(nftAddress, _name, _symbol));

        emit NFTDeployed(nftAddress, _name, _symbol);
        return nftAddress;
    }

    function getTokens() public view returns (TokenInfo[] memory) {
        return tokens;
    }

    function getNFTs() public view returns (NFTInfo[] memory) {
        return nfts;
    }
}
