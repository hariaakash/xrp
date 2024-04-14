import { ethers } from "hardhat";
import { StockExchange } from "../typechain-types";

const main = async () => {
    const StockExchangeFactory = await ethers.getContractFactory("StockExchange");
    const se = StockExchangeFactory.attach("0xE275B8850207a2351cA6Da683430A9F536315AAe") as StockExchange;

    const stockSymbol = "AAPL";
    const transaction = await se.buyStock(stockSymbol, 2);
    console.log(transaction);
}

main();