# Phase 4 Plan — Reaction Systems

## Goals
- Port the GameMaker reaction pipeline (`LIB_ALGO_MAIN`, `LIB_ALGO_REACTANT`, `LIB_ALGO_PRODUCT`, `LIB_ALGO_DISPLAY`) into modular GDScript.
- Preserve data flow: reactant search → product assembly → presentation payload.
- Produce automated tests validating existing CSV reactions (stoichiometry, reactant selection, product generation).
- Integrate with Godot scenes gradually: gameplay nodes supply molecule grid state; reaction controller returns deterministic results.

## Architecture Overview

### Core Modules
| Module | Path | Responsibilities |
| --- | --- | --- |
| `ReactionController` | `scripts/gameplay/reaction_controller.gd` | Public API (`attempt_reaction(trigger)`) orchestrating reactant search, product assembly, and frontend payload creation. |
| `ReactantFinder` | `scripts/gameplay/reactant_finder.gd` | Finds all legal reactant combinations given a trigger molecule/condition using adjacency graphs (ports `Get_reactant_obj_list_of_array`). |
| `ProductAssembler` | `scripts/gameplay/product_assembler.gd` | Generates product atom arrangements, ensuring stoichiometry and non-overlap (ports `Get_map_of_PPLASMAS`, `Get_map_of_PPLAMMCDC`, `Get_algorithm_final_list_of_array`). |
| `ReactionModels` | `scripts/gameplay/reaction_models.gd` | Data classes (`MoleculeState`, `AtomState`, `CellState`, `ReactionResult`, etc.) bridging Godot nodes and algorithm modules. |
| `ReactionDisplayAdapter` | `scripts/gameplay/reaction_display_adapter.gd` | Converts `ReactionResult` into UI payload (`ReactionDisplay` input, counters update). |

### Data Flow
1. **Input**: `ReactionTrigger` containing equation code, trigger molecule ID/condition, and current `ReactionGridState`.
2. `ReactionController` requests `ReactantFinder` to enumerate combinations matching CSV requirements.
3. For each combination, `ProductAssembler` builds candidate product layouts; first valid result returns a `ReactionResult`.
4. `ReactionController` notifies gameplay listeners (Level scene) and fills `ReactionDisplayAdapter` to update HUD/counters.

### Data Structures
```text
MoleculeState:
  id: int
  molecule_id: String
  atoms: Array[AtomState]
  neighbors: Array[int]   # Molecule IDs touching this molecule

AtomState:
  id: int
  symbol: String
  cell: CellState

CellState:
  grid: Vector2i
  occupants: Array[int]   # Atom IDs occupying or available for adjacency
```

For tests, states will be created manually. In gameplay, `LevelController` converts scene nodes into these models before calling the reaction API.

## Reactant Search Strategy
- Convert CSV reactant requirements into a multiset (array) sorted alphabetically, matching GameMaker logic.
- Starting from trigger molecule ID, perform breadth-first expansion across neighbor graph to fill required slots.
- Deduplicate combinations by sorting arrays (like `Sort_and_delete_repeated_array_in_4`).
- Filter combinations against required molecule counts (handles duplicate molecules).

## Product Assembly Strategy
- Use `ChemistrisDataService` to fetch product map + atom map (constructed on first use).
- Build permutations of atom placements:
  1. Map each product molecule to available atoms from reactant combination.
  2. Recursively select atom groups matching required counts, ensuring unique atom usage.
  3. Produce `ReactionResult` with:
     - `consumed_molecule_ids`
     - `produced_atoms` (list of `ProducedAtom` with symbol and target cell)
     - `product_counts` (dictionary)
- Since spatial layout is tied to grid positions, Phase 4 focuses on atom allocation counts. Actual cell mapping occurs when Level scene decides target positions (Phase 5/6).

## Testing
- Add unit tests under `scripts/tests/reaction/` using Godot headless runner.
- Fixtures:
  - Simple reaction `飞流直下三千尺` (2*H2 + O2 -> 2*H2O).
  - Reaction requiring condition symbol to be present.
- Tests assert:
  - `ReactantFinder` returns expected combinations for handcrafted neighbor graphs.
  - `ReactionController.attempt_reaction` yields product counts matching CSV, and fails gracefully when adjacency missing.
- Command: `godot --headless --script res://scripts/tests/run_reaction_tests.gd`.

## Integration Plan
1. Implement `ReactionModels`, `ReactantFinder`, `ProductAssembler`, `ReactionController`.
2. Write unit tests using fixture states.
3. Extend `Level` script to construct `ReactionGridState` from scene nodes and call `ReactionController`.
4. Update `ReactionDisplay` to consume new `ReactionResult`.
5. Document usage and update `TODO` Phase 4 checklist.


## Implementation Notes
- `Level.tscn` now spawns reactant/condition placeholders per equation and feeds reactions via `ReactionController`.
- Manual trigger: focus the level scene and press `confirm` to attempt the first equation.
- Tests cover success, missing adjacency failure, and condition-triggered reactions (see `run_reaction_tests.gd`).
