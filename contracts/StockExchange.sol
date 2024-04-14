// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract XRPEVMSidechain {
    struct Stock {
        string symbol;
        uint256 quantity;
    }

    struct Portfolio {
        string symbol;
        uint256 quantity;
        uint256 price;
        uint256 purchaseTime;
        uint256 hedgePercent;
    }

    mapping(string => Stock) public stocks;
    mapping(address => Portfolio[]) public userPortfolios;

    constructor() {
        stocks["AAPL"] = Stock("AAPL", 1000);
        stocks["GOOGL"] = Stock("GOOGL", 1000);
        stocks["MSFT"] = Stock("MSFT", 1000);
    }

    function buyStock(string memory stockSymbol, uint256 quantity, uint256 price, uint256 hedgePercent) public {
        require(stocks[stockSymbol].quantity >= quantity, "Insufficient stock available");
        stocks[stockSymbol].quantity -= quantity;
        userPortfolios[msg.sender].push(Portfolio(stockSymbol, quantity, price, block.timestamp, hedgePercent));
    }

    function sellStock(uint256 portfolioIndex, uint256 quantity, uint256 price) public {
        Portfolio storage userPortfolio = userPortfolios[msg.sender][portfolioIndex];
        require(userPortfolio.quantity >= quantity, "Insufficient stock in portfolio");
        stocks[userPortfolio.symbol].quantity += quantity;
        userPortfolio.quantity -= quantity;
    }

    function getAllStocks() public view returns (Stock[] memory) {
        Stock[] memory allStocks = new Stock[](3);
        allStocks[0] = stocks["AAPL"];
        allStocks[1] = stocks["GOOGL"];
        allStocks[2] = stocks["MSFT"];
        return allStocks;
    }

    function getPortfolioStocks() public view returns (Portfolio[] memory) {
        return userPortfolios[msg.sender];
    }
}