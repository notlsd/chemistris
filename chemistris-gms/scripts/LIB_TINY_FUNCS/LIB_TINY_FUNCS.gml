/// LIB_TINY_FUNCTIONS INCLUDE VARIOUS TINY FUNCS FOR DIFFERENT OBJECTIVE ///
//-----------------------------------------------------------------------///
// #ARRAY
/// @Array_copy_by_value(_input)
/// @Array_find_value_first
/// @Swap_last_with_first_noone(_array)
//
// #DS_LIST
/// @Ds_list_delete_single_value(_list, _val)
/// @Ds_list_delete_mutiple_value(_list, _val)
/// @Ds_list_merge(_l1, _l2)
//
// #DS_MAP
/// @Create_map_with_ini(_key, _value)
/// @Is_map_key_exist(_map, _key)
//
// #DS_PRIORITY
/// @Ds_priority_find_min_priority(_id)
//
// #MATH
/// @Is_in_close_interval(_x, _v1, _v2)
//
// #TILEMAP
/// @Get_tilemap_element_from(_layer) 
//
// #STRING
/// @Read_string_until_upper(_string)
/// @Delete_string_until_upper(_string)
/// @String_digit_real(_string)

#region ARRAY

/// FXXK "Enable Copy on Write Behaviour of Arrays" @GameOptions @Main
/// Thus Result in Both a = b & array_copy(a, b) Is Passed by Address !

/// @description Copy Array by Value
/// @param  {array} _input
/// @return {array}
function Array_copy_by_value(_input) {
	var output = array_create(array_length(_input))
	
	for (var _i = 0; _i < array_length(output); _i++) 
	   output[_i] = _input[_i]
	
	return output
}

/// @description Find the First Index of Given Value
/// @param  {array} _input
/// @param  {}		_val	[ Value Type Depends on Data ]
/// @return {int}
/// @return {undefined}

function Array_find_value_first(_array, _val) {
	for(var _i=0; _i<array_length(_array); _i++)
		if(_array[_i] == _val)
			return _i
	
	return undefined
}

/// @description Search the first noone and then swap with the last value 
/// @param  {array}	  _array  
/// @return {array}	 
function Swap_last_with_first_noone(_array) {
	
	var noone1st = Array_find_value_first(_array, noone)
	
	if(is_undefined(noone1st))
		return _array
		
	else {
		_array = Swap(_array, noone1st, array_length(_array)-1)
		return _array
	}	
}

#endregion
#region DS_LIST

/// @description Delete a Sinle Value in a List
/// @param  {ds_list}	_list
/// @param  {}			_val
/// @return {void}	    	   
function Ds_list_delete_single_value(_list, _val) {
	
	var pos = ds_list_find_index(_list, _val)
	
	ds_list_delete(_list, pos)
	
	//return _list
	return
}

/// @description Delete Mutiple Values in a List
/// @param  {ds_list}	_list
/// @param  {}			_val
/// @return {void}	  
function Ds_list_delete_mutiple_value(_list, _val) {
	
	while(ds_list_find_index(_list, _val) != -1) {
		Ds_list_delete_single_value(_list, _val)
	}
	
	// Everything deleted, put back one
	//ds_list_add(_list, _val)
	
	return
}


/// @description Merge Two Lists and Return 
/// @param  {ds_list}	_l1
/// @param  {ds_list}	_l2
/// @return {ds_list}
function Ds_list_merge(_l1, _l2) {
	for(var _i=0; _i<ds_list_size(_l2); _i++)
		ds_list_add(_l1, _l2[|_i])
	
	return _l1
}

#endregion
#region DS_MAP

/// @description Create Map with Initial Key-Value Pair
/// @param {string} _key
/// @param {}		_value [ Value Type Depends on Map's Data ]
/// @returns {ds_map}

function Create_map_with_ini(_key, _value) {
	
	var map = ds_map_create()
	
	ds_map_add(map, _key, _value)
	
	return map
}

/// @description Is Key Exist in Map
/// @param {ds_map} _map
/// @param {}		_key [ Value Type Depends on Map's Data ]
/// @returns {bool}

function Is_map_key_exist(_map, _key) {
	
	var nowKey = ds_map_find_first(_map)
	
	while (!is_undefined(nowKey)) {
		
		if(_key == nowKey)
			return true
		
		nowKey = ds_map_find_next(_map, nowKey)
	}
	
	return false
}

#endregion
#region MATH

/// @description Determine Wether Input Is in Given Close Interval
/// @param {number} _x  
/// @param {number} _v1 [ v1 >= v2 /  v1 <= v2 均可 ]
/// @param {number} _v2 
/// @return {bool} 		

function Is_in_close_interval (_x, _v1, _v2) {

	var low = _v1 
	var high = _v2

	if (_v1 > _v2) {
		high = _v1 
		low = _v2
	}

	return _x >= low && _x <= high
}

#endregion
#region TILEMAP

/// @description Get Tilemap Element ID from Layer Name
/// @param {string} _layer 
/// @returns {layer_tilemap} tilemapElementID

function Get_tilemap_element_from (_layer) {
	return layer_tilemap_get_id(layer_get_id(_layer))
}

#endregion 
#region STRING

/// @description Read String Until Next Uppercase Char
/// @param {string} _string
/// @return {string} 

function Read_string_until_upper(_string) {

	var readString = ""
	var remainString = _string

	do {
	    readString += string_char_at(remainString, 1)
		remainString = string_delete(remainString, 1, 1)
		
	} until (Is_upper_or_empty(string_char_at(remainString, 1)));
	
	return readString
}

/// @description Delete Char in a String Until Next Uppercase Char
/// @param {string} _string
/// @return {string} 

function Delete_string_until_upper(_string) {
	
	var remainString = _string
	
	do {
		remainString = string_delete(remainString, 1, 1)
	
	} until (Is_upper_or_empty(string_char_at(remainString, 1)));
	
	return remainString
}

/// @description Transform String-Format-Digit to Int-Format-Digit
/// @param  {string} _string
/// @return {int} 

function String_digit_real(_string) {
	
	var digits = string_digits(_string)
	
	if ("" == digits) 
		return 1
	
	return real(digits)
}

#endregion

function Ds_list_to_array (_iList) {
	
	var oArray = []
	
	for(var i_=0; i_<ds_list_size(_iList); ++i_)
		array_push(oArray, _iList[| i_])
		
	return oArray
}

function Array_to_ds_list (_iArray) {
	
	var oList = ds_list_create()
	
	for(var i_=0; i_<array_length(_iArray); ++i_)
		ds_list_add(oList, _iArray[i_])
		
	return oList
}


/// @description Find First Capital Position
/// @param  {string}	_iStr	[ Input String ]
/// @return {int}				[ Index of the 1st Capitalized Letter ]
/// @return {undefined}			[ No Capitalized Letter]

function Find_1st_capital_position(_iStr) {
    
    var strLength = string_length(_iStr);
    
    for (var _i=1; _i<=strLength; _i++) {
    	
        var char = string_char_at(_iStr, _i);
        
        if (ord(char) >= 65 && ord(char) <= 90)
            return _i;
    }
    
    return undefined;
}