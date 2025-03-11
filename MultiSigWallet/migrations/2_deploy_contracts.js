 const MultiSigWallet = artifacts.require("MultiSigWallet");

module.exports = function (deployer) {
    const owners = ["0xYourAddress1", "0xYourAddress2", "0xYourAddress3"]; // Replace with actual owner addresses
    const requiredSignatures = 2; // Set the number of required signatures
    deployer.deploy(MultiSigWallet, owners, requiredSignatures);
};
