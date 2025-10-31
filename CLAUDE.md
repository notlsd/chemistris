# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Chemistris is a chemistry-themed puzzle game built with GameMaker Studio 2 (IDE version 2022.0.2.51). The game features falling molecules that react according to chemical equations defined in CSV data files, using Chinese poetry phrases as unique identifiers.

## Development Principles

**Core Guidelines for All Development Work:**

1. **If you have any questions, please ask me first - do NOT make any assumptions**
   有任何问题请先问我 - 不要瞎猜

2. **The habit of pausing to think - Analyze the existing structure before taking action**
   暂停思考的习惯 - 在行动前先分析现有结构

3. **A commitment to quality - It's better to do it right than to do it fast**
   质量优先的价值观 - 宁可慢一点也要做对

4. **Holistic design thinking - Consider maintainability and consistency**
   整体设计思维 - 考虑可维护性和一致性

5. **Use style of Code Complete 2 - provide educational style comments when necessary**
   使用 Code Complete 2 的代码风格 - 必要时提供代码风格教学注释

## Development Commands

### Opening and Building

1. **Open Project**: Launch GameMaker Studio 2 and open `chemistris-gms/chemistris.yyp`
2. **Build for Windows**:
   - In GMS2 IDE: Game → Create Executable → Windows
   - Export creates `chemistris.exe` and `data.win`
3. **Testing Locally**:
   - Windows: Run the executable directly
   - macOS/Linux: `wine chemistris-gms/chemistris.exe` (from repository root)

**Important**: Always rebuild after modifying CSV data files or datafiles to ensure changes are bundled into the exported build.

## High-Level Architecture

### Core Algorithm Flow

The game implements a chemical reaction system with three main algorithm components:

1. **LIB_ALGO_MAIN**: Main reaction algorithm entry point
   - `Algorithm_reaction_global()`: Orchestrates the reaction flow
   - Entry points from `obj_cond` (condition objects) or `obj_mole` (molecule objects)
   - Pre-validates reactions using `equa2react2nMap` before executing

2. **LIB_ALGO_REACTANT** & **LIB_ALGO_PRODUCT**: Handle reactant and product logic
   - Parse CSV data to determine valid reactions
   - Manage molecule consumption and generation

3. **LIB_ALGO_DISPLAY**: Manages visual representation of reactions

### Data Pipeline Architecture

CSV files use **hashed filenames** and are linked via **Chinese poetry phrases** (equaPoem):

```
LEVEL CSV → (L1_CODE: "飞流直下三千尺")
           ↓
REACTANT CSV → (RT_CODE: "飞流直下三千尺", RT_MOLECULE: "O2", RT_QUANTITY: 1)
           ↓
PRODUCT CSV → (RT_CODE: "飞流直下三千尺", RT_MOLECULE: "H2O", RT_QUANTITY: 2)
```

**Key data structures:**
- `global.equa2react2nMap`: Maps equations to reactant molecules and quantities
- `global.equa2product2nMap`: Maps equations to product molecules and quantities
- `global.lvTableGrid`: Grid storing level configuration data

### Object Hierarchy

**Core Game Objects:**
- `obj_mole`: Falling molecule objects with `sObjMoleList` and `insideAtomSList` properties
  - Position tracked via tilemap cells (`xNowCell`, `yNowCell`)
  - Initialized with `ivSpeed` (initial vertical speed)
- `obj_cond`: Condition objects (heat, light, electricity) that trigger reactions
  - Types defined in `condType` property
  - Each condition has associated sprites: `spr_heat`, `spr_light`, `spr_elec`, `spr_fire`
- `obj_disp`: Display controller for reaction animations
- `obj_level`: Level state manager
- `obj_menu_test`: Menu system controller

### Script Library Organization

Scripts are organized by functional domain (see `lib_macro.gml` for constants):

**Algorithm Libraries:**
- `LIB_ALGO_*`: Core reaction algorithms
- `LIB_VICTORY`: Win condition checking
- `LIB_CONDITION`: Reaction condition validation
- `LIB_COUNTER`: Counter/scoring logic

**Data Management:**
- `LIB_CSV`: CSV parsing utilities
- `LIB_DATA_MAP`: Maps CSV data to nested ds_map structures (Equa→Mole→N, Equa→Atom→N)
- `LIB_DATA_TRANS`: Data transformation utilities
- `Check_consistency()`: Validates chemical equation balance

**Data Structures:**
- `LIB_DS_*`: Wrappers for GameMaker data structures (maps, lists, priorities)
- `LIB_BOND`: Chemical bond representation
- `LIB_ATOM_CELL_OBJ`: Atom and cell object management

**Display & UI:**
- `LIB_DRAW_EQUATION`: Renders chemical equations
- `LIB_MENU`: Menu system utilities
- `LIB_STR_ARY_DECO`: String array decoration helpers

**Utilities:**
- `LIB_TINY_FUNCS`: Small helper functions
- `LIB_MISC`: Miscellaneous utilities
- `Z_LIB_DEBUGER`: Debug utilities

### Room Initialization

**rom_level**: Main gameplay room
- Initializes via `Level_room_ini_global()`
- Loads level data: `Level_data_ini_global(global.level, global.lvTableGrid)`
- Creates level controller: `instance_create_layer(0,0,"lay_instance",obj_level)`
- Spawns first falling object: `Falling_next_obj_global()`

**rom_menu**: Main menu room

### Constants and Configuration

Key constants defined in `lib_macro.gml`:

**Grid Layout:**
- Reactor bounds: 600-1320px horizontal, 0-1080px vertical
- Cell size: 72px × 72px
- Grid: 10 horizontal × 15 visible vertical cells (+ 5 hidden above)
- Bond size: 12px

**CSV Table Indices:**
- REACTANT: `RT_CODE`, `RT_MOLECULE`, `RT_QUANTITY`
- PRODUCT: Same structure as REACTANT
- LEVEL: `L0_LEVEL`, `L1_CODE`, `L2_COUNT`, `L3_CHAP`, `L4_ORDER`, `L5_BAN`, `L6_ON`

**Display:**
- `PRODUCT_DISPLAY_TIME`: 180 frames
- `INITIAL_FALLING_SPEED`: 1 pixel/frame

## Code Style

Follow GameMaker Language conventions:
- Four-space indentation
- `camelCase` for local variables (e.g., `_equaPoem`, `xNowCell`)
- `PascalCase` for functions (e.g., `Algorithm_reaction_global`)
- `SCREAMING_SNAKE_CASE` for macros
- Resource prefixes: `obj_`, `spr_`, `scr_`, `lib_`
- CSV headers: lowercase with underscores

**Comment style:**
- Header blocks use `///` with ASCII art dividers
- Chinese/English bilingual comments common in algorithm sections
- Function headers document parameters and return types

Before committing, run GameMaker's "Code Cleanup" utility to normalize formatting.

## Git Commit Guidelines

**Always add detailed commit messages:**
- Use conventional commit format: `type: subject` (e.g., `feat:`, `fix:`, `docs:`, `refactor:`)
- Write clear, descriptive commit bodies explaining the "why" behind changes
- Include context about what changed and why it matters
- Reference related issues or design decisions when applicable
- Add co-authorship attribution when using AI assistance

Example:
```
feat: Add new oxygen reaction chain

Implement O2 → O3 reaction triggered by electricity condition.
Updates REACTANT and PRODUCT CSV files with new poetry code.

Fixes chemistry balance issue in Chapter 3.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Testing

No automated test framework exists. Testing approach:

1. **CSV Validation**: After changing data files, verify equations are balanced via `Check_consistency()`
2. **Gameplay Testing**: Run build and test level sequences in Practice mode
3. **Reaction Testing**: Verify each new chemical reaction visually
4. **Debug Output**: Enable GameMaker debug overlay for console messages
5. **Documentation**: Capture GIFs/screenshots of visual changes or bugs

## Version Tagging

Project uses semantic versioning:
- v0.1.0: Initial release with compiled build
- v0.2.0: Source code release
- Format: `v[MAJOR].[MINOR].[PATCH]`
