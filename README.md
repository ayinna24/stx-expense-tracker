# STX Expense Tracker

A Stacks blockchain smart contract for tracking and managing expenses with STX token.

## Overview

This smart contract provides functionality to:
- Record expenses with STX transfers
- Track expense details including amount, spender, and notes
- Allow administrator withdrawals for expense reimbursement
- Query expense history and totals

## Contract Functions

### Public Functions

```clarity
(record-expense (amount uint) (note (string-ascii 50)))
```
Records a new expense by transferring STX to the contract.

```clarity
(withdraw (amount uint) (recipient principal))
```
Allows admin to withdraw STX for reimbursements.

### Read-Only Functions

```clarity
(get-expense (id uint))
```
Retrieves details for a specific expense by ID.

```clarity
(get-total-expenses)
```
Returns total STX spent across all expenses.

```clarity
(get-count)
```
Returns total number of recorded expenses.

## Development

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet)
- Node.js

### Testing
```bash
clarinet test
```

### Deployment
```bash
clarinet deploy
```
