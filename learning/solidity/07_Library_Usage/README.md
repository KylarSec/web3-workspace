# Library Usage Examples

This folder demonstrates how Solidity libraries can be used in smart contracts.

## Purpose
- Understand how libraries work in Solidity
- Compare direct library calls vs `using X for Y` syntax

## Files

### MathLibrary.sol
A simple library that provides a reusable `sum` function for adding two `uint256` values.

### CalculateSum.sol
Uses the library by calling it directly:
`MathLibrary.sum(a, b)`

### CalculateSum1.sol
Uses the library with Solidity’s `using X for Y` syntax:
`a.sum(b)`

## Notes
- Both approaches produce the same result and gas usage
- `using X for Y` is only syntax sugar
- Direct calls are often clearer and preferred for readability


### Important Concept

using X for Y does NOT change logic or gas usage.
It only changes how the function call looks.