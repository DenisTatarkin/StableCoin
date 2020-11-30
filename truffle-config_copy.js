var HDWalletProvider = require("@truffle/hdwallet-provider");
var mnemonic = "your mnemonic";
module.exports = {
  networks: {
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/project api");
      },
      network_id: 4
    }
  },
  mocha: {
  },
  compilers: {
    solc: {
    }
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: 'etherscan api'
  }
};
