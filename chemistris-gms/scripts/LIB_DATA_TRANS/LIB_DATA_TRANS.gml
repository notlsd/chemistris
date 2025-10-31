/// LIB_DATA_TRANS INCLUDES FUNCTIONS TRANSFORM DATA FROM ONE TYPE TO ANOTHER ///
//---------------------------------------------------------------------------///
// @Obj_array_to_atom_struct_list(_objArray)
// @Mapn_to_ds_priority(_nMap)
// @Mole_name_to_atom_list(_moleName)

/// @description Transform OBJ Array to Atom Struct List
/// @param  {array<object>}			_objArray
/// @return {ds_list<struct<atom>>}	    	  
function Obj_array_to_atom_struct_list(_objArray){
	
	var atomSList = ds_list_create()
	
	for(var _i = 0; _i < array_length(_objArray); _i++) {
		atomSList = Ds_list_merge(atomSList, _objArray[@_i].insideAtomSList)
	}
	
	return atomSList
}


/// @description Transform Molecular Name to List of Atoms
/// @param  {string}	_moleName
/// @return {ds_list<struct<atom>>} 	
function Mole_name_to_atom_list(_moleName) {
	
	if(is_undefined(ds_map_find_value(global.mole2atom2nMap, _moleName)))
		show_error("@Mole_name_to_atom_list | ERR! ILLEGAL INPUT: UNREGISTERD MOLE moleStr", true)
	
	else {
		var atomNMap = ds_map_find_value(global.mole2atom2nMap, _moleName)
		var atom = ds_map_find_first(atomNMap)
		
		var atomList = ds_list_create()
		
		while (!is_undefined(atom)) {
			repeat (ds_map_find_value(atomNMap, atom))
				ds_list_add(atomList, atom)
			
			atom = ds_map_find_next(atomNMap, atom)
		}
		
		ds_list_shuffle(atomList)
		
		return atomList
	}
}
