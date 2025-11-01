# Godot Scene Architecture Plan

## High-Level Mapping
- **MainMenu.tscn** (Control)  
  Mirrors `rom_menu` + `obj_menu_test`. Handles chapter/level navigation, progress display, and transitions into `Level.tscn`.
- **Level.tscn** (Node2D)  
  Successor to `rom_level` and `obj_level`. Owns the grid, spawns molecules/conditions, and coordinates reaction flow.
- **Molecule.tscn** (Node2D)  
  Port of `obj_mole`. Contains sprites/animation for atoms, signal hooks for movement, and references to data-driven molecule definitions.
- **Condition.tscn** (Node2D)  
  Port of `obj_cond`. Visualizes heat/light/electric triggers and exposes metadata for reaction checks.
- **ReactionDisplay.tscn** (Control)  
  Port of `obj_disp`. Renders reaction panels, counters, and outcome overlays.

## Core Singletons
- **ChemistrisDataService** (autoload)  
  Provides CSV-backed data (`get_reactant_map`, `get_product_map`, `get_level_rows`) and stoichiometry checks.
- **GameState.gd** (new autoload)  
  Tracks current level, chapter progress, counters, and exposes signals for UI updates.

## Level Scene Hierarchy (draft)
```
Level (Node2D)
├── GridRoot (Node2D)
│   ├── BoardTileMap (TileMap)            # 72px cell grid
│   ├── MoleculeLayer (Node2D)            # Active Molecule instances
│   └── ConditionLayer (Node2D)           # Condition instances
├── ReactionLayer (Node2D)                # Transient VFX, ReactionDisplay instances
├── HudCanvas (CanvasLayer)
│   ├── CounterPanel (Control)
│   └── EquationPanel (Control)
└── LevelController (Node)                # Script bridging DataService ↔ gameplay
```

## Molecule Scene
```
Molecule (Node2D)
├── SpriteRoot (Node2D)
│   ├── MoleculeSprite (AnimatedSprite2D)
│   └── AtomSpriteLayer (Node2D)          # Atom sprites / debug overlays
└── CollisionArea (Area2D)
    └── BoundsShape (CollisionShape2D)
```

Key signals:
- `molecule_landed(molecule: Molecule)`
- `molecule_reacted(molecule: Molecule, reaction_code: String)`

## Condition Scene
```
Condition (Node2D)
└── Sprite (AnimatedSprite2D)
```
Metadata:
- `condition_type: String` (e.g., "heat", "light")
- `grid_position: Vector2i`

## ReactionDisplay Scene
```
ReactionDisplay (Control)
├── Panel (Panel)
│   ├── EquationLabel (RichTextLabel)
│   ├── ReactantContainer (HBoxContainer)
│   └── ProductContainer (HBoxContainer)
└── Timer (Timer)
```
Signals:
- `display_finished()`

## Tile/Grid Utility
- **GridHelper.gd** (singleton or resource)
  - Converts between pixel/global coordinates and grid cells (72px + hidden rows).
  - Provides cell validation and neighbor lookup mirroring GameMaker's `Cell_constructor`.

## Scene Communication Flow
1. `MainMenu` emits `start_level(level_id)` → `GameState` stores selection → loads `Level`.
2. `Level` loads level config via `ChemistrisDataService`, initializes grid, spawns first `Molecule` or `Condition`.
3. `Molecule` emits movement/land events → `LevelController` evaluates reactions via `ChemistrisDataService`, requests `ReactionDisplay`.
4. `ReactionDisplay` shows results, notifies `LevelController` on completion, which updates HUD via `GameState`.

## Next Steps
- Scaffold scene files and attach placeholder scripts matching this structure.
- Implement `GameState` autoload with minimal properties (current level, counters).
- Begin porting grid helpers and input handling in Phase 4.
