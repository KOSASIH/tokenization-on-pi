// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    // State variables
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public requiredSignatures;

    struct Transaction {
        address to;
        uint value;
        bool executed;
        uint confirmations;
        mapping(address => bool) isConfirmed;
    }

    Transaction[] public transactions;

    // Events
    event Deposit(address indexed sender, uint amount);
    event TransactionCreated(uint indexed txIndex, address indexed to, uint value);
    event TransactionConfirmed(uint indexed txIndex, address indexed owner);
    event TransactionExecuted(uint indexed txIndex);
    event TransactionRevoked(uint indexed txIndex, address indexed owner);

    // Modifiers
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier txExists(uint txIndex) {
        require(txIndex < transactions.length, "Transaction does not exist");
        _;
    }

    modifier notExecuted(uint txIndex) {
        require(!transactions[txIndex].executed, "Transaction already executed");
        _;
    }

    modifier notConfirmed(uint txIndex) {
        require(!transactions[txIndex].isConfirmed[msg.sender], "Transaction already confirmed");
        _;
    }

    // Constructor
    constructor(address[] memory _owners, uint _requiredSignatures) {
        require(_owners.length > 0, "Owners required");
        require(_requiredSignatures > 0 && _requiredSignatures <= _owners.length, "Invalid number of required signatures");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }
        requiredSignatures = _requiredSignatures;
    }

    // Fallback function to receive Ether
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Create a transaction
    function createTransaction(address to, uint value) public onlyOwner {
        uint txIndex = transactions.length;
        transactions.push();
        Transaction storage newTransaction = transactions[txIndex];
        newTransaction.to = to;
        newTransaction.value = value;
        newTransaction.executed = false;
        newTransaction.confirmations = 0;

        emit TransactionCreated(txIndex, to, value);
    }

    // Confirm a transaction
    function confirmTransaction(uint txIndex) public onlyOwner txExists(txIndex) notExecuted(txIndex) notConfirmed(txIndex) {
        Transaction storage transaction = transactions[txIndex];
        transaction.isConfirmed[msg.sender] = true;
        transaction.confirmations += 1;

        emit TransactionConfirmed(txIndex, msg.sender);
    }

    // Revoke a transaction confirmation
    function revokeConfirmation(uint txIndex) public onlyOwner txExists(txIndex) notExecuted(txIndex) {
        Transaction storage transaction = transactions[txIndex];
        require(transaction.isConfirmed[msg.sender], "Transaction not confirmed");

        transaction.isConfirmed[msg.sender] = false;
        transaction.confirmations -= 1;

        emit TransactionRevoked(txIndex, msg.sender);
    }

    // Execute a transaction
    function executeTransaction(uint txIndex) public onlyOwner txExists(txIndex) notExecuted(txIndex) {
        Transaction storage transaction = transactions[txIndex];
        require(transaction.confirmations >= requiredSignatures, "Not enough confirmations");

        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}("");
        require(success, "Transaction failed");

        emit TransactionExecuted(txIndex);
    }

    // Get transaction details
    function getTransaction(uint txIndex) public view returns (address to, uint value, bool executed, uint confirmations) {
        Transaction storage transaction = transactions[txIndex];
        return (transaction.to, transaction.value, transaction.executed, transaction.confirmations);
    }

    // Get the number of transactions
    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }
}
