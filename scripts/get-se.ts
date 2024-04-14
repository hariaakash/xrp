import { ethers } from "hardhat";
import { StockExchange } from "../typechain-types";

const main = async () => {
    const StockExchangeFactory = await ethers.getContractFactory("StockExchange");
    const se = StockExchangeFactory.attach("0xE275B8850207a2351cA6Da683430A9F536315AAe") as StockExchange;

    const stockSymbol = "AAPL";
    const transaction = await se.getStockDetails(stockSymbol);
    // const transaction = await se.getUserPortfolioValue();
    // Destructure the returned values from the transaction.value array
    const res = transaction;
    console.log(res);

    // console.log("Price:", price.toString());
    // console.log("Quantity:", quantity.toString());
    // console.log("Max Purchase Quantity:", maxPurchaseQuantity.toString());
}

main();