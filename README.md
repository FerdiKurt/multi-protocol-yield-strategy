# Yield Optimizer & Liquidation Protection Vault 🛡️

A sophisticated DeFi protocol that automatically optimizes yield farming across multiple lending protocols while providing intelligent liquidation protection for leveraged positions.

## 🎯 Overview

The Yield Optimizer Vault is a smart contract system that combines the best features of Compound, Aave, MakerDAO, and Frax protocols to create a unified, automated yield farming solution with built-in risk management.

### Core Value Propositions
- **Automated Yield Optimization**: Dynamically allocates funds to the highest-yielding protocols
- **Liquidation Protection**: Intelligent monitoring and automatic position management to prevent liquidations
- **Multi-Protocol Integration**: Leverages unique strengths of each DeFi protocol
- **Set-and-Forget**: Fully automated strategy execution with minimal user intervention

## 🏗️ How It Works

### 1. Multi-Protocol Yield Farming
```
User Deposits (DAI/USDC/FRAX) → Vault → Dynamic Allocation
                                   ↓
        Compound ←→ Aave ←→ Frax AMO ←→ MakerDAO PSM
```

The protocol continuously monitors yield rates across Compound and Aave, automatically moving funds to capture the best returns while utilizing Frax's AMO mechanisms and MakerDAO's PSM for additional opportunities.

### 2. Leveraged Position Management
- Users can open leveraged positions by minting DAI against collateral via MakerDAO
- Borrowed DAI is automatically deployed across Compound/Aave for yield farming
- Smart contracts monitor collateral ratios and health factors in real-time

### 3. Liquidation Protection Layer
When positions approach liquidation thresholds, the system automatically:
- Withdraws funds from lending protocols
- Partially repays MakerDAO debt to improve collateral ratios
- Uses Frax's algorithmic mechanisms for efficient rebalancing
- Executes flash loans for capital-efficient position management
