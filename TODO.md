# Godot Refactor TODO

## Phase 0 – Discovery & Planning
- [x] Inventory all GameMaker resources (`chemistris-gms/scripts`, `objects`, `rooms`, `sprites`, `sounds`) and capture their purpose in a shared doc.
- [x] Reverse-engineer the CSV data pipeline in `datafiles/` (LEVEL/REACTANT/PRODUCT) and document schema, hashing strategy, and poetry-code mapping.
- [x] Record current gameplay flow by screen-capturing `rom_menu` → `rom_level`, annotating molecule behaviors, win/lose conditions, and timing.
- [x] Extract macro constants from `scripts/lib_macro/lib_macro.gml` into a reference sheet for Godot equivalents (grid bounds, speeds, display offsets).
- [x] Define the minimum viable feature set for the first Godot 4 build and flag non-critical features for later sprints.

## Phase 1 – Godot Project Scaffolding
- [x] Create a Godot 4 project in the repository root with standard folders (`scenes`, `scripts`, `assets`, `data`, `ui`, `addons`).
- [x] Configure project settings (display size, input map, default environment) to match GameMaker reactor bounds and aspect ratio.
- [x] Establish version-control ignores for Godot-generated files and artifact directories.
- [x] Add tooling: install Godot asset-import settings, eslint-equivalent (`gdlint` or editor config), and format/lint hooks mirroring Code Complete 2 style guidance.

## Phase 2 – Asset & Data Migration
- [ ] Export sprites, fonts, and audio from GameMaker; convert to Godot-friendly formats (PNG sequences, OGG) while preserving naming conventions.
- [ ] Recreate the font pipeline for `IBMPlexSansCondensed.ttf`, configuring dynamic font resources and fallback stacks.
- [ ] Design a deterministic loader that converts hashed CSV filenames into descriptive `.tres` or JSON resources; verify poetry-code roundtrip.
- [ ] Prototype a Godot `DataService` autoload that exposes level, reactant, and product datasets with caching and validation hooks.

## Phase 3 – Scene & Node Architecture
- [ ] Sketch target scene tree architecture mapping GameMaker objects (`obj_level`, `obj_mole`, `obj_cond`, `obj_disp`) to Godot scenes and nodes.
- [ ] Implement base scenes: `MainMenu.tscn`, `Level.tscn`, `Molecule.tscn`, `Condition.tscn`, `ReactionDisplay.tscn`, including signals and exported properties.
- [ ] Set up an `Autoload` singleton for global state (level progress, reaction maps) and port relevant macros as constants.
- [ ] Build a tilemap/grid system mirroring GameMaker cell sizes (72px) using Godot `TileMap` or `GridContainer`, including coordinate conversion helpers.

## Phase 4 – Core Gameplay Systems
- [ ] Port `LIB_ALGO_MAIN` flow into a Godot service (`ReactionController.gd`) with well-commented, unit-testable methods for validation and execution.
- [ ] Translate `LIB_ALGO_REACTANT` and `LIB_ALGO_PRODUCT` logic into data-driven processing modules; ensure stoichiometry is preserved.
- [ ] Recreate molecule falling physics using Godot’s `_physics_process`, respecting `INITIAL_FALLING_SPEED` and collision layers.
- [ ] Implement condition triggers (heat, light, electricity) with node groups/signals replacing GameMaker event wiring.
- [ ] Port `LIB_ALGO_DISPLAY` visual updates into animation players and tween sequences, matching timing constants like `PRODUCT_DISPLAY_TIME`.

## Phase 5 – UI & UX Parity
- [ ] Rebuild menu flows (`rom_menu`) with Godot `Control` nodes, ensuring navigation, chapter selection, and localization readiness.
- [ ] Implement in-level HUD (score, equations, condition indicators) using `Control` scenes anchored to Godot’s UI system.
- [ ] Add pause, fail (`obj_page_fail`), and success (`obj_page_success`) overlays with reusable transitions.
- [ ] Integrate keyboard/gamepad input mappings and accessibility options (text scaling, color-blind modes if feasible).

## Phase 6 – Data Integrity & Tooling
- [ ] Implement a Godot editor plugin or script to import and validate reaction CSVs, running checks analogous to `Check_consistency()`.
- [ ] Add automated regression tests (GUT or WAT) for reaction validation, molecule spawning, and win conditions.
- [ ] Establish logging/telemetry hooks for debugging (console output, on-screen debug panel toggled via debug flag).

## Phase 7 – Polish & QA
- [ ] Conduct side-by-side gameplay comparison between GameMaker and Godot builds; log divergences and prioritize fixes.
- [ ] Optimize performance: profile reaction loops, tilemap updates, and animation batching; resolve bottlenecks.
- [ ] Finalize audio mixing, particle effects, and shader equivalents to match original feel.
- [ ] Prepare localization pipeline for poetry phrases and ensure Unicode rendering works in Godot.

## Phase 8 – Release Preparation
- [ ] Draft updated documentation (`README`, `AGENTS.md`, Godot-specific developer guide) describing the new architecture and workflows.
- [ ] Create build/export presets for Windows, macOS, and Linux, validating artifact integrity on each platform.
- [ ] Design a migration checklist for future contributors (how to run, test, and package the Godot project).
- [ ] Archive the original GameMaker project with notes on deprecated workflows for historical reference.
