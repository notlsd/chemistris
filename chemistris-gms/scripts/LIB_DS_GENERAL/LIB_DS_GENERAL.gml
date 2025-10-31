/// LIB_DS_GENERAL INCLUDE FUNCTIONS WORKS ON DIFFERENT DATA STRUCTURE ///
/// ------------------------------------------------------------------///
/// @Is_exist_in(_value, _ds)
/// @Is_repeated(_ds)
/// @Random_from(_ds)
/// @Count(_val, _ds)
/// @Swap(_array, _i1, _i2)

/// @description Determin Is Value Exsit in Given Data Structure
/// @param  {}	   _val		[ Value Type Depends on Data ]   
/// @param  {}	   _ds	    [ DS Type Depends on Data Structure ]
/// @return {bool}
function Is_exist_in(_val, _ds) {
	if (is_array(_ds)) {
		for (var _i = 0; _i < array_length(_ds); _i++)
			if (_val == _ds[_i])
				return true
	
		return false
	}
	
	else if (ds_exists(_ds, ds_type_list)) {
		for (var j=0; j<ds_list_size(_ds); j++)
	    	if (_val == _ds[|j])
		    	return true 
    
    	return false 
	}	

	else 
		show_error("@Is_exist_in | ERR! UNIMPLEMENTED DATA STRUCTURE", true)
}

/// @description Determin Is There Any Value Repeated in Given Data Structure
/// @param  {}	   _ds	    [ DS Type Depends on Data Structure ]
/// @return {bool}
function Is_repeated(_ds) {
	if (is_array(_ds)) {
		array_sort(_ds, false)
		
		for (var _i = 0; _i < array_length(_ds) - 1 ; _i++)
			if (_ds[_i] == _ds[_i+1])
				return true
	
		return false
	}
	
	else 
		show_error("@Is_repeated | ERR! UNIMPLEMENTED DATA STRUCTURE", true)
}

/// @description Get Random Index in a Data Structure and then Return its Value
/// @param  {}	 _ds	  [ DS Type Depends on Data Structure ]
/// @return {}
function Random_from(_ds) {
	if (is_array(_ds)) {
		var arrayIndex = irandom(array_length(_ds)-1)
		return _ds[arrayIndex]
	}
	
	else if (ds_exists(_ds, ds_type_list)) {
		var listIdex = irandom(ds_list_size(_ds) - 1)
		return ds_list_find_value(_ds, listIdex)
	}	

	else 
		show_error("@Random_from | ERR! UNIMPLEMENTED DATA STRUCTURE", true)
}

/// @description Count Value Occurrence in Given Data Structure
/// @param  {}	   _val		[ Value Type Depends on Data ]   
/// @param  {}	   _ds	    [ DS Type Depends on Data Structure ]
/// @return {int}				  

function Count(_val, _ds) {
	
	var count = 0
	
	if(is_array(_ds))
		for(var _i=0; _i<array_length(_ds); _i++)
			if(_ds[_i] == _val)
				count++
	
	return count
	
}

/// @description Swap Index of Value of Given Data Structure
/// @param  {}		_ds	    [ DS Type Depends on Data Structure ]
/// @param  {int}	_i1
/// @param  {int}	_i2
/// @return {}
function Swap(_ds, _i1, _i2) {
    if(is_array(_ds)) {
	    var tmp1 = _ds[_i1]
	    var tmp2 = _ds[_i2]
	    
	    _ds[_i1]= tmp2
	    _ds[_i2]= tmp1
    }
    
    else 
		show_error("@Swap | ERR! UNIMPLEMENTED DATA STRUCTURE", true)
    
    return _ds
}
