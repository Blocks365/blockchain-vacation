const HDWalletProvider = require("truffle-hdwallet-provider");
const rpc_endpoint = "https://blocks365test.blockchain.azure.com:3200/...";
const mnemonic = "all tray blame tattoo final pizza canvas strike toe enjoy behind ...";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 5000000
    },
    blocks365test: {
      provider: new HDWalletProvider(mnemonic, rpc_endpoint),
      network_id: "*",
      gasPrice: 0,
      gas: 4700000
    }
  },
  compilers: {
    solc: {
      settings: {
        optimizer: {
          enabled: true, // Default: false
          runs: 200      // Default: 200
        },
      }
    }
  }
};
