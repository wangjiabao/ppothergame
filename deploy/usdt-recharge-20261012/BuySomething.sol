// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract BuySomething is ReentrancyGuard {
    using SafeERC20 for IERC20;

    address public usdt = 0x55d398326f99059fF775485246999027B3197955; // BSC USDT, 18 decimals

    address[] public users;
    uint256[] public usersAmount;

    constructor() {}

    function buy(uint256 num) external nonReentrant {
        require(5 <= num, "err num");

        uint256 amount = num * 10**18;

        IERC20(usdt).safeTransferFrom(msg.sender, 0xDf4cbC6c9c4F084B6E75177852C6a29f206b8Fe1, amount * 995 / 1000);
        IERC20(usdt).safeTransferFrom(msg.sender, 0xc7C41EdfD5De9A4e1c48993E41787F3e605d0010, amount * 5 / 1000);

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
