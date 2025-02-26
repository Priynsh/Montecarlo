# Monte Carlo Stock Price Simulation

This project simulates stock price movements using the Monte Carlo method based on Geometric Brownian Motion (GBM). The visualization is interactive, allowing users to adjust drift (μ) and volatility (σ) to see their effects on stock prices.

## Features

- **Monte Carlo simulation** of stock prices
- **Interactive sliders** to adjust drift and volatility
- **Visualization with GLMakie**, including:
  - Multiple stock paths
  - Expected stock price path
  - Histogram of final prices

## Installation

Ensure you have Julia installed. Then, install the required dependencies:

```julia
using Pkg
Pkg.add(["GLMakie", "StatsBase", "GLFW"])
include("montecarlo.jl")
