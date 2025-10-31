/// LIB DATA_N_MAP INCLUDES FUNCTIONS READING CSV FILE TO VIROUS MAP OF MAP///
//------------------------------------------------------------------------///
// @Check_consistency(_equaReactantNMap, _equaProductNMap)
// @Add_mole_atom_n_map(_csv, _moleAtomNMap)
// @Get_equa_mole_n_map_from(_csv)
// @Get_equa_atom_n_map_from(_equaMoleNMap)
// @Get_atom_n_map_from_map(_moleNMap)
// @Get_atom_n_map_from_string(_moleName)

/// @description Check If Equation Is Balanced and Then Return Equa->Atom->N
/// @param  {ds_map<ds_map>} _equaReactantNMap [ Equa->ReactantMole->N ]
/// @param  {ds_map<ds_map>} _equaProductNMap  [ Equa->ProductMole->N ]
/// @return {ds_map<ds_map>}				  [ Equa->Atom->N ]
function Check_consistency(_equaReactantNMap, _equaProductNMap) {
	
	// Also check if ds_map_keys_to_array / ds_map_values_to_array is coresponding
	
	var equaAtomNMapR = Get_equa_atom_n_map_from(_equaReactantNMap)
	var equaAtomNMapP = Get_equa_atom_n_map_from(_equaProductNMap)
	
	var equaKeyArrayR = ds_map_keys_to_array(equaAtomNMapR)
	var equaKeyArrayP = ds_map_keys_to_array(equaAtomNMapP)
	
	if (!array_equals(equaKeyArrayR, equaKeyArrayP))
		show_error ("@Check_consistency | FATAL ERR! EQUATION RT_CODE UNMATCH", true)
	
	var equaValueArrayR = ds_map_values_to_array(equaAtomNMapR)
	var equaValueArrayP = ds_map_values_to_array(equaAtomNMapP)
	
	for(var _i=0; _i<array_length(equaValueArrayP); _i++) {
	
		var atomKeyArrayR = ds_map_keys_to_array(equaValueArrayR[_i])
		var atomKeyArrayP = ds_map_keys_to_array(equaValueArrayP[_i])
		
		var atomValueArrayR = ds_map_values_to_array(equaValueArrayR[_i])
		var atomValueArrayP = ds_map_values_to_array(equaValueArrayP[_i])
		
		if (!array_equals(atomKeyArrayR, atomKeyArrayP))
			show_error("DO! NOT! USE! DEBUG! MODE! | @Check_consistency | FATAL ERR! ATOM TYPE UNMATCH @REACTANT = " + equaKeyArrayR[_i] + " @PRODUCT = " + equaKeyArrayP[_i], true)
			
		if (!array_equals(atomValueArrayR, atomValueArrayP))
			show_error("DO! NOT! USE! DEBUG! MODE! | @Check_consistency | FATAL ERR! ATOM RT_QUANTITY UNMATCH @REACTANT = " + string(equaKeyArrayR[_i]) + " @PRODUCT = " + string(equaKeyArrayP[_i]), true)
	
	}
	
	show_debug_message("SELF TEST PASSED: TABLE FORMAT CORRECT")
	show_debug_message("SELF TEST PASSED: DS_MAP_KEYS_/_VALUES_TO ARRAY() CORRESPONDS")
	
	return equaAtomNMapP
	
	//ds_map
	
	//读取，变换，
	//相等删除，ds_map 为空，返回

}

/// @description .CSV To Mole->Atom->N
/// @param {string} _csv [ CSV File Name (.csv Must Included) ]	
/// @param {ds_map}	_moleAtomNMap
/// @return {ds_map<ds_map>}  
function Add_mole_atom_n_map(_csv, _moleAtomNMap) {
	
	var dataGrid = load_csv(_csv)
	
	if ( "RT_MOLECULE" == dataGrid[# RT_MOLECULE, 0] ) {
		for (var _i = 1; _i < ds_grid_height(dataGrid); _i++) {
			if(Is_condtion_symbol(dataGrid[# RT_MOLECULE, _i])) 
				continue
			
			else {
				if (ds_map_exists(_moleAtomNMap, dataGrid[# RT_MOLECULE, _i]))
			 			continue
			 		else
			 			ds_map_add_map(_moleAtomNMap, dataGrid[# RT_MOLECULE, _i], Get_atom_n_map_from_string(dataGrid[# RT_MOLECULE, _i]))
			}
		}
		
		return _moleAtomNMap
	}
	
	else
		show_error ("@Add_mole_atom_n_map | FATAL ERR! ILLEGAL TABLE HEADER", true)
}

function Clean_string(_s) {
	if(string_lettersdigits(_s) == "")
		return _s
	else
		return string_lettersdigits(_s)
}

/// @description .CSV To Equa->Mole->N
/// @param  {string} _csv [ CSV File Name (.csv Must Included) ]
/// @return {ds_map<ds_map>}  
function Get_equa_mole_n_map_from(_csv) {
	
	var dataGrid = load_csv(_csv)
	
	// Replace default "" to 1
	for (var _n = 1; _n < ds_grid_height(dataGrid); _n++) {
		 
		 dataGrid[# RT_QUANTITY, _n] = String_digit_real(dataGrid[# RT_QUANTITY, _n])
		 
		 if(dataGrid[# RT_QUANTITY, _n] == "")
			dataGrid[# RT_QUANTITY, _n] = 1
			
	}	
	
	if ( "RT_CODE" == dataGrid[# RT_CODE, 0] && "RT_MOLECULE" == dataGrid[# RT_MOLECULE, 0] && "RT_QUANTITY" == dataGrid[# RT_QUANTITY, 0] ) {
	     
		var equaMoleNMap = ds_map_create()
		
		for (var _i = 1; _i < ds_grid_height(dataGrid); _i++) {
			if (!ds_map_exists(equaMoleNMap, dataGrid[# RT_CODE, _i])) {
				ds_map_add_map(equaMoleNMap,  dataGrid[# RT_CODE, _i], Create_map_with_ini(Clean_string(dataGrid[# RT_MOLECULE, _i]), dataGrid[# RT_QUANTITY, _i]))
			}
			
			else {
				ds_map_add(equaMoleNMap[? dataGrid[# RT_CODE, _i]], Clean_string(dataGrid[# RT_MOLECULE, _i]),  dataGrid[# RT_QUANTITY, _i])
			}
		}
		
		return equaMoleNMap			
	}
	
	else
		show_error("@Get_equa_mole_n_map_from | FATAL ERR! ILLEGAL TABLE HEADER", true)
}

/// @description EquationCode->Mole->N To EquationCode->Atom->N  
/// @param  {ds_map<ds_map>} _equaMoleNMap
/// @return {ds_map<ds_map>} 
function Get_equa_atom_n_map_from(_equaMoleNMap) {
		
	var equaAtomNMap = ds_map_create()
	
	var equaKey = ds_map_find_first(_equaMoleNMap)
	
	while (!is_undefined(equaKey)) {
		
		ds_map_add_map(equaAtomNMap, equaKey, Get_atom_n_map_from_map(_equaMoleNMap[? equaKey]))
		
		equaKey = ds_map_find_next(_equaMoleNMap, equaKey)
	}
	
	return equaAtomNMap
}

/// @description Mole->N To Atom->N  
/// @param  {ds_map<ds_map>} _moleNMap 
/// @return {ds_map<ds_map>} 
function Get_atom_n_map_from_map(_moleNMap) {
	
	var atomNMap = ds_map_create()
	
	var moleKey = ds_map_find_first(_moleNMap)
	
	// 可以把钱号单独提取出来做一个函数
	
	while (!is_undefined(moleKey)) {
		// switch (moleKey) {
		// 	case "₳":
		// 	case "₼":
		// 	case "¤":
		// 	case "₪":
		// 	case "¥":
		// 	case "₩":
		// 	case "@":
		// 		moleKey = ds_map_find_next(_moleNMap, moleKey)
		// 		continue
			
			if (Is_condtion_symbol(moleKey)) {
				moleKey = ds_map_find_next(_moleNMap, moleKey)
				continue
			}
				
			//default:
			else {
		
				var remainMole = moleKey
				
				do {
					
					var subMole = Read_string_until_upper(remainMole)
					var remainMole = Delete_string_until_upper(remainMole)
					
					//show_debug_message("submole = " +subMole)
					//show_debug_message("remainMole = " +remainMole)
					
					if (!ds_map_exists(atomNMap, string_letters(subMole)))
						ds_map_add(atomNMap, string_letters(subMole), String_digit_real(subMole) * _moleNMap[? moleKey])
					else
						atomNMap[? string_letters(subMole)] += (String_digit_real(subMole) * _moleNMap[? moleKey])
					
				} until ("" == remainMole)
				
				moleKey = ds_map_find_next(_moleNMap, moleKey)
			}
		}
	//} 
	return atomNMap
}

/// @description Molecular moleStr To Atom->N
/// @param  {string} _moleName	[ Molecular moleStr String ]
/// @return {ds_map}  
function Get_atom_n_map_from_string(_moleName) {

	var atomNMap = ds_map_create()
	
	var remainMole = _moleName
	
	do {
		
		var subMole = Read_string_until_upper(remainMole)
		var remainMole = Delete_string_until_upper(remainMole)
	
		ds_map_add(atomNMap, string_letters(subMole), String_digit_real(subMole))
		
	} until ("" == remainMole)
	
	return atomNMap
	
}