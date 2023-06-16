import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.9"
      },
      {
        version: "0.6.6"
      }
    ]
  },

  networks: {
    hardhat: {
      forking: {
        url: 'https://api.baobab.klaytn.net:8651	',
      },
      accounts: {
        mnemonic:  "test test test test test test test test test test test junk",
        accountsBalance: "100000000000000000000000" // 1,000,000 ETH
      }
    },
    baobab : {
      url : "https://api.baobab.klaytn.net:8651",
      chainId : 1001,
      accounts: require("./privatekey.json").privatekey,
      gas : 20000000,
      gasPrice : 25000000000
    }
  }
};

export default config;
