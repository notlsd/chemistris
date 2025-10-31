/// LIB_ALGO_DISPLAY INCLUDE FUNCTIONS DISPLAY ALGORITHM RETURN RELATRD TO OBJ_DISP ///
/// -------------------------------------------------------------------------------///
/// @Capsuled_displayed_cell_constructor(_atomS, _moleType, _moleIndex)
/// @Encapsule_displayed_cell_map_of_PPLASMAS(_mapofPPLASMAS)
///	⇲⇲⇲	@Ds_map_to_ds_map_of_empty_ds_list(_map)	
///	⇲⇲⇲	@Delete_empty_array_in_map_of_list_of_array(_mapOfListOfArray)	

/// @description Construct Display Capsule Structure
/// @param {struct<atom>}	_atomS     [ Atom Struct ]
/// @param {string}    		_moleType  [ Mole Type ]
/// @param {int}       		_moleIndex [ Mole Index ]
function Capsuled_displayed_cell_constructor(_atomS, _moleType, _moleIndex) constructor {
	
	/* Display Capsule Changes the Lowest Level of Data Structure. 
	   Make it Easier for Display. */
	
	dcAtomS = _atomS;
	dcMoleT = _moleType;
	dcMoleI = _moleIndex
}

/// @description Encapsule capsuled_displayed_cell in map of PPLASMAS
/// @param  {ds_map<ds_list<array<struct<atom>>>}	mapofPPLASMCDC
/// @return {ds_map<ds_list<array<struct<capsuled_displayed_cell>>>>}
function Encapsule_displayed_cell_map_of_PPLASMAS(_mapofPPLASMAS) {
    
    /* mapofPPLASMAS = Map of Possible Product List of Array of Singular Molecular Atom Struct */
    
    /* mapofPPLASMCDC = Map of Possible Product List of Array of Singular Molecular Capsuled Displayed Cell */
    
    #region COMPLETELY COPY mapofPPLASMAS
    
	var mapofPPLASMCDC = ds_map_create()
	
	ds_map_copy(mapofPPLASMCDC, _mapofPPLASMAS)
	
	var moleKey = ds_map_find_first(mapofPPLASMCDC)
	
	while(!is_undefined(moleKey)) {
		mapofPPLASMCDC[? moleKey] = List_of_array_copy_by_value(_mapofPPLASMAS[? moleKey])
		moleKey = ds_map_find_next(mapofPPLASMCDC, moleKey)
	}
	
	#endregion
	#region TRANSFER mapofPPLASMAS TO mapofPPLASMCDC
	
    moleKey = ds_map_find_first(mapofPPLASMCDC)
        
    while(!is_undefined(moleKey)) {
        for (var _i = 0; _i < ds_list_size(mapofPPLASMCDC[? moleKey]); _i++) {
            for (var _j = 0; _j < array_length(mapofPPLASMCDC[? moleKey][|_i]); _j++) {
                mapofPPLASMCDC[? moleKey][|_i][_j] = new Capsuled_displayed_cell_constructor(_mapofPPLASMAS[? moleKey][|_i][_j], moleKey, _i)
            }
        }
        
        moleKey = ds_map_find_next(mapofPPLASMCDC, moleKey)
    }
    
    #endregion
    
    return mapofPPLASMCDC
}



/// @description Decapsule capsuled_displayed_cell in Map of SPLASMAS
/// @param  {array<struct<capsuled_displayed_cell>>}	_arrayCapsuledDisplayedCell
/// @param  {ds_map<ds_list<array<struct<atom>>>>}		_produ2nMap
/// @return {ds_map<ds_list<array<struct<capsuled_displayed_cell>>>>}
function Decapsule_displayed_cell_map_of_SPLASMAS(_arrayCapsuledDisplayedCell, _produ2nMap) {

    var mapofSPLASMAS = ds_map_create()
    
    // mapofSPLASMAS = Map of Selected Product List of Array of Single Molecular Atom Struct
    
    ds_map_copy(mapofSPLASMAS, _produ2nMap)
    
    mapofSPLASMAS = Ds_map_to_ds_map_of_empty_ds_list(mapofSPLASMAS)
        
    for(var _i=0; _i < array_length(_arrayCapsuledDisplayedCell); _i++){
        
        var moleList = mapofSPLASMAS[? (_arrayCapsuledDisplayedCell[_i].dcMoleT)]
		
		if(is_array(moleList[|(_arrayCapsuledDisplayedCell[_i].dcMoleI)]))
			array_push(moleList[|(_arrayCapsuledDisplayedCell[_i].dcMoleI)], _arrayCapsuledDisplayedCell[_i].dcAtomS)
        else
			ds_list_set(moleList, _arrayCapsuledDisplayedCell[_i].dcMoleI, [_arrayCapsuledDisplayedCell[_i].dcAtomS])
    }
    
    mapofSPLASMAS = Delete_empty_array_in_map_of_list_of_array(mapofSPLASMAS)
 
	return mapofSPLASMAS
}    

/// @description Transfer Map to Map of Empty List
/// @param  {ds_map}			_map
/// @return {ds_map<ds_list>}
function Ds_map_to_ds_map_of_empty_ds_list(_map) {
    
    var key = ds_map_find_first(_map)
    
    while(!is_undefined(key)) {
        
        _map[?key] = ds_list_create()
        
        key = ds_map_find_next(_map, key)
    }
        
    return _map 
}

/// @description Delete Empty Array in Map of List of Array
/// @param  {ds_map<ds_list<array>>>}	_mapOfListOfArray
/// @return {ds_map<ds_list<array>>>}
function Delete_empty_array_in_map_of_list_of_array(_mapOfListOfArray) {
	
	var key = ds_map_find_first(_mapOfListOfArray)
	
	while(!is_undefined(key)) {
		
		var _n = 0
		while (_n < ds_list_size(_mapOfListOfArray[? key])) {
			if (_mapOfListOfArray[? key][| _n] == 0)
				ds_list_delete(_mapOfListOfArray[? key], _n)
			else
				++_n
		}
		
		key = ds_map_find_next(_mapOfListOfArray, key)
	}
	
	return _mapOfListOfArray
}