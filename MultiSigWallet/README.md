# Multi-Signature Wallet

## Overview

The Multi-Signature Wallet is a smart contract built on the Ethereum blockchain that requires multiple approvals for transactions. This enhances security by ensuring that no single individual can unilaterally execute transactions, making it ideal for organizations and groups that require collective decision-making.

### Key Features

- **Multi-Signature Support**: Requires a predefined number of signatures from owners to execute transactions.
- **Transaction Management**: Create, confirm, revoke, and execute transactions.
- **Event Logging**: Emits events for important actions, providing transparency and traceability.
- **Fallback Function**: Allows the contract to receive Ether.

## Directory Structure

```
MultiSigWallet/
│
├── contracts/
│   └── MultiSigWallet.sol        # Smart contract code
│
├── migrations/
│   └── 2_deploy_contracts.js      # Deployment script
│
├── test/
│   └── MultiSigWallet.test.js     # Test cases for the contract
│
├── truffle-config.js              # Truffle configuration file
└── README.md                       # Project documentation
```

## Getting Started

### Prerequisites

- **Node.js**: Ensure you have Node.js installed. You can download it from [nodejs.org](https://nodejs.org/).
- **Truffle**: Install Truffle globally using npm:
  ```bash
  npm install -g truffle
  ```
- **Ganache**: Optionally, you can use Ganache for local blockchain development. Download it from [trufflesuite.com/ganache](https://www.trufflesuite.com/ganache).

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/KOSASIH/tokenization-on-pi.git
   cd tokenization-on-pi/MultiSigWallet
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

### Compile the Contract

Compile the smart contract to ensure there are no syntax errors:
```bash
truffle compile
```

### Deploy the Contract

Deploy the contract to a network (e.g., Rinkeby test network). Make sure to replace the placeholders in the migration script with actual Ethereum addresses and your Infura key.

```bash
truffle migrate --network rinkeby
```

### Run Tests

Run the test suite to ensure that all functionalities are working as expected:
```bash
truffle test
```

## Usage

### Interacting with the Contract

Once deployed, you can interact with the Multi-Signature Wallet contract using Truffle Console or a front-end application. Here are some basic commands:

1. **Create a Transaction**:
   ```javascript
   await wallet.createTransaction("0xRecipientAddress", web3.utils.toWei("1", "ether"), { from: "0xOwnerAddress" });
   ```

2. **Confirm a Transaction**:
   ```javascript
   await wallet.confirmTransaction(0, { from: "0xOwnerAddress" });
   ```

3. **Revoke a Confirmation**:
   ```javascript
   await wallet.revokeConfirmation(0, { from: "0xOwnerAddress" });
   ```

4. **Execute a Transaction**:
   ```javascript
   await wallet.executeTransaction(0, { from: "0xOwnerAddress" });
   ```

### Events

The contract emits the following events:

- `Deposit`: Triggered when Ether is deposited into the contract.
- `TransactionCreated`: Triggered when a new transaction is created.
- `TransactionConfirmed`: Triggered when a transaction is confirmed by an owner.
- `TransactionExecuted`: Triggered when a transaction is executed.
- `TransactionRevoked`: Triggered when a confirmation is revoked.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Ethereum](https://ethereum.org/) for the blockchain platform.
- [Truffle Suite](https://www.trufflesuite.com/) for the development framework.
- [OpenZeppelin](https://openzeppelin.com/) for security best practices in smart contract development.

## Contact

For any inquiries or contributions, please contact the project maintainer at [your-email@example.com].
