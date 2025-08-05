# CreatorFi

A decentralized creator economy infrastructure that empowers artists, writers, musicians, and influencers to tokenize content, monetize communities, and control their financial destiny — all on-chain.

---

## Overview

CreatorFi is a modular Web3 platform built on Clarity, comprising ten core smart contracts that form a transparent, fair, and programmable ecosystem for creators and their supporters:

1. **Creator Profile Contract** – Stores creator metadata and links their assets and tokens.
2. **Subscription Pass Contract** – Issues NFT-based memberships with access controls.
3. **Content NFT Contract** – Tokenizes digital content with royalties and licensing.
4. **Royalty Splitter Contract** – Distributes revenue among collaborators automatically.
5. **Creator DAO Contract** – Enables fans and collaborators to co-govern creator decisions.
6. **Creator Token Contract** – ERC-20-like token for perks, governance, and rev-share.
7. **Licensing Contract** – Facilitates transparent, enforceable content licensing.
8. **Funding Launchpad Contract** – Manages community crowdfunding and milestone funding.
9. **Access Gating Contract** – Controls access to exclusive content based on NFTs or tokens.
10. **Collaboration Contract** – Supports co-creation, revenue sharing, and joint IP management.

---

## Features

- **Tokenized content** with built-in royalty logic  
- **NFT-based subscriptions** with tiered fan access  
- **Automated royalty splits** between collaborators  
- **Decentralized governance** via Creator DAOs  
- **Creator tokens** with optional bonding curves  
- **On-chain licensing** for content usage rights  
- **Community funding** with milestone-based releases  
- **Access control** for exclusive content and perks  
- **Collaborative creation** with transparent revenue sharing  
- **Modular contract architecture** for upgradeability  

---

## Smart Contracts

### Creator Profile Contract
- Registers and manages creator identities
- Links wallet, social handles, token addresses
- Upgradable with DAO governance

### Subscription Pass Contract
- Mints tiered subscription NFTs
- Validates access to premium content
- Supports expiration and renewal

### Content NFT Contract
- Mints ERC-721 or ERC-1155 NFTs for content
- Built-in royalty mechanics (EIP-2981-like)
- Metadata stored on IPFS or Arweave

### Royalty Splitter Contract
- Distributes income from sales and licenses
- Configurable percentage splits
- Compatible with content NFTs or subscriptions

### Creator DAO Contract
- Fan/community-driven governance
- On-chain proposal creation and voting
- Uses staked creator tokens for voting power

### Creator Token Contract
- Fungible ERC-20-like token
- Optional bonding curve mechanics
- Enables perks, governance, and revenue sharing

### Licensing Contract
- On-chain license terms per NFT
- Supports commercial, remix, and exclusive rights
- Automates expiration and revocation

### Funding Launchpad Contract
- Crowdfunding for projects or content drops
- Escrow and milestone-based releases
- NFT rewards or rev-share tokens for backers

### Access Gating Contract
- Grants or restricts content access
- Validates NFT or token ownership
- Integrates with IPFS/Arweave gateways

### Collaboration Contract
- Supports joint creation and co-ownership
- Auto-splits revenue among parties
- Optional DAO-style voting on decisions

---

## Installation

1. Install [Clarinet CLI](https://docs.hiro.so/clarinet/getting-started)
2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/creatorfi.git
   ```
3. Run tests:
    ```bash
    npm test
    ```
4. Deploy contracts:
    ```bash
    clarinet deploy
    ```

---

## Usage

Each smart contract is designed to work independently and collectively.
Creators can deploy only the modules they need, allowing for flexible and composable creator economies.

Refer to each contract’s documentation for:

- Function calls and parameters
- Example usage scenarios
- Deployment configuration

---

## License

MIT License