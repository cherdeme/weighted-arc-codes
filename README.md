# Weighted Arc-Based Cyclic Codes

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Magma](https://img.shields.io/badge/Magma-V2.27-blue)](http://magma.maths.usyd.edu.au/magma/)
[![Research](https://img.shields.io/badge/Research-Post--Quantum%20Cryptography-purple)](https://en.wikipedia.org/wiki/Post-quantum_cryptography)
[![Verify Magma Code](https://github.com/cherdeme/weighted-arc-codes/actions/workflows/verify_magma.yml/badge.svg)](https://github.com/cherdeme/weighted-arc-codes/actions/workflows/verify_magma.yml)

Magma implementation of weighted arc-based cyclic codes for post-quantum cryptography.

## Table des matières
- [Overview](#overview)
- [Requirements](#requirements)
- [Files Structure](#files-structure)
- [Quick Start](#quick-start)
- [Examples](#examples)
- [Results](#results)
- [Citation](#citation)
- [License](#license)
## Overview

This repository contains Magma code for constructing and testing weighted arc-based cyclic codes, as described in the paper "Weighted Arc-Based Cyclic Codes: A Geometric Construction for Post-Quantum Cryptography".

The codes are constructed by evaluating homogeneous polynomials on points of a conic in $\mathbb{P}^2(\mathbb{F}_q)$, with random weights assigned to each point.

## Requirements

- Magma V2.27 or later (http://magma.maths.usyd.edu.au/magma/)
- Basic familiarity with finite geometry and coding theory

## Files Structure

- `magma/` - Main Magma source code
  - `verify_conic.m` - Construct conics and verify their properties
  - `mds_test.m` - Test MDS property for random weights
  - `weight_distribution.m` - Compute weight distribution of codes
  - `cyclic_automorphism.m` - Construct cyclic automorphisms on conics
  - `examples/` - Example scripts for specific parameters
  - `utils/` - Utility functions

- `paper/` - LaTeX source for the accompanying paper
- `results/` - Experimental results and logs

## Quick Start

```magma
// Load the main functions
load "magma/utils/conic_utils.m";
load "magma/mds_test.m";

// Test for q=11, d=3
q := 11;
d := 3;
n_trials := 100;
TestMDSProperty(q, d, n_trials);
