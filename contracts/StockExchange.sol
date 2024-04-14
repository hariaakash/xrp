// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract XRPEVMSidechain {
    struct Stock {
        string symbol;
        uint256 quantity;
        uint256 price;
    }

    mapping(string => Stock) public stocks;
    mapping(address => mapping(string => uint256)) public portfolio;

    constructor() {
        stocks["AAPL"] = Stock("AAPL", 1000, 0);
        stocks["GOOGL"] = Stock("GOOGL", 1000, 0);
        stocks["MSFT"] = Stock("MSFT", 1000, 0);
    }

    function buyStock(string memory stockSymbol, uint256 quantity, uint256 price) public {
        require(stocks[stockSymbol].quantity >= quantity, "Insufficient stock available");
        stocks[stockSymbol].quantity -= quantity;
        portfolio[msg.sender][stockSymbol] += quantity;
        // Handle payment logic here
    }

    function sellStock(string memory stockSymbol, uint256 quantity, uint256 price) public {
        require(portfolio[msg.sender][stockSymbol] >= quantity, "Insufficient stock in portfolio");
        stocks[stockSymbol].quantity += quantity;
        portfolio[msg.sender][stockSymbol] -= quantity;
        // Handle payment logic here
    }

    function getAllStocks() public view returns (Stock[] memory) {
        Stock[] memory allStocks = new Stock[](3);
        allStocks[0] = stocks["AAPL"];
        allStocks[1] = stocks["GOOGL"];
        allStocks[2] = stocks["MSFT"];
        return allStocks;
    }

    function getPortfolioStocks() public view returns (Stock[] memory) {
        uint256 portfolioSize = 0;
        for (uint256 i = 0; i < 3; i++) {
            string memory symbol = i == 0 ? "AAPL" : i == 1 ? "GOOGL" : "MSFT";
            if (portfolio[msg.sender][symbol] > 0) {
                portfolioSize++;
            }
        }

        Stock[] memory portfolioStocks = new Stock[](portfolioSize);
        uint256 index = 0;
        for (uint256 i = 0; i < 3; i++) {
            string memory symbol = i == 0 ? "AAPL" : i == 1 ? "GOOGL" : "MSFT";
            if (portfolio[msg.sender][symbol] > 0) {
                portfolioStocks[index] = Stock(symbol, portfolio[msg.sender][symbol], stocks[symbol].price);
                index++;
            }
        }
        return portfolioStocks;
    }
}