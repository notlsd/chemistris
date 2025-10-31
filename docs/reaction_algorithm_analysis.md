# Reaction Algorithm Data & Flow

## High-Level Stages
- **Entry Validation (`Algorithm_reaction_global`)** – Confirms the triggering instance (falling molecule or condition token) participates in at least one reaction by reading `global.equa2react2nMap`. Early exit prevents unnecessary work.
- **Reactant Discovery (`Get_reactant_obj_list_of_array`)** – Builds every legal set of touching molecules that can supply the required reagents. Output is a `ds_list` of arrays, each array being one candidate reactant set.
- **Product Assembly (`Get_map_of_PPLASMAS` → `Get_algorithm_final_list_of_array_1`)** – Converts the selected reactant set to atom-level data, enumerates all admissible product placements, and collapses the nested map/list structures into a flat array suitable for display.
- **Frontend Handoff (`Algorithm_backend_return_constructor`)** – Packages the chosen reactants, the rendered product layout, and the product quantity map so the UI layer can animate consumption and creation.

## Core Runtime Structures
| Name | Type | Defined In | Purpose |
| --- | --- | --- | --- |
| `global.cellGrid` | `ds_grid<Cell>` | `LIB_ATOM_CELL_OBJ.gml` | Logical playfield; each `Cell` stores grid coordinates, neighbor pointers, and a pointer to the occupying `Atom`. |
| `Cell_constructor` | struct | `LIB_ATOM_CELL_OBJ.gml` | Provides neighbor references (`cellUp/Dn/Lt/Rt`) and `Random_next_cell()` used during molecule generation and flood-fill search. |
| `Atom_constructor_global` | struct | `LIB_ATOM_CELL_OBJ.gml` | Couples an atom to a `Cell`, knows its parent molecule ID, and exposes `Display/Erase` for tilemap updates. |
| `obj_mole.insideAtomSList` | `ds_list<Atom>` | `obj_mole.yy` | All atom structs belonging to one molecule; the [canonical 正形的] source for atom-level operations. |
| `obj_mole.sObjMoleList` | `ds_list<obj_mole>` | `obj_mole.yy` & `LIB_MISC.gml` | Adjacency cache; every step it records neighboring molecules discovered by walking neighbor cells around each atom. This provides a lightweight graph for reactant search. |
| `global.equa2react2nMap` / `global.equa2produ2nMap` | `ds_map<ds_map>` | `LIB_INI.gml` | Reaction lookup tables generated from CSV. Keys are poetry phrases; values map molecule string → quantity (conditions are encoded as Unicode symbols). |
| `global.equa2atom2nMap` | `ds_map<ds_map>` | `LIB_CSV.gml` | Equation balance index. Ensures reactant and product atoms match before runtime and informs root-selection heuristics. |
| `reactantObjListOfArray` | `ds_list<array<obj_mole>>` | `LIB_ALGO_REACTANT.gml` | Each array slot holds one potential molecule participating in the reaction; list entries enumerate all valid connected combinations. |
| `mapofPPLASMAS` | `ds_map<ds_list<array<Atom>>>` | `LIB_ALGO_PRODUCT.gml` | For every required product molecule, stores all atom-level [permutations 排列] that satisfy the molecular formula using atoms harvested from the selected reactants. (“PPLA(SM)AS” = Possible Product List of Array, Single Molecule, Atom Struct.) |
| `mapofPPLASMCDC` | `ds_map<ds_list<array<CapsuledDisplayedCell>>>` | `LIB_ALGO_DISPLAY.gml` | Wraps each atom in metadata (`dcMoleT`, `dcMoleI`) so display code can regroup atoms by product molecule without recomputing ownership. |
| `mapofPPLAMMCDC` | `ds_map<ds_list<array<CapsuledDisplayedCell>>>` | `LIB_ALGO_PRODUCT.gml` | Expands single-molecule results to multi-molecule combinations via `C(n,k)` to satisfy [stoichiometric 化学计量] coefficients. Prevents overlapping atom use across the same product type. |
| `algorithmFinalListOfArray` | `ds_list<array<CapsuledDisplayedCell>>` | `LIB_ALGO_PRODUCT.gml` | [Cartesian 笛卡尔的] product of every product species’ combinations. Each array is one fully resolved “reaction snapshot” covering all output molecules. |
| `Algorithm_backend_return_constructor` | struct | `LIB_ALGO_MAIN.gml` | Final payload containing: `arrayReactantObj` (reactants to destroy), `arrayDisplayedCapsuledCell` (one chosen product arrangement), and `produ2nMap` (product counts for counters/UI). |

## Stage Details

### 1. Entry Validation
1. `Algorithm_reaction_global` detects whether the caller is a condition (`obj_cond`) or molecule (`obj_mole`).  
2. Retrieves two arrays from `global.equa2react2nMap` via `Get_equa_mole_array`:  
   - Inclusive list (`reactArrayINC`) retains condition tokens.  
   - Exclusive list (`reactArrayEXC`) filters out condition tokens.  
3. Conditions must match directly against `_self.condType`. Molecules must:
   - Match the exclusive array length (guards against triggering when a condition is still pending).  
   - Appear in the required molecule set.  
4. The resolved emitter ID (`inID`) seeds the reactant search.

### 2. Reactant Discovery
1. `Get_reactant_obj_list_of_array` seeds `oROLA` with a single array whose length equals the number of reactant molecules. Slot `0` is the triggering instance.  
2. `Update_reactant_obj_list_of_array_recursion` repeatedly:
   - Finds the first `noone` slot (unresolved reactant position).  
   - Merges the `sObjMoleList` of the current partial combination. This list is assembled from each molecule’s cached neighbors and pruned so that no molecule is counted twice.  
   - Clones the current array for every candidate neighbor and fills the empty slot.  
   - De-duplicates arrays after each expansion to throttle combinatorial growth.  
3. After recursion terminates (no `noone` slots remain), utility passes clean and normalize results:  
   - `Delete_incompleted_array_in` removes any array still containing `noone`.  
   - `Sort_and_delete_repeated_array_in_4` ensures array order does not produce duplicate permutations.  
   - `Delete_unmatched_mole_obj_array_with` compares the molecule types in each array against the sorted target list, rejecting mismatched combinations.  
4. The resulting list is the exhaustive set of spatially connected reactant groups that meet the stoichiometric requirements for the equation.

### 3. Product Assembly
1. Backend iterates through each reactant candidate:  
   - Copies the product coefficient map (`produ2nMap`) from `global.equa2produ2nMap`.  
   - Flattens the participating molecules to a `ds_list` of atom structs (`Obj_array_to_atom_struct_list`).  
2. **Single-Molecule Search (`Get_map_of_PPLASMAS`)**:  
   - For each product molecule key, choose a “root” atom using `Find_search_root_atom_type_global`. This function cross-references the per-equation and per-molecule atom count priority queues to pick the scarcest atom type, reducing branching.  
   - `Extract_from` pulls all atoms of the chosen type from the available pool. For each root atom, `Update_PPLASMAS_with_one_root` performs a pseudo-recursive breadth expansion:  
     - Maintains arrays of atom structs (`oPPLASMAS`).  
     - `Update_PPLASMAS_pseudo_recur_unit` inspects four-direction neighbors (`cellUp/Dn/Lt/Rt`) via the `Cell` network.  
     - `Check_cell_struct_with_one_array_of_PPLASMAS` vets each neighbor: it must hold an unused atom whose label exists in the molecule’s required atom list.  
   - Each completed array contains one legal spatial embedding for that molecule. Deduplication ensures geometrically equivalent results collapse.  
3. **Display Encapsulation (`Encapsule_displayed_cell_map_of_PPLASMAS`)** wraps every atom in a `Capsuled_displayed_cell` struct recording the product molecule key and the index of the permutation that produced it. This metadata preserves grouping when the product arrays are later concatenated.  
4. **Multi-Molecule Combination (`Get_map_of_PPLAMMCDC`)**:  
   - Uses `Cnk_from` to compute combinations of the single-molecule permutations matching the required multiplicity (e.g., if the product needs two water molecules, choose every pair of distinct water embeddings).  
   - `Delete_repeated_capsulted_displayed_cell_in` drops combinations where the same atom is reused across molecules, ensuring conservation of matter.  
5. **Cross-Species Assembly (`Get_algorithm_final_list_of_array_1`)**:  
   - Performs a Cartesian merge over all species’ lists. Conceptually this is “multiply” the list-of-arrays matrices so that each resulting array contains every atom for all product molecules in a unique arrangement.  
   - `Delete_repeated_capsulted_displayed_cell_in` runs once more on the flattened results as a safety net.  
6. If any stage returns an empty list (no valid embeddings), the backend falls back to the next reactant combination.

### 4. Frontend Integration
1. `Algorithm_backend_return_constructor` stores the chosen reactant array, a single array from `algorithmFinalListOfArray` (selected with `[|0]` for deterministic randomness), and the product quantity map.  
2. `Algorithm_frontend_global` performs level rule checks:  
   - Fails early if any product is on the banned list.  
   - Updates counters (`Counter_update`, `Counter_draw`).  
   - Destroys consumed reactant instances and spawns `obj_disp` with the encapsulated product array.  
3. `obj_disp` decapsulates the array via `Decapsule_displayed_cell_map_of_SPLASMAS`, repaints the tilemaps using `dcMoleT`/`dcMoleI` to regroup atoms, and schedules removal after `PRODUCT_DISPLAY_TIME`.

## Why the Nesting Matters
- **ds_map → ds_list → array layering** mirrors the chemical semantics: equation → molecule → atom. Each layer’s operations (combination, deduplication, validation) work at the corresponding chemical granularity.  
- **Encapsulation step** decouples logical correctness (atom conservation) from presentation order; Godot can reuse the same idea by keeping physics/search data and render metadata separate.  
- **Priority-driven root selection** prunes search space by anchoring on rare atoms first, a heuristic worth porting to avoid explosive branching.  
- **Capsuled arrays in the return struct** provide a compact, serializable snapshot that downstream systems (counter updates, animations, networking) can consume without re-running the expensive search.  
- **sObjMoleList adjacency cache** transforms the board into a sparse interaction graph, dramatically reducing neighbor queries compared with scanning the entire grid each reaction.

These structures are the heart of Chemistris’ gameplay: they preserve chemical validity, enforce spatial constraints, and feed a deterministic display pipeline. Re-implementing them in Godot will require equivalent multilevel collections, well-defined ownership of atom resources, and clear conversion boundaries between simulation data and UI-facing payloads.
