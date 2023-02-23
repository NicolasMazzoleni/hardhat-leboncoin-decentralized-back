// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error Marketplace__PriceMustBeGreaterThanZero();
error Marketplace__ItemAlreadyListed();

contract Marketplace is ReentrancyGuard, Ownable  {
    uint private latestItemId;

    // Creating a custom type about listing items in the marketplace
    struct Listing {
        uint256 price;
        address seller;
        bytes32 title;
        bytes32 category;
        bytes32 condition;
        bytes32 description;
        bytes32 localisation;
    }

    event ItemListed(
        uint256 id,
        address indexed caller,
        bytes32 indexed title,
        bytes32 indexed category,
        bytes32 condition,
        bytes32 description,
        bytes32 localisation,
        uint256 price
    );

    event ItemBought(
        uint256 id,
        address indexed caller,
        bytes32 indexed title,
        bytes32 indexed category,
        bytes32 condition,
        bytes32 description,
        bytes32 localisation,
        uint256 price
    );

    event ItemCancelled(
        uint256 id,
        address indexed caller,
        bytes32 indexed title,
        bytes32 indexed category,
        bytes32 condition,
        bytes32 description,
        bytes32 localisation
    );

    // Global variables
    // uint256 : Unique indentifier generated when listing new item
    mapping(uint256 => Listing) private s_listing;

    // Main functions
    function registerItem(
        bytes32 title,
        bytes32 category,
        bytes32 condition,
        bytes32 description,
        bytes32 localisation,
        uint256 price) external onlyOwner {

        address contractCallerAddress = msg.sender;

        if (price <= 0) {
            revert Marketplace__PriceMustBeGreaterThanZero();
        }

        uint256 itemId = getItemId();
        Listing memory listing = s_listing[itemId];
        if (listing.price > 0) {
            revert Marketplace__ItemAlreadyListed();
        }

        s_listing[itemId] = Listing(price, contractCallerAddress, title, category, condition, description, localisation);
        emit ItemListed(itemId, contractCallerAddress, title, category, condition, description, localisation, price);
    }

    // Getter functions
    function getItemId() internal returns (uint) {
        return latestItemId++;
    }

    function getListing(uint256 id) external view returns (Listing memory) {
        return s_listing[id];
    }
}