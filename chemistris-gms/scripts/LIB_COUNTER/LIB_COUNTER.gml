/// LIB_COUNTER INCLUDE FUNCTIONS RELATED TO COUNTER ///
/// ------------------------------------------------///
///
/// @function Counter_update(_algoBackendReturnS, _lvCounterArray)
/// @function Counter_draw(_layerTilesetName, _lvCounterArray)

/// @description Update Data Array of Counter
/// @param  {struct<algo_backend_return>}  _algoBackendReturnS
/// @param  {array<string>} 			   _lvCounterArray
/// @return {void} 			   _lvCounterArray
function Counter_update(_algoBackendReturnS, _lvCounterArray) {
	
	// Confirm do not modify the original global public produ2nMap
	var produ2nMap = ds_map_create()
	ds_map_copy(produ2nMap, _algoBackendReturnS.produ2nMap)
	
	// Delete when found		
	while(array_length(_lvCounterArray) >0 && Is_map_key_exist(produ2nMap, _lvCounterArray[0])) {

		var moleN = ds_map_find_value(produ2nMap, _lvCounterArray[0])
		
		if(moleN == "" || moleN == 1) {
			ds_map_delete(produ2nMap, _lvCounterArray[0])
		}
		else {
			var moleKey = _lvCounterArray[0]
			produ2nMap[? moleKey] -= 1
		}
		
		array_delete(_lvCounterArray, 0, 1)
	} 
		
	return _lvCounterArray
}

/// @description Update Data Array of Counter
/// @param  {string} 			_layerTilesetName
/// @param  {array<string>}		_lvCounterArray
/// @return {void} 			   
function Counter_draw(_layerTilesetName, _lvCounterArray) {
	
	// Clean Loop
	for(var _i=0; _i<COUNT_DISPLAY_LENGTH; _i++) {
		
		var gridX = COUNT_DISPLAY_INI_GRID_X + _i mod COUNT_DISPLAY_MAX_IN_LINE
		var gridY = COUNT_DISPLAY_INI_GRID_Y + _i div COUNT_DISPLAY_MAX_IN_LINE
		
		tilemap_set(Get_tilemap_element_from(_layerTilesetName), TRANSPARENT, gridX, gridY)
		/* WARNING INGORED */
	}
	
	// Redraw Loop
	for(var _i=0; _i<array_length(_lvCounterArray); _i++) {
		
		var gridX = COUNT_DISPLAY_INI_GRID_X + _i mod COUNT_DISPLAY_MAX_IN_LINE
		var gridY = COUNT_DISPLAY_INI_GRID_Y + _i div COUNT_DISPLAY_MAX_IN_LINE
		
		tilemap_set(Get_tilemap_element_from(_layerTilesetName), ds_map_find_value(global.moleTilemap, _lvCounterArray[_i]), gridX, gridY)
	}
}

/// @description Update Data Array of Counter
/// @param  {string} 			_layerTilesetName
/// @param  {array<string>}		_lvCounterArray
/// @return {void} 			   
function Banned_draw(_layerTilesetName, _lvBannedArray) {
	
	// Redraw Loop
	
	var gridX = BANNED_DISPLAY_GRID_X
	var gridY = BANNED_DISPLAY_GRID_Y
	
	for(var _i=0; _i<array_length(_lvBannedArray); _i++) {
		
		tilemap_set(Get_tilemap_element_from(_layerTilesetName), ds_map_find_value(global.moleTilemap, _lvBannedArray[_i]), gridX, gridY)
		
		gridX += 2
	}
}