import {ethers} from "hardhat";

const main = async () => {
    const EasyATokenFactory = await ethers.getContractFactory("StockExchange");
    const easyAToken = await EasyATokenFactory.deploy();
    const easyATokenAddress = await easyAToken.getAddress();

    console.log("EasyAToken address: ", easyATokenAddress);
}

main();