# Tokenized Healthcare Clinical Trial Management

A blockchain-based system for managing clinical trials using Clarity smart contracts on the Stacks blockchain.

## Overview

This project implements a set of smart contracts that work together to provide a secure, transparent, and immutable platform for managing healthcare clinical trials. The system tokenizes various aspects of the clinical trial process, from institution verification to adverse event tracking, ensuring data integrity and regulatory compliance.

## Smart Contracts

The system consists of five core smart contracts:

### 1. Research Institution Verification

Validates and maintains the status of research entities participating in clinical trials.

**Key Functions:**
```clarity
;; Verify an institution (admin only)
(verify-institution institution name)

;; Revoke verification (admin only)
(revoke-verification institution)

;; Check if an institution is verified
(is-verified institution)

;; Get institution details
(get-institution-details institution)
