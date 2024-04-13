import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    evmSidechain: {
      url: "https://rpc-evm-sidechain.xrpl.org",
      accounts: ["39c0e11b51c7533b55aae23a65c2ac4e13cdf88ae8ec7bdd551d277aeb9a3cdc", "9e0b13242e0cc035752bd1ab232eb67db4191a5e1cefcb57678ab3ee4d209311"]
    }
  }
};

export default config;
