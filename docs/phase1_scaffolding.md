# Godot Migration — Phase 1 Notes

## Project Skeleton
- Lifted Godot assets to the repository root (`addons`, `assets`, `data`, `scenes`, `scripts`, `ui`, `.godot`). `.gitkeep` placeholders remain where Godot expects non-empty folders.
- Added `project.godot` targeting a 1920×1080 window, fixed 60 FPS tick rate, and Vulkan forward+ renderer to mirror the GameMaker runtime cadence.
- Declared input actions (`move_left/right`, `soft_drop`, `rotate_ccw/cw`, `hard_drop`, `confirm`, `pause`) aligned with existing WASD/E rotation keys so front-end wiring can stay consistent during the port.
- Stubbed `scenes/MainMenu.tscn` as a placeholder Control scene to satisfy the configured main scene reference until Phase 3 builds the real menu.

## Tooling Decisions
- Extended root `.gitignore` to exclude Godot-generated caches (`.godot/`, `*.import`, `export_presets.cfg`, `.mono/`).
- Added `.editorconfig` enforcing four-space indentation to keep GDScript style consistent with Code Complete 2 guidance.
- Authored root `README.md` to document directory intent and recommend `gdformat`/`gdlint` prior to commits.

## Outstanding Phase 1 Follow-Up
- Populate `scenes/MainMenu.tscn` and `scenes/Level.tscn` once architecture mapping (Phase 3) is finalized.
- Define linting workflow (pre-commit hook or npm script) after selecting tooling host during Phase 2.
