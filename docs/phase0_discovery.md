# Godot Migration — Phase 0 Findings

## 1. Resource Inventory
- **Scripts (`chemistris-gms/scripts`)**  
  - `LIB_ALGO_*`: Core reaction flow (`LIB_ALGO_MAIN`), reactant search, product synthesis, and display choreography. Backend routines chain with extensive bilingual commentary for algorithm tracing.  
  - `LIB_DATA_*` & `LIB_CSV`: CSV ingestion, ds_map/ds_list transformations, and data-validation helpers (e.g., `Check_consistency`).  
  - `LIB_DS_*`: Thin wrappers around GameMaker data structures to normalize access patterns.  
  - `LIB_DRAW_EQUATION`, `LIB_MENU`, `LIB_VICTORY`: Rendering overlays, menu navigation, progress, and victory conditions.  
  - Utilities (`LIB_TINY_FUNCS`, `LIB_MISC`, `Z_LIB_DEBUGER`, `lib_macro`, `lib_criterion`): Math helpers, debugging, macro constants, and scoring rules.
- **Objects (`chemistris-gms/objects`)**  
  - `obj_mole`: Falling molecule instances with physics-esque properties (`ivSpeed`, motion events, keyboard controls).  
  - `obj_cond`: Environmental triggers (heat, light, electricity) positioned on the grid to enable reactions.  
  - `obj_level`: Room-level state manager—spawns molecules/conditions, owns counters and banned lists.  
  - `obj_disp`: Presentation controller for reaction text and animations.  
  - `obj_menu_test`, `obj_page_fail`, `obj_page_success`, `obj_tmp_clicker`: Menu navigation, fail/success overlays, and debug interaction tools.
- **Rooms (`chemistris-gms/rooms`)**  
  - `rom_menu`: Entry UI with level selection and chapter navigation.  
  - `rom_level`: Main gameplay arena; hosts grid, conditions, HUD, and reaction flow.
- **Assets**  
  - `sprites/`: Molecules, conditions, UI elements, and animation frames (PNG).  
  - `sounds/`: Reaction and UI audio cues.  
  - `tilesets/`: Reactor grid tiles.  
  - `datafiles/`: CSV datasets plus `IBMPlexSansCondensed.ttf` for UI typography.

## 2. CSV Data Pipeline
- Hashed filenames (`LEVEL beebc167bca74e318f87492c6d029cfb.csv`) contain content-aware identifiers; hashes likely map from raw table names to avoid collisions inside GameMaker packages.  
- `LEVEL` schema: `L0_LEVEL` (display name), `L1_CODE` (Chinese poetry key), `L2_COUNT` (sequence of molecules), `L3_CHAP` (chapter), `L4_ORDER` (level ordering), `L5_BAN` (banned molecules), `L6_ON` (Yes/No flag). Rows use prefixes like `+`/`-` to indicate unlock state.  
- `REACTANT`/`PRODUCT` schema: `RT_CODE`, `RT_MOLECULE`, `RT_QUANTITY`. Rows reuse the poetry key to join reagents and outcomes; blank quantities represent “structural” rows (e.g., placeholder glyphs).  
- Hash-keyed CSVs are consumed via `LIB_CSV` → `LIB_DATA_MAP`, populating global maps (`global.equa2react2nMap`, `global.equa2product2nMap`, `global.lvTableGrid`). Poetry strings act as the relational glue between level entries and reaction definitions.

## 3. Gameplay Flow Notes
1. **Main Menu (`rom_menu`)**: Player chooses unlocked chapters/levels; `obj_menu_test` and associated scripts handle inputs and highlight states.  
2. **Level Start (`rom_level`)**: `obj_level` initializes grid constants, loads level data, spawns the first `obj_mole`, and configures counters/banned lists.  
3. **Active Play**: Molecules fall at `INITIAL_FALLING_SPEED`, responding to keyboard inputs (events for W/A/S/D). Conditions (`obj_cond`) reside on the board; when molecules collide or are positioned correctly, `Algorithm_reaction_global` validates the reaction using CSV-driven maps.  
4. **Reaction Resolution**: Backend scripts choose suitable reactant sets, remove consumed molecules, spawn products, and trigger `obj_disp` to show equations/animations (timed by `PRODUCT_DISPLAY_TIME`).  
5. **Progression**: `LIB_VICTORY` checks win conditions (clearing objectives or counters) and transitions to `obj_page_success`; failures trigger `obj_page_fail`. Return paths lead back to `rom_menu`.

## 4. Macro Constant Reference (`lib_macro.gml`)
| Constant | Value | Notes |
| --- | --- | --- |
| `REACTOR_LEFT/RIGHT/UP/DOWN` | 600 / 1320 / 0 / 1080 | Defines playable bounds; informs Godot viewport and camera framing. |
| `CELL_SIDE_PX` | 72 | Grid cell size; central to tilemap scaling. |
| `BOND_SIDE_PX` | 12 | Sub-cell spacing; relevant for bond rendering. |
| `INITIAL_FALLING_SPEED` | 1 | Base molecule drop speed (pixels/frame). |
| `SUPER_SPEED` | 200 | Debug/boost speed for fast drop. |
| `PRODUCT_DISPLAY_TIME` | 180 | Frames to keep reaction results visible. |
| `N_DISPLAYED_HOR/VER_CELLS` | 10 / 15 | Grid dimensions (plus 5 hidden vertical cells). |
| `MENU_BOX_*` constants | Mixed | Menu layout metrics to carry into Godot’s Control nodes. |

Additional enums (`levelStatus`) and offsets govern HUD placement and chapter UI; port them as exported constants or theme settings in Godot.

## 5. Godot MVP Scope
- **Core Loop**: Single playable level loading from CSV data, molecule spawn/fall controls, condition triggers, and reaction validation producing correct products.  
- **UI Basics**: Minimal menu to start the level, in-level HUD displaying active equation and counters, and win/fail dialogs.  
- **Data Layer**: CSV ingestion pipeline inside Godot with caching and parity checks (stoichiometry validation).  
- **Visual Parity Essentials**: Reactor grid rendering, molecule sprites, and reaction feedback text/animations (rough equivalents).  
- **Platform Targets**: Desktop export template (Windows/macOS) to validate pipeline end-to-end; audio/particle polish can follow in later phases.
