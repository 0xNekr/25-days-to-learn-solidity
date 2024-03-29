import * as dotenv from "dotenv";
import {HardhatUserConfig} from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.23",
  networks: {
    polygonMumbai: {
      url: process.env.MUMBAI_URL!,
      accounts: [process.env.WALLET_PRIVATE_KEY!],
    }
  },
  etherscan: {
    apiKey: {
      polygonMumbai: process.env.MUMBAI_PRIVATE_KEY!,
    },
  },paths: {
    artifacts: "./artifacts"
  }
};

export default config;
