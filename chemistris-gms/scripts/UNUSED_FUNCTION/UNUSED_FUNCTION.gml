function Move_instance_to_upper_bond_after_ini(_insMole){
	
	var diff = abs(Get_lowest_grid_y_of_atom_struct(_insMole.insideAtomSList) - 0)
	
	_insMole.y = _insMole.y + diff*CELL_SIDE_PX
	
	
	
	return 	_insMole
}

function Get_lowest_grid_y_of_atom_struct(_insideAtomSList) {
	
	var lowestGridY = _insideAtomSList[|0].cellS.gridY
	
	for(var i_=1; i_<ds_list_size(_insideAtomSList); ++i_)
		lowestGridY = min(lowestGridY, _insideAtomSList[|i_])
	
	return lowestGridY
}

function Count_atom(_moleName) {
	
	var atomNMap = Get_atom_n_map_from_string(_moleName)
	
	atomNMap = Get_atom_n_map_from_string(_moleName)
	
	var atomKey = ds_map_find_first(atomNMap)
	
	var count = 0
		
	while(!is_undefined(atomKey)) {
		
		count += atomNMap[? atomKey]
		
		atomKey = ds_map_find_next(atomNMap, atomKey)
	
	}
	
	return count
	
}

/// @description Initialize New Mole Instance In Determined Random Position
/// @param {string}                _mole     [分子式]
/// @param {ds_grid<struct<cell>>} _cellGrid [背景版]
/// @param {int}                   _cellSideLength
/// @param {number}                _left
/// @param {number}                _right
/// @param {number}                _top
/// @param {number}                _down
/// @returns {object}              _moleID   [Created Molecular Instance ID] 
function Create_mole_instance_in_allowed_position(_moleName, _cellGrid, _cellSideLength, _left, _right, _top, _down) {
	
	// 确保随机生成的座标不在边界上（否则会出鬼畜 BUG）
	
	do {
		var iniX = random_range (_left, _right)
	}
	until (((iniX - _left) % _cellSideLength) != 0)
	
	do {
		var iniY = random_range (_top, _down)
	}
	until (((iniY - _top) % _cellSideLength) != 0)
	
	return Create_mole_instance_with_offset_y (_moleName, _cellGrid, iniX, iniY)
	
}

function Get_condition_symbol_from(_obj) {
	if(_obj.object_index == asset_get_index("obj_cond")) {
		switch (sprite_get_name(_obj.sprite_index)) {
			case "spr_heat":
				return "₳"
			case "spr_fire":
				return "₼"
			case "spr_light":
				return "¤"
			case "spr_elec":
				return "₪"
			case "spr_HT":
				return "¥"
			case "spr_HTHP":
				return "₩"
		}
	}
	else
		show_error("@Get_condition_symbol_from | ERR! NOT OBJ_COND",true)
}

function Counter_decoder_with_plus(_iExpr, _iArray) {
	
	var searchBeg = 1
	 
	var iExprEnd = string_length(_iExpr)
	
	while(string_pos_ext("+", _iExpr, searchBeg) != 0) {
		
		var searchEnd  = string_pos_ext("+", _iExpr, searchBeg)
		
		Level_table_counter_unit_decoder_of_PSWSIA(string_copy(_iExpr, searchBeg, searchEnd - searchBeg) , _iArray)
		
		searchBeg = searchEnd + 1
	}
		
	Level_table_counter_unit_decoder_of_PSWSIA(string_copy(_iExpr, searchBeg, iExprEnd - searchBeg), _iArray)
}

function Mole_name_to_atom_list_pre(_moleName) {
	
	if (string_lettersdigits(_moleName) != _moleName)
		show_error("@Mole_name_to_atom_list | ERR! ILLEGAL INPUT: UNEXPECTED MESSY CHAR", true)
	else if (!Is_uppercase(string_char_at(_moleName, 1)))
		show_error("@Mole_name_to_atom_list | ERR! ILLEGAL INPUT: ATOM ABBR BEGIN WITH UPPERCASE", true)
	else {
		
		var remnantmoleStr = _moleName
		var tmpList = ds_list_create()
		var atomList = ds_list_create()
		
		// Using H2O as example: The following code separate H2 / O, then put it into tmpList
		
		while (remnantmoleStr != "") {
			ds_list_add(tmpList, Read_string_until_upper(remnantmoleStr))
			remnantmoleStr = Delete_string_until_upper(remnantmoleStr)
		}

		for (var i = 0; i < ds_list_size(tmpList); i++) {
			
			//Decode H2
			if (string_digits(tmpList[|i]) != "") {
				for (var j = 0; j < real(string_digits(tmpList[| i])); j++) {
				    ds_list_insert(atomList, 0, string_letters(tmpList[| i]));
				}
			}
			
			//Decode O (Oxgen)
			else {
				ds_list_insert(atomList, 0, string_letters(tmpList[| i]));
			}	
		}
	}
	
	ds_list_destroy(tmpList)
	ds_list_shuffle(atomList)	
	return atomList
}



//Ds_priority_find_min_array(Find_array_in_priority(_valArray, _iPriority))

/// @description Return an Array Contains All Min Value in Ds_priority
/// @param  {array} 	  _valArray
/// @param  {ds_priority} _iPriority
/// @return {array}

function Get_min_of_array_in_priority(_valArray, _iPriority) {
	
	var oPriority = ds_priority_create()
	
	for(var _i=0; _i<array_length(_valArray); _i++) {
		
		var pri = ds_priority_find_priority(_iPriority, _valArray[_i])
		
		if(!is_undefined(pri)) {
			ds_priority_add(oPriority, _valArray[_i], pri)
		}
	}
	
	return Ds_priority_find_min_array(oPriority)
	
}