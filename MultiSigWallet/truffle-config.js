const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');
const infuraKey = "YOUR_INFURA_KEY"; // Replace with your Infura key
const mnemonic = "YOUR_MNEMONIC"; // Replace with your wallet mnemonic

const provider = new HDWalletProvider(
    mnemonic,
    `https://rinkeby.infura.io/v3/${infuraKey}`
);

const web3 = new Web3(provider);

module.exports = {
    networks: {
        rinkeby: {
            provider: () => provider,
            network_id: 4, // Rinkeby's id
            gas: 5500000, // Rinkeby has a lower block limit than mainnet
        },
    },
    compilers: {
        solc: {
            version: "0.8.0", // Specify the Solidity version
        },
    },
};
