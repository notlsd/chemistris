# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Chemistris is a chemistry-themed puzzle game originally built with GameMaker Studio 2 (IDE version 2022.0.2.51), currently being migrated to Godot 4.5. The game features falling molecules that react according to chemical equations defined in CSV data files, using Chinese poetry phrases as unique identifiers.

**Repository Structure:**
- `chemistris-gms/`: Original GameMaker Studio 2 project (fully functional)
- Root directory: Godot 4.5 project (migration in progress - Phase 2 complete)
- Both projects coexist to enable parallel development during migration

**Migration Status:** Phase 2 of 8 complete (Asset & Data Migration)
- See `TODO.md` for complete 8-phase roadmap
- See `docs/` for phase-specific documentation

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

### GameMaker Studio 2 (Original Project)

1. **Open Project**: Launch GameMaker Studio 2 and open `chemistris-gms/chemistris.yyp`
2. **Build for Windows**:
   - In GMS2 IDE: Game → Create Executable → Windows
   - Export creates `chemistris.exe` and `data.win`
3. **Testing Locally**:
   - Windows: Run the executable directly
   - macOS/Linux: `wine chemistris-gms/chemistris.exe` (from repository root)

**Important**: Always rebuild after modifying CSV data files or datafiles to ensure changes are bundled into the exported build.

### Godot 4.5 (Migration Project)

1. **Open Project**:
   - `godot project.godot` (command line)
   - Or open Godot Editor and select project root directory
2. **Run Project**: Press F5 in Godot Editor or `godot --path .`
3. **Testing DataService**:
   - Headless test: `godot --headless --script res://scripts/tests/run_data_tests.gd`
   - Validates CSV parsing and stoichiometry
4. **Project Structure**:
   - `scenes/`: Scene tree roots (.tscn files)
   - `scripts/`: GDScript logic (`.gd` files)
   - `assets/`: Sprites, audio, fonts (exported from GameMaker)
   - `data/`: CSV files and catalog.json
   - `ui/`: Control scenes and HUD components

**Important**: Project uses GL compatibility rendering mode for broader hardware support.

## High-Level Architecture

### GameMaker Studio 2 Architecture

#### Core Algorithm Flow

The game implements a chemical reaction system with three main algorithm components:

1. **LIB_ALGO_MAIN**: Main reaction algorithm entry point
   - `Algorithm_reaction_global()`: Orchestrates the reaction flow
   - Entry points from `obj_cond` (condition objects) or `obj_mole` (molecule objects)
   - Pre-validates reactions using `equa2react2nMap` before executing

2. **LIB_ALGO_REACTANT** & **LIB_ALGO_PRODUCT**: Handle reactant and product logic
   - Parse CSV data to determine valid reactions
   - Manage molecule consumption and generation

3. **LIB_ALGO_DISPLAY**: Manages visual representation of reactions

#### Data Pipeline Architecture

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

#### Object Hierarchy

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

#### Script Library Organization

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

#### Room Initialization

**rom_level**: Main gameplay room
- Initializes via `Level_room_ini_global()`
- Loads level data: `Level_data_ini_global(global.level, global.lvTableGrid)`
- Creates level controller: `instance_create_layer(0,0,"lay_instance",obj_level)`
- Spawns first falling object: `Falling_next_obj_global()`

**rom_menu**: Main menu room

#### Constants and Configuration

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

### Godot 4.5 Architecture

#### DataService Autoload

The Godot project implements a singleton `DataService` (class name `ChemistrisDataService`) that mirrors GameMaker's data pipeline:

**File:** `scripts/data/data_service.gd` (registered as autoload in `project.godot`)

**Key Methods:**
- `get_reactant_map() -> Dictionary`: Returns `equa→reactant→quantity` map
  - Equivalent to GameMaker's `global.equa2react2nMap`
  - Poetry codes as keys, nested dictionaries for molecules
- `get_product_map() -> Dictionary`: Returns `equa→product→quantity` map
  - Equivalent to GameMaker's `global.equa2product2nMap`
- `get_level_rows() -> Array[Dictionary]`: Returns parsed level configuration
  - Each element is a dictionary with column names as keys
  - Equivalent to GameMaker's `global.lvTableGrid`
- `validate_stoichiometry() -> bool`: Checks chemical equation balance
  - Equivalent to GameMaker's `Check_consistency()`

**Data Flow:**
1. `data/catalog.json` maps hashed CSV filenames to readable names
2. DataService loads CSVs from `data/csv/` directory
3. Translation files (`.L1`, `.RT`, etc.) provide column name mappings
4. Caches parsed data for performance (lazy loading)

**Poetry-Code Linking:** Preserved from GameMaker
```
Level CSV → (L1_CODE: "飞流直下三千尺")
           ↓
get_reactant_map()["飞流直下三千尺"] → {"O2": 1, "H2": 2}
           ↓
get_product_map()["飞流直下三千尺"] → {"H2O": 2}
```

#### Asset Organization

**Sprites** (`assets/sprites/`):
- Exported from GameMaker with frame numbering
- Animation frames: `spr_name_00.png`, `spr_name_01.png`, etc.
- Single frames: `spr_name.png`
- 92 total frames across 20 sprite sets

**Audio** (`assets/audio/`):
- `snd_cyber.mp3`: Background music

**Fonts** (`assets/fonts/`):
- `IBMPlexSansCondensed.ttf`: UI typography (handles bilingual text)

**Manifest:** `assets/README.md` documents all exported assets with frame counts

#### Scene Structure (Phase 3 - Complete)

**Godot equivalents to GameMaker objects:**
- `Level.tscn` → `obj_level`: Level state manager
- `Molecule.tscn` → `obj_mole`: Falling molecule instances
- `Condition.tscn` → `obj_cond`: Reaction condition triggers
- `ReactionDisplay.tscn` → `obj_disp`: Visual reaction feedback
- `MainMenu.tscn` → `obj_menu_test`: Menu system (currently placeholder)

#### Testing Infrastructure

**Headless Tests** (`scripts/tests/run_data_tests.gd`):
- Validates CSV parsing correctness
- Verifies poetry-code roundtrip integrity
- Confirms stoichiometry balance
- Run with: `godot --headless --script res://scripts/tests/run_data_tests.gd`

## Code Style

### GameMaker Language (GML)

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

### GDScript (Godot)

Follow GDScript style guide and best practices:
- Four-space indentation (enforced by `.editorconfig`)
- `snake_case` for variables and functions (e.g., `get_reactant_map`, `level_rows`)
- `PascalCase` for class names (e.g., `ChemistrisDataService`)
- `SCREAMING_SNAKE_CASE` for constants
- Type annotations using `:=` inference or explicit types
  - `var dataset := _load_dataset("level")` (inferred)
  - `func get_level_rows() -> Array[Dictionary]:` (explicit return type)

**Best Practices:**
- Use type annotations for better error catching and documentation
- Avoid variable shadowing in loops (use descriptive iterator names)
- Add explicit `str()` conversions when type is uncertain
- Document functions with comments explaining purpose and parameters
- Use `@export` for scene-configurable properties (Phase 3+)

**Comment Style:**
- Use `##` for documentation comments (shows in editor hover)
- Use `#` for implementation comments
- Bilingual comments welcome where clarity requires translation

**Tool Integration:**
- Format with `gdformat` before committing
- Lint with `gdlint` to catch issues
- `.editorconfig` enforces indentation automatically

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

### GameMaker Studio 2

No automated test framework exists. Testing approach:

1. **CSV Validation**: After changing data files, verify equations are balanced via `Check_consistency()`
2. **Gameplay Testing**: Run build and test level sequences in Practice mode
3. **Reaction Testing**: Verify each new chemical reaction visually
4. **Debug Output**: Enable GameMaker debug overlay for console messages
5. **Documentation**: Capture GIFs/screenshots of visual changes or bugs

### Godot 4.5

Automated testing infrastructure:

1. **DataService Validation**:
   - Run: `godot --headless --script res://scripts/tests/run_data_tests.gd`
   - Validates CSV parsing, poetry-code linking, stoichiometry
2. **Manual Testing**:
   - Run project with F5, test scene functionality
   - Check console output for errors
3. **Future Testing** (Phase 6):
   - GUT (Godot Unit Test) framework integration planned
   - Automated regression tests for gameplay systems
   - CI pipeline for validation on commit

## Version Tagging

Project uses semantic versioning (format: `v[MAJOR].[MINOR].[PATCH]`):

**Release History:**
- **v0.1.0**: Initial release with compiled Windows build
- **v0.2.0**: GameMaker Studio 2 source code release
- **v0.3.0**: Documentation & planning release (migration roadmap)
- **v0.3.1**: Scene & node architecture (Phase 3 complete)
- **v0.4.0**: Godot 4 project scaffolding (Phase 1 complete)
- **v0.4.1**: Reaction algorithm implementation (Phase 4 partial - 2/5 tasks)
- **v0.5.0**: Asset & data migration (Phase 2 complete) - *pending*

**Version Guidelines:**
- Increment PATCH for bug fixes and refactoring
- Increment MINOR for new features and phase completions
- Increment MAJOR for breaking changes or major milestones (1.0.0 at Phase 8 completion)
- Tag after significant milestones with detailed release notes
