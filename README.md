# Chemistris (Godot 4) Scaffold

## Project Layout
- `scenes/` – Godot `.tscn` scene roots (`MainMenu`, `Level`, `Molecule`, `Condition`, `ReactionDisplay`).
- `scripts/` – GDScript logic; mirror GameMaker libraries and scenes (`ChemistrisDataService.gd`, `GameState.gd`, `scene/*.gd`).
- `assets/` – Art, audio, and font resources staged for import (`data/` for CSV mirrors).
- `ui/` – Control scenes and reusable HUD components.
- `data/` – Runtime JSON/CSV copies generated from the original hash-named files.

## Tooling & Conventions
- Format/lint with [`gdformat`](https://github.com/Scony/godot-gdscript-toolkit) and `gdlint`; run them before commits for parity with Code Complete 2 quality targets.
- `project.godot` pins the window to 1920×1080 (matching GameMaker reactor bounds plus UI) and locks the tick rate at 60 FPS to preserve gameplay timing.
- `.editorconfig` enforces four-space indentation across GDScript and scene files.
- Import cache directories (`.godot/`, `*.import/`) are ignored at the repo root; do not add them manually.
- `scenes/MainMenu.tscn` is a temporary placeholder so the project boots cleanly; replace it during Phase 3 when the real menu scene is implemented.

## Next Steps
- Flesh out base scenes under `scenes/` and bind inputs declared in `project.godot`.
- Continue fleshing out gameplay scenes now that `DataService` exposes CSV data structures.
- In `Level.tscn`, press `confirm` to run the staged reaction prototype fed by `ReactionController`.

## Data Service
- Autoload `DataService` (script class `ChemistrisDataService`) loads `data/catalog.json` and provides `get_reactant_map()`, `get_product_map()`, and `get_level_rows()`.
- Autoload `GameState` tracks current level selection/progress; `GridHelper` exposes grid coordinate helpers (72px cells, hidden rows).
- Base scenes are placeholders wired to the new architecture; hook them up to gameplay logic in Phase 4.
- Headless verification: `godot --headless --script res://scripts/tests/run_data_tests.gd` or `godot --headless --script res://scripts/tests/run_reaction_tests.gd`.
