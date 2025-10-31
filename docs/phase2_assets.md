# Godot Migration — Phase 2 Notes

## Asset Extraction Summary
- Copied all GameMaker sprite textures into `assets/sprites/<sprite_name>/spr_<name>_NN.png`.
- Exported audio cue `snd_cyber.mp3` to `assets/audio/`.
- Staged `IBMPlexSansCondensed.ttf` in `assets/fonts/` for Godot dynamic font configuration.
- Asset manifest with counts recorded in `assets/README.md`.

## Outstanding Conversions
- Verify whether additional sound effects exist in later GameMaker branches before locking the audio set.
- Decide on Godot import presets (filtering, compression) once scenes consume each asset; document in a future tooling guide.

## Data Pipeline Planning
- Goal: replace hashed CSV filenames (`LEVEL beebc167bca74e318f87492c6d029cfb.csv`) with deterministic resource names.
- Approach:
  1. Maintain a metadata file (e.g., `data/catalog.json`) mapping hash filenames to semantic keys (`level`, `reactant`, `product`).
  2. Implement a Godot `DataService` autoload (`scripts/data/data_service.gd`, class `ChemistrisDataService`) that:
     - Loads catalog on startup.
     - Parses CSVs into dictionaries mirroring `global.equa2react2nMap`, `global.equa2produ2nMap`, and `global.lvTableGrid`.
     - Validates stoichiometry using unit tests ported from `Check_consistency`.
  3. Provide helper methods `get_equation(code)`, `list_levels()`, `get_level_config(level_name)` to encapsulate hashed lookup logic.
- Testing Strategy:
  - Create fixture CSVs in `data/csv/` identical to GameMaker exports.
  - Write headless GDScript tests (`scripts/tests/run_data_tests.gd`) asserting that data structures match serialized expectations; execute via `godot --headless --script res://scripts/tests/run_data_tests.gd`.
