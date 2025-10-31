/// @description DISPLAY ALGORITHM RETURN

#region DRAW ALGORITHM RETURN

var mapofSPLASMAS = Decapsule_displayed_cell_map_of_SPLASMAS(arrayDisplayedCapsuledCell, produ2nMap)

var moleKey = ds_map_find_first(mapofSPLASMAS)

while(!is_undefined(moleKey)) {
	for(var i_=0; i_<ds_list_size(mapofSPLASMAS[? moleKey]); ++i_) {
		for(var j_=0; j_<array_length(mapofSPLASMAS[? moleKey][| i_]); ++j_) {
			
			tilemap_set(Get_tilemap_element_from("lay_tileset_atom"), ds_map_find_value(global.atomTilemap, mapofSPLASMAS[? moleKey][| i_][j_].atomName), mapofSPLASMAS[? moleKey][| i_][j_].cellS.gridX, mapofSPLASMAS[? moleKey][| i_][j_].cellS.gridY)
		
			tilemap_set(Get_tilemap_element_from("lay_tileset_mole"), ds_map_find_value(global.moleTilemap, moleKey), mapofSPLASMAS[? moleKey][| i_][j_].cellS.gridX, mapofSPLASMAS[? moleKey][| i_][j_].cellS.gridY)
		}
		
		Draw_bond_inside_mole(Array_to_ds_list(mapofSPLASMAS[? moleKey][| i_]), global.moleTilemap[? moleKey])
	}
	
	moleKey = ds_map_find_next(mapofSPLASMAS, moleKey)
}

#endregion

#region LASTING TIME
alarm[0] = PRODUCT_DISPLAY_TIME
#endregion