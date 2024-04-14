// Sources flattened with hardhat v2.22.2 https://hardhat.org

// SPDX-License-Identifier: MIT

// File contracts/StockExchange.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.24;

contract StockExchange {
    struct Stock {
        address owner;
        string id; // Stock symbol (e.g., "AAPL")
        uint256 price; // Price per stock
        uint256 quantity; // Number of stocks available
    }

    Stock[] public stocks;
    mapping(string => uint256) public stockIndex;
    mapping(address => mapping(string => uint256)) public userStocks;

    event NewStock(string indexed id, address owner, uint256 price, uint256 quantity);
    event StockSold(string indexed id, address buyer, uint256 quantity);

    constructor() {
        // Initialize with some example stocks (for demonstration purposes)
        createStock("AAPL", 150, 100);
        createStock("GOOGL", 2500, 50);
    }

    modifier stockExists(string memory _id) {
        require(stockIndex[_id] > 0, "Stock does not exist");
        _;
    }

    function createStock(string memory _id, uint256 _price, uint256 _quantity) public {
        require(_price > 0, "Invalid price");
        require(_quantity > 0, "Invalid quantity");
        require(stockIndex[_id] == 0, "Stock already exists");

        stocks.push(Stock(msg.sender, _id, _price, _quantity));
        stockIndex[_id] = stocks.length;

        emit NewStock(_id, msg.sender, _price, _quantity);
    }

    function buyStock(string memory _id, uint256 _quantity) public payable stockExists(_id) {
        require(_quantity > 0, "Invalid quantity");

        uint256 stockIdx = stockIndex[_id] - 1;
        Stock storage stock = stocks[stockIdx];

        require(msg.value == stock.price * _quantity, "Incorrect payment amount");
        require(stock.quantity >= _quantity, "Insufficient stock quantity");

        stock.quantity -= _quantity;
        userStocks[msg.sender][_id] += _quantity;
        payable(stock.owner).transfer(msg.value);

        emit StockSold(_id, msg.sender, _quantity);
    }

    function getStockDetails(string memory _id) public view stockExists(_id)
        returns (address owner, uint256 price, uint256 quantity)
    {
        uint256 stockIdx = stockIndex[_id] - 1;
        Stock storage stock = stocks[stockIdx];

        return (stock.owner, stock.price, stock.quantity);
    }

    function getUserPortfolioValue() public view returns (uint256) {
        uint256 totalValue;
        for (uint256 i = 0; i < stocks.length; i++) {
            Stock storage stock = stocks[i];
            totalValue += userStocks[msg.sender][stock.id] * stock.price;
        }
        return totalValue;
    }
}
