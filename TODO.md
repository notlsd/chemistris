# Godot Refactor TODO

## Phase 0 – Discovery & Planning
- [x] Inventory all GameMaker resources (`chemistris-gms/scripts`, `objects`, `rooms`, `sprites`, `sounds`) and capture their purpose in a shared doc.
- [x] Reverse-engineer the CSV data pipeline in `datafiles/` (LEVEL/REACTANT/PRODUCT) and document schema, hashing strategy, and poetry-code mapping.
- [x] Record current gameplay flow by screen-capturing `rom_menu` → `rom_level`, annotating molecule behaviors, win/lose conditions, and timing.
- [x] Extract macro constants from `scripts/lib_macro/lib_macro.gml` into a reference sheet for Godot equivalents (grid bounds, speeds, display offsets).
- [x] Define the minimum viable feature set for the first Godot 4 build and flag non-critical features for later sprints.
- **Acceptance Standards**
  - Repository includes `docs/phase0_discovery.md` summarizing inventory, CSV schema, and gameplay flow.
  - `docs/reaction_algorithm_analysis.md` explains reaction data structures and flow to guide later ports.
  - Supporting captures for parity live under `debug/` or docs so Phase 7 comparison is possible.

## Phase 1 – Godot Project Scaffolding
- [x] Create a Godot 4 project in the repository root with standard folders (`scenes`, `scripts`, `assets`, `data`, `ui`, `addons`).
- [x] Configure project settings (display size, input map, default environment) to match GameMaker reactor bounds and aspect ratio.
- [x] Establish version-control ignores for Godot-generated files and artifact directories.
- [x] Add tooling: install Godot asset-import settings, eslint-equivalent (`gdlint` or editor config), and format/lint hooks mirroring Code Complete 2 style guidance.
- **Acceptance Standards**
  - `project.godot` opens without missing-resource alerts (placeholder `scenes/MainMenu.tscn` committed).
  - Root `README.md` documents structure, tooling, and placeholder expectations.
  - `.gitignore`, `.editorconfig`, and folder scaffold tracked; Godot cache files remain unversioned.

## Phase 2 – Asset & Data Migration
- [x] Export sprites, fonts, and audio from GameMaker; convert to Godot-friendly formats (PNG sequences, OGG) while preserving naming conventions.
- [ ] Recreate the font pipeline for `IBMPlexSansCondensed.ttf`, configuring dynamic font resources and fallback stacks.
- [x] Design a deterministic loader that converts hashed CSV filenames into descriptive `.tres` or JSON resources; verify poetry-code roundtrip.
- [x] Prototype a Godot `DataService` autoload that exposes level, reactant, and product datasets with caching and validation hooks.
- **Acceptance Standards**
  - Converted sprites, audio, and fonts organized under `assets/` with a manifest or README citing origins and formats.
  - Automated tests confirm hashed CSV loading matches GameMaker datasets (quantities, poetry codes).
  - Godot importer previews key assets without warnings; font resources render poetry text correctly.

## Phase 3 – Scene & Node Architecture
- [x] Sketch target scene tree architecture mapping GameMaker objects (`obj_level`, `obj_mole`, `obj_cond`, `obj_disp`) to Godot scenes and nodes.
- [x] Implement base scenes: `MainMenu.tscn`, `Level.tscn`, `Molecule.tscn`, `Condition.tscn`, `ReactionDisplay.tscn`, including signals and exported properties.
- [x] Set up an `Autoload` singleton for global state (level progress, reaction maps) and port relevant macros as constants.
- [x] Build a tilemap/grid system mirroring GameMaker cell sizes (72px) using Godot `TileMap` or `GridContainer`, including coordinate conversion helpers.
- **Acceptance Standards**
  - Architecture diagram and notes checked into `docs/scene_architecture.md` (or equivalent) describing node hierarchies.
  - Placeholder scenes load in the editor with exported properties and signal hooks; autoload registered in `project.godot`.
  - Grid helper validated in editor or test scene, covering hidden rows and 72px cell conversions.

## Phase 4 – Core Gameplay Systems
- [x] Port `LIB_ALGO_MAIN` flow into a Godot service (`ReactionController.gd`) with well-commented, unit-testable methods for validation and execution.
- [x] Translate `LIB_ALGO_REACTANT` and `LIB_ALGO_PRODUCT` logic into data-driven processing modules; ensure stoichiometry is preserved.
- [x] Recreate molecule falling physics using Godot’s `_physics_process`, respecting `INITIAL_FALLING_SPEED` and collision layers.
- [x] Implement condition triggers (heat, light, electricity) with node groups/signals replacing GameMaker event wiring.
- [x] Port `LIB_ALGO_DISPLAY` visual updates into animation players and tween sequences, matching timing constants like `PRODUCT_DISPLAY_TIME`.
- **Acceptance Standards**
  - Automated tests cover reactant discovery, product assembly, and error cases against sample CSV data.
  - Playable demo scene runs at least one full reaction loop end-to-end using Godot systems.
  - Physics tuning documented; measured fall speed within ±5% of GameMaker reference and conditioners respond correctly.

## Phase 5 – UI & UX Parity
- [x] Rebuild menu flows (`rom_menu`) with Godot `Control` nodes, ensuring navigation, chapter selection, and localization readiness.
- [x] Implement in-level HUD (score, equations, condition indicators) using `Control` scenes anchored to Godot’s UI system.
- [ ] Add pause, fail (`obj_page_fail`), and success (`obj_page_success`) overlays with reusable transitions.
- [ ] Integrate keyboard/gamepad input mappings and accessibility options (text scaling, color-blind modes if feasible).
- **Acceptance Standards**
  - UX comparison (screenshots or video) demonstrates parity with GameMaker menus and HUD.
  - UI adapts to target resolutions; localization stubs render poetry codes and bilingual text correctly.
  - Accessibility checklist complete: remappable input map, scalable text, and documented color guidance.

## Phase 6 – Data Integrity & Tooling
- [ ] Implement a Godot editor plugin or script to import and validate reaction CSVs, running checks analogous to `Check_consistency()`.
- [ ] Add automated regression tests (GUT or WAT) for reaction validation, molecule spawning, and win conditions.
- [ ] Establish logging/telemetry hooks for debugging (console output, on-screen debug panel toggled via debug flag).
- **Acceptance Standards**
  - CI or local automation runs data validation and gameplay tests on commit.
  - Debug overlay/logging toggled via project setting and documented for QA.
  - CSV importer detects intentional malformed data during negative testing.

## Phase 7 – Polish & QA
- [ ] Conduct side-by-side gameplay comparison between GameMaker and Godot builds; log divergences and prioritize fixes.
- [ ] Optimize performance: profile reaction loops, tilemap updates, and animation batching; resolve bottlenecks.
- [ ] Finalize audio mixing, particle effects, and shader equivalents to match original feel.
- [ ] Prepare localization pipeline for poetry phrases and ensure Unicode rendering works in Godot.
- **Acceptance Standards**
  - Regression matrix signed off, capturing timing, visuals, and audio parity.
  - Profiling reports archived showing remediation of top bottlenecks.
  - Localization build validated for Chinese poetry strings and other target languages.

## Phase 8 – Release Preparation
- [ ] Draft updated documentation (`README`, `AGENTS.md`, Godot-specific developer guide) describing the new architecture and workflows.
- [ ] Create build/export presets for Windows, macOS, and Linux, validating artifact integrity on each platform.
- [ ] Design a migration checklist for future contributors (how to run, test, and package the Godot project).
- [ ] Archive the original GameMaker project with notes on deprecated workflows for historical reference.
- **Acceptance Standards**
  - Release documentation reviewed; onboarding guide tested by a fresh contributor or reviewer.
  - Export presets generate working builds on all target OSes with smoke-test results logged.
  - Archived GameMaker package stored with metadata and linked from docs for historical context.
