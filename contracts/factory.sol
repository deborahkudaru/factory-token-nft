// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "./token/Token.sol";

contract factory {
    address[] public tokens;
    uint256 public tokenCount;
    Token[] tokenInstance;
    // event TokenCreated(address tokenAddress, string name, string symbol, uint256 supply);

    event TokenDeployed(address tokenAddress);

    // function createToken(string memory _name, string memory _symbol, uint256 _supply) public {
    //     Token newToken = new Token(_name, _symbol, _supply);
    //     tokens.push(address(newToken));
    //     tokenCount++;
    //     emit TokenCreated(address(newToken), _name, _symbol, _supply);
    // }

    function deployToken(
        string calldata _name,
        string calldata _symbol,
        uint256 _supply
    ) public returns (address) {
        Token token = new Token(_name, _symbol, _supply);

        token.transfer(msg.sender, _supply);

        tokens.push(address(token));

        tokenCount++;

        //  emit TokenCreated(newToken, _name, _symbol, _supply);
        emit TokenDeployed(address(token));

        return address(token);
    }

}
