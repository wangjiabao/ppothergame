// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract BuyBurn is ReentrancyGuard {
    address public immutable usdt;

    address[] public users;
    uint256[] public usersAmount;

    constructor(address token) {
        require(token.code.length > 0, "token has no code");
        usdt = token;
    }

    function buy(uint256 num) external nonReentrant {
        uint256 amount = num * 10**15;

        require(IERC20(usdt).transferFrom(
            msg.sender,
            0xa1E54373034aaE3C00Df1b9b89B20d2df55e2CAD,
            amount / 10000 * 9500
        ), "transfer failed");

        require(IERC20(usdt).transferFrom(
            msg.sender,
            0x202Afd67c4016d2efD456b412a10991B561935AD,
            amount / 10000 * 75
        ), "transfer failed");

        require(IERC20(usdt).transferFrom(
            msg.sender,
            0x279F2B0B788b50c90ceCd74C9134D152083A87B7,
            amount / 10000 * 100
        ), "transfer failed");

        require(IERC20(usdt).transferFrom(
            msg.sender,
            0x68d1536f75436Fc9cAA4a9582447b9e1b325fd36,
            amount / 10000 * 225
        ), "transfer failed");

        require(IERC20(usdt).transferFrom(
            msg.sender,
            0x774A649d5Cf7DAb055300DF12F8bE52E8EcD0b24,
            amount / 10000 * 100
        ), "transfer failed");

        users.push(msg.sender);
        usersAmount.push(num);
    }

    function getUserLength() public view returns (uint256) {
        return users.length;
    }

    function getUsers() public view returns (address[] memory) {
        return users;
    }

    function getUsersByIndex(uint256 startIndex, uint256 endIndex) public view returns (address[] memory) {
        require(endIndex >= startIndex, "bad range");
        require(endIndex < users.length, "out of range");

        address[] memory data = new address[](endIndex + 1 - startIndex);
        for (uint256 i = startIndex; i <= endIndex; i++) {
            data[i - startIndex] = users[i];
        }
        return data;
    }

    function getUsersAmountByIndex(uint256 startIndex, uint256 endIndex) public view returns (uint256[] memory) {
        require(endIndex >= startIndex, "bad range");
        require(endIndex < usersAmount.length, "out of range");

        uint256[] memory data = new uint256[](endIndex + 1 - startIndex);
        for (uint256 i = startIndex; i <= endIndex; i++) {
            data[i - startIndex] = usersAmount[i];
        }
        return data;
    }
}
