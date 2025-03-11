const MultiSigWallet = artifacts.require("MultiSigWallet");

contract("MultiSigWallet", (accounts) => {
    let wallet;
    const owners = [accounts[0], accounts[1], accounts[2]];
    const requiredSignatures = 2;

    beforeEach(async () => {
        wallet = await MultiSigWallet.new(owners, requiredSignatures);
    });

    it("should allow owners to create a transaction", async () => {
        await wallet.createTransaction(accounts[3], web3.utils.toWei("1", "ether"), { from: owners[0] });
        const transaction = await wallet.getTransaction(0);
        assert.equal(transaction.to, accounts[3]);
        assert.equal(transaction.value.toString(), web3.utils.toWei("1", "ether"));
    });

    it("should allow owners to confirm a transaction", async () => {
        await wallet.createTransaction(accounts[3], web3.utils.toWei("1", "ether"), { from: owners[0] });
        await wallet.confirmTransaction(0, { from: owners[1] });
        const transaction = await wallet.getTransaction(0);
        assert.equal(transaction.confirmations.toString(), "1");
    });

    it("should execute a transaction with enough confirmations", async () => {
        await wallet.createTransaction(accounts[3], web3.utils.toWei("1", "ether"), { from: owners[0] });
        await wallet.confirmTransaction(0, { from: owners[1] });
        await wallet.confirmTransaction(0, { from: owners[2] });
        const initialBalance = await web3.eth.getBalance(accounts[3]);
        await wallet.executeTransaction(0, { from: owners[0] });
        const finalBalance = await web3.eth.getBalance(accounts[3]);
        assert.equal(finalBalance - initialBalance, web3.utils.toWei("1", "ether"));
    });
});
