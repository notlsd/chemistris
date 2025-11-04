extends Node
class_name ReactantFinder

const Models := preload("res://scripts/gameplay/reaction_models.gd")

func find_reactant_combinations(trigger_id: int, requirements: Models.ReactionRequirements, grid_state: Models.ReactionGridState) -> Array:
	if trigger_id == -1:
		push_warning("ReactantFinder: trigger_id not provided")
		return []
	var start_molecule := grid_state.get_molecule(trigger_id)
	if start_molecule == null:
		push_warning("ReactantFinder: trigger molecule %s not found" % trigger_id)
		return []
	if requirements.molecule_counts.get(start_molecule.molecule_code, 0) <= 0:
		return []
	var results: Array = []
	var selected_ids: Array[int] = [trigger_id]
	var counts: Dictionary = {start_molecule.molecule_code: 1}
	var visited_sets := {}
	_backtrack(selected_ids, counts, requirements, grid_state, results, visited_sets)
	return results

func _backtrack(selected_ids: Array[int], counts: Dictionary, requirements: Models.ReactionRequirements, grid_state: Models.ReactionGridState, results: Array, visited_sets: Dictionary) -> void:
	if requirements.satisfied_by(counts):
		var sorted := selected_ids.duplicate()
		sorted.sort()
		var key := PackedInt32Array(sorted).hash()
		if not visited_sets.has(key):
			visited_sets[key] = true
			results.append(selected_ids.duplicate())

		return
	var frontier := _collect_neighbor_candidates(selected_ids, grid_state)
	for candidate_id in frontier:
		if candidate_id in selected_ids:
			continue
		var candidate := grid_state.get_molecule(candidate_id)
		if candidate == null:
			continue
		var current_count := counts.get(candidate.molecule_code, 0)
		var target_count := requirements.molecule_counts.get(candidate.molecule_code, 0)
		if current_count >= target_count:
			continue
		selected_ids.append(candidate_id)
		counts[candidate.molecule_code] = current_count + 1
		_backtrack(selected_ids, counts, requirements, grid_state, results, visited_sets)
		selected_ids.pop_back()
		if current_count == 0:
			counts.erase(candidate.molecule_code)
		else:
			counts[candidate.molecule_code] = current_count

func _collect_neighbor_candidates(selected_ids: Array[int], grid_state: Models.ReactionGridState) -> Array[int]:
	var candidates: Array[int] = []
	var seen: Dictionary = {}
	for id in selected_ids:
		for neighbor_id in grid_state.neighbors_of(id):
			if seen.has(neighbor_id):
				continue
			seen[neighbor_id] = true
			candidates.append(neighbor_id)
	return candidates
