# Credence Score Protocol

> Next-generation decentralized credibility scoring and reputation management system for the Bitcoin ecosystem

[![Clarity](https://img.shields.io/badge/Clarity-Smart%20Contract-blue)](https://clarity-lang.org/)
[![Stacks](https://img.shields.io/badge/Stacks-Blockchain-orange)](https://stacks.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

Credence revolutionizes trust assessment through blockchain-native reputation tracking. This protocol empowers communities to build transparent, verifiable credibility networks where users earn reputation through measurable contributions. Features intelligent score degradation, flexible action weighting, and immutable accountability records.

**Perfect for:** DeFi governance, P2P marketplaces, content platforms, and any ecosystem requiring trustless reputation verification.

## Key Features

### 🔐 **Decentralized Identity Management**

- Create and manage blockchain-native identity profiles
- Decentralized Identifier (DID) integration
- Identity activation/deactivation controls

### 📊 **Dynamic Reputation Scoring**

- Configurable scoring system (0-1000 points)
- Multiple reputation action types with custom multipliers
- Real-time score updates with maximum cap enforcement

### ⏰ **Intelligent Score Degradation**

- Time-based reputation decay mechanism
- Configurable decay rates and periods
- Automatic decay application during score updates

### 📋 **Comprehensive Audit Trail**

- Immutable history of all reputation changes
- Block-height and timestamp tracking
- Full transparency and verifiability

### 🛡️ **Robust Security & Governance**

- Owner-only administrative functions
- Contract activation/deactivation controls
- Parameter validation and access controls

## Architecture

### Core Data Structures

```clarity
;; Identity Registry
(define-map identities
  { owner: principal }
  {
    did: (string-ascii 50),
    reputation-score: uint,
    created-at: uint,
    last-updated: uint,
    last-decay: uint,
    total-actions: uint,
    active: bool,
  }
)

;; Reputation Actions
(define-map reputation-actions
  { action-type: (string-ascii 50) }
  {
    multiplier: uint,
    description: (string-ascii 100),
    active: bool,
  }
)

;; Historical Records
(define-map reputation-history
  { owner: principal, tx-id: uint }
  {
    action-type: (string-ascii 50),
    previous-score: uint,
    new-score: uint,
    timestamp: uint,
    block-height: uint,
  }
)
```

### Configuration Parameters

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `MAX-REPUTATION-SCORE` | 1000 | Maximum achievable reputation score |
| `MIN-REPUTATION-SCORE` | 0 | Minimum reputation score floor |
| `DEFAULT-STARTING-REPUTATION` | 50 | Initial score for new identities |
| `DEFAULT-DECAY-RATE` | 10% | Percentage decay per period |
| `MINIMUM-DID-LENGTH` | 5 | Minimum DID string length |

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity development environment
- [Node.js](https://nodejs.org/) (v16 or later)
- [Git](https://git-scm.com/)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/opeyemi-precious/credence-score.git
   cd credence-score
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Initialize Clarinet project**

   ```bash
   clarinet check
   ```

### Development Setup

1. **Start local development environment**

   ```bash
   clarinet console
   ```

2. **Run tests**

   ```bash
   npm test
   # or
   clarinet test
   ```

3. **Format code**

   ```bash
   clarinet fmt
   ```

## Usage

### Basic Operations

#### 1. Create Identity

```clarity
;; Create a new decentralized identity
(contract-call? .credence-score create-identity "my-unique-did-12345")
```

#### 2. Update Reputation Score

```clarity
;; Award reputation for completing an action
(contract-call? .credence-score update-reputation-score "governance-vote")
```

#### 3. Query Reputation

```clarity
;; Get current reputation score
(contract-call? .credence-score get-reputation 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE)

;; Get full identity profile
(contract-call? .credence-score get-full-identity 'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE)
```

#### 4. Verify Reputation Threshold

```clarity
;; Check if user meets minimum reputation requirement
(contract-call? .credence-score verify-reputation 
  'ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE 
  u100)
```

### Administrative Functions

#### Configure Reputation Actions

```clarity
;; Add new reputation action type
(contract-call? .credence-score add-reputation-action 
  "bug-bounty" 
  u15 
  "Successfully submitted and verified bug bounty")

;; Update existing action
(contract-call? .credence-score update-reputation-action 
  "governance-vote" 
  u8 
  "Updated governance participation scoring" 
  true)
```

#### System Configuration

```clarity
;; Set decay parameters
(contract-call? .credence-score set-decay-parameters u15 u5000)

;; Update starting reputation
(contract-call? .credence-score set-starting-reputation u75)

;; Transfer ownership
(contract-call? .credence-score set-contract-owner 'ST2NEWOWNER...)
```

## Default Reputation Actions

The protocol ships with standard Bitcoin ecosystem actions:

| Action Type | Multiplier | Description |
|-------------|------------|-------------|
| `governance-vote` | 5 | Participation in governance voting |
| `contract-fulfillment` | 10 | Successful smart contract completion |
| `community-contribution` | 7 | Community project contributions |
| `validation` | 3 | Network transaction/data validation |
| `content-creation` | 6 | Valuable platform content creation |

## Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| 100 | `ERR-UNAUTHORIZED` | Unauthorized access attempt |
| 101 | `ERR-INVALID-PARAMETERS` | Invalid function parameters |
| 102 | `ERR-IDENTITY-EXISTS` | Identity already registered |
| 103 | `ERR-IDENTITY-NOT-FOUND` | Identity not found |
| 104 | `ERR-INSUFFICIENT-REPUTATION` | Below required reputation threshold |
| 105 | `ERR-MAX-REPUTATION-REACHED` | Maximum reputation already achieved |
| 106 | `ERR-ACTION-EXISTS` | Reputation action already exists |
| 107 | `ERR-ACTION-NOT-FOUND` | Reputation action not found |
| 108 | `ERR-NOT-ADMIN` | Admin privileges required |
| 109 | `ERR-NOT-ACTIVE` | Contract or identity not active |

## Testing

### Run Test Suite

```bash
# Run all tests
npm test

# Run specific test file
npm test -- credence-score.test.ts

# Run with coverage
npm run test:coverage
```

### Test Categories

- **Identity Management Tests**: Creation, updates, validation
- **Reputation Scoring Tests**: Score calculations, limits, decay
- **Administrative Tests**: Owner functions, parameter updates
- **Security Tests**: Access controls, error handling
- **Integration Tests**: End-to-end workflows

## Deployment

### Local Deployment

```bash
# Deploy to local devnet
clarinet deploy --devnet

# Deploy to testnet
clarinet deploy --testnet
```

### Production Deployment

```bash
# Deploy to mainnet (requires configuration)
clarinet deploy --mainnet
```

### Environment Configuration

Configure network settings in:

- `settings/Devnet.toml`
- `settings/Testnet.toml`
- `settings/Mainnet.toml`

## API Reference

### Public Functions

#### Identity Management

- `create-identity(did)` - Register new identity
- `update-identity-status(active)` - Enable/disable identity

#### Reputation Management

- `update-reputation-score(action-type)` - Award reputation points
- `decay-reputation()` - Manually trigger decay

#### Administrative

- `set-contract-owner(new-owner)` - Transfer ownership
- `set-contract-active(active)` - Enable/disable contract
- `set-decay-parameters(rate, period)` - Configure decay
- `add-reputation-action(type, multiplier, description)` - Add action type
- `update-reputation-action(type, multiplier, description, active)` - Update action

### Read-Only Functions

- `get-reputation(owner)` - Get reputation score
- `get-full-identity(owner)` - Get complete profile
- `verify-reputation(owner, threshold)` - Check threshold
- `get-reputation-action(action-type)` - Get action details
- `get-reputation-history(owner, tx-id)` - Get history record
- `get-contract-parameters()` - Get configuration

## Security Considerations

### Access Control

- All administrative functions require contract owner privileges
- Identity operations restricted to identity owners
- Parameter validation on all inputs

### Data Integrity

- Immutable audit trail for all changes
- Block-height timestamps prevent manipulation
- Score bounds enforcement (0-1000 range)

### Best Practices

- Regular decay application prevents score inflation
- Multi-signature governance recommended for production
- Monitor for unusual reputation patterns

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Write tests for new functionality
4. Ensure all tests pass (`npm test`)
5. Format code (`clarinet fmt`)
6. Commit changes (`git commit -m 'Add amazing feature'`)
7. Push to branch (`git push origin feature/amazing-feature`)
8. Open Pull Request

### Code Standards

- Follow Clarity best practices
- Maintain test coverage above 90%
- Include comprehensive documentation
- Use semantic commit messages

## Roadmap

### Phase 1: Core Protocol ✅

- [x] Identity management system
- [x] Reputation scoring mechanism
- [x] Decay functionality
- [x] Administrative controls

### Phase 2: Enhanced Features 🚧

- [ ] Multi-signature governance
- [ ] Cross-chain identity verification
- [ ] Weighted voting based on reputation
- [ ] Reputation staking mechanisms

### Phase 3: Ecosystem Integration 📋

- [ ] DeFi protocol integrations
- [ ] Marketplace implementations
- [ ] API gateway development
- [ ] Mobile SDK

### Phase 4: Advanced Analytics 📊

- [ ] Reputation analytics dashboard
- [ ] Predictive scoring models
- [ ] Community health metrics
- [ ] Reputation marketplace

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
