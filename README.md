# Chemistris (Godot 4) Scaffold

## Project Layout
- `scenes/` – Godot `.tscn` scene roots (`MainMenu`, `Level`, `Molecule`).
- `scripts/` – GDScript logic; mirror GameMaker libraries (`ReactionController.gd`, `DataService.gd`).
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
- Implement `DataService.gd` first to translate hashed CSV filenames into descriptive resources; tests will target this module.
