// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    struct GameItem {
        string name;
        uint256 price;
    }

    GameItem[] public gameItems;
    mapping(address => bool) public hasRedeemed;
    mapping(uint256 => bool) public isItemRedeemed;

    event GameItemRedeemed(address indexed account, string itemName, uint256 price);

    constructor() ERC20("DEGEN", "DGN") {
        gameItems.push(GameItem("Virtual Sword", 70));
        gameItems.push(GameItem("Avatar Outfit", 100));
        gameItems.push(GameItem("Power Boost", 150));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(_msgSender()) >= amount, "Insufficient balance");

        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function redeem(uint256 itemId) public {
        require(itemId >= 0 && itemId < gameItems.length, "Invalid item ID");
        require(!hasRedeemed[msg.sender], "Already redeemed");

        GameItem memory item = gameItems[itemId];
        uint256 price = item.price;

        require(balanceOf(_msgSender()) >= price, "Insufficient balance");

        _burn(_msgSender(), price);
        hasRedeemed[msg.sender] = true;

        emit GameItemRedeemed(msg.sender, item.name, price);

        updateGamingStoreState(itemId);
    }

    function burn(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(_msgSender()) >= amount, "Insufficient balance");

        _burn(_msgSender(), amount);
    }

    function balanceOf(address account) public view override returns (uint256) {
        return super.balanceOf(account);
    }

    function updateGamingStoreState(uint256 itemId) internal {
        require(itemId >= 0 && itemId < gameItems.length, "Invalid item ID");

        isItemRedeemed[itemId] = true;
    }
}
