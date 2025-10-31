/// @description Show Array List Data
/// @param {ds_list<array>}		_listOfArray 

function Debuger_list_of_array(_listOfArray) {
	
	// show_debug_message("CALL OF ALGORITHM")
	
	var tmp = ""
	
	for (var _li = 0; _li < ds_list_size(_listOfArray); _li++) {
		for (var _ai = 0; _ai < array_length(_listOfArray[|_li]); _ai++) {
			//var test1 = _listOfArray[|_li][@_ai].toString()
			//var test2 = string(test1[|_li])
			tmp += string(_listOfArray[|_li][@_ai]/*.dcAtomS*/)
			tmp += " , "
		 }
		 show_debug_message(tmp)
		 tmp = ""
	}
	
	show_debug_message("")
}

//function Debuger_map_of_list_of_array(_mapofListofArray, _name) {
	
//	show_debug_message(_name)
	
//	var moleKey = ds_map_find_first(_mapofListofArray)

//	while(!is_undefined(moleKey)) {
		
//		show_debug_message(moleKey)
		
//		Debuger_list_of_array(_mapofListofArray [? moleKey])
		
//		moleKey = ds_map_find_next(_mapofListofArray, moleKey)
//	}
	
//}	



function Debuger_atom_search_root_G(_EPNM) {
	for(var eKey = ds_map_find_first(_EPNM); !is_undefined(eKey); eKey = ds_map_find_next(_EPNM, eKey)) 
		for(var pkey = ds_map_find_first(_EPNM[?eKey]); !is_undefined(pkey); pkey = ds_map_find_next(_EPNM[?eKey], pkey)) 
			show_debug_message("[EQUA: " + eKey + "] [MOLE:" + pkey + "] [ROOT: " + Find_search_root_atom_type_global(eKey, pkey))
}


