# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Chemistris is a chemistry-themed puzzle game built with GameMaker Studio 2. The repository contains the compiled Windows build and game data files.

## Repository Structure

- `chemistris-gms/`: Contains the built Windows executable and game data
  - `chemistris.exe` and `data.win`: GameMaker runtime artifacts
  - `LEVEL...csv`, `PRODUCT...csv`, `REACTANT...csv`: Game data with hashed filenames
  - Font files and other shared assets
- `AGENTS.md`: Repository guidelines for code agents

## Development Commands

### Building and Running

This project is authored in GameMaker Studio 2:

1. Open the project file (`.yyp`) in GameMaker Studio 2 IDE
2. Make changes in the IDE
3. Export Windows package via GameMaker's export menu
4. Replace `chemistris.exe` and `data.win` in `chemistris-gms/`

### Testing Locally

- **Windows**: Run `chemistris-gms/chemistris.exe` directly
- **macOS/Linux**: Use Wine: `wine chemistris-gms/chemistris.exe`

**Important**: Always rebuild and export after modifying CSV data files to bundle updated resources.

## Data File Architecture

The game uses CSV files with hashed filenames for game data:

### LEVEL CSV Format
- Defines level layouts and chemistry challenges
- Fields: `L0_LEVEL`, `L1_CODE`, `L2_COUNT`, `L3_CHAP`, `L4_ORDER`, `L5_BAN`, `L6_ON`
- Uses Chinese poetry phrases as level codes (e.g., "飞流直下三千尺")

### REACTANT CSV Format
- Maps reaction codes to input molecules
- Fields: `RT_CODE`, `RT_MOLECULE`, `RT_QUANTITY`
- Links to level codes via Chinese phrases

### PRODUCT CSV Format
- Maps reaction codes to output molecules
- Same structure as REACTANT CSV
- Defines chemical products for reactions

**Key Design Pattern**: Chinese poetry phrases serve as unique identifiers linking levels to their chemical reactions across CSV files.

## Code Style

Follow GameMaker Language conventions:
- Four-space indentation
- `camelCase` for variables
- `PascalCase` (or `Obj`/`Scr` prefixes) for resources
- `scrFunctionName` for reusable scripts
- CSV headers: lowercase with underscores for multi-word fields

Run GameMaker's "Code Cleanup" before exporting to normalize whitespace and remove dead assets.

## Testing

No automated test harness exists. Testing is scenario-based:
- Validate CSV imports by running the build
- Test new combinations in Practice mode
- Capture videos/GIFs of gameplay interactions
- Check GameMaker debug overlay for console output
- Document regressions in PR descriptions
