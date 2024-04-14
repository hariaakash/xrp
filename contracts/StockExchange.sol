// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/Strings.sol";

contract StockExchange {
    using Strings for uint256;

    struct Stock {
        address owner;
        string id; // Stock symbol (e.g., "AAPL")
        uint256 price; // Price per stock
        uint256 quantity; // Number of stocks available
        uint256 maxPurchaseQuantity; // Maximum quantity that can be purchased at once
    }

    Stock[] public stocks;
    mapping(string => uint256) public stockIndex;
    mapping(address => mapping(string => uint256)) public userStocks;

    event NewStock(
        string indexed id,
        address owner,
        uint256 price,
        uint256 quantity,
        uint256 maxPurchaseQuantity
    );
    event StockSold(
        string indexed id,
        address buyer,
        uint256 quantity,
        uint256 totalPrice
    );

    constructor() {
        // Initialize with some example stocks (for demonstration purposes)
        _createStock("AAPL", 150, 100, 20);
        _createStock("GOOGL", 2500, 50, 10);
    }

    modifier stockExists(string memory _id) {
        require(stockIndex[_id] > 0, "Stock does not exist");
        _;
    }

    function _createStock(
        string memory _id,
        uint256 _price,
        uint256 _quantity,
        uint256 _maxPurchaseQuantity
    ) internal {
        require(_price > 0, "Invalid price");
        require(_quantity > 0, "Invalid quantity");
        require(_maxPurchaseQuantity > 0, "Invalid max purchase quantity");
        require(stockIndex[_id] == 0, "Stock already exists");
        require(bytes(_id).length > 0, "Invalid stock ID");

        stocks.push(
            Stock(
                msg.sender,
                _id,
                _price,
                _quantity,
                _maxPurchaseQuantity
            )
        );
        stockIndex[_id] = stocks.length;

        emit NewStock(_id, msg.sender, _price, _quantity, _maxPurchaseQuantity);
    }

    function createStock(
        string calldata _id,
        uint256 _price,
        uint256 _quantity,
        uint256 _maxPurchaseQuantity
    ) external {
        _createStock(_id, _price, _quantity, _maxPurchaseQuantity);
    }

    function buyStock(string memory _id, uint256 _quantity)
        public
        payable
        stockExists(_id)
    {
        require(_quantity > 0, "Invalid quantity");
        uint256 stockIdx = stockIndex[_id] - 1;
        Stock storage stock = stocks[stockIdx];

        require(
            _quantity <= stock.maxPurchaseQuantity,
            "Purchase quantity exceeds maximum limit"
        );
        require(msg.value == stock.price * _quantity, "Incorrect payment amount");
        require(stock.quantity >= _quantity, "Insufficient stock quantity");

        stock.quantity -= _quantity;
        userStocks[msg.sender][_id] += _quantity;

        (bool success, ) = stock.owner.call{value: msg.value}("");
        require(success, "Transfer failed");

        emit StockSold(_id, msg.sender, _quantity, msg.value);
    }

    function getStockDetails(string memory _id)
        public
        view
        stockExists(_id)
        returns (uint256 price, uint256 quantity, uint256 maxPurchaseQuantity)
    {
        uint256 stockIdx = stockIndex[_id] - 1;
        Stock storage stock = stocks[stockIdx];
        return (stock.price, stock.quantity, stock.maxPurchaseQuantity);
    }

    function getUserPortfolioValue() external view returns (uint256) {
        uint256 totalValue;
        for (uint256 i = 0; i < stocks.length; i++) {
            Stock storage stock = stocks[i];
            totalValue += userStocks[msg.sender][stock.id] * stock.price;
        }
        return totalValue;
    }
}