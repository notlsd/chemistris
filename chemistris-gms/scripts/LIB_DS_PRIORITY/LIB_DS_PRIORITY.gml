/// LIB_DS_PRIORITY INCLUDES FUNCTIONS ABOUT DS_PRIORITY ///
///-----------------------------------------------------///
/// @Find_array_in_priority(_valArray, _iPriority)
/// @Ds_priority_find_min_array(_id)

/// @description Find the corresponding priority of array in priority
/// @param  {array} 	  _valArray
/// @param  {ds_priority} _iPriority
/// @return {ds_priority}
function Find_array_in_priority(_valArray, _iPriority) {
	
	var oPriority = ds_priority_create()
	
	for(var _i=0; _i<array_length(_valArray); _i++) {
		
		var pri = ds_priority_find_priority(_iPriority, _valArray[_i])
		
		if(!is_undefined(pri)) {
			ds_priority_add(oPriority, _valArray[_i], pri)
		}
	}
	
	return oPriority
}

/// @description Return an Array Contains All Min Value in Ds_priority
/// @param  {ds_priority} _input
/// @return {array}
function Ds_priority_find_min_array(_id) {
	
	if(0 >= ds_priority_size(_id))
		show_error("@Ds_priority_find_min_array | ERR! PRIORITY QUEUE EMPTY",true)

	// First Min
	
	var priorityID = ds_priority_create()
	ds_priority_copy(priorityID, _id)

	var iniVal = ds_priority_find_min(priorityID)
	var iniPri = ds_priority_find_priority(priorityID, iniVal)
	
	var array = []
	
	// Find min and delete, repeat
	
	while(Ds_priority_find_min_priority(priorityID) <= iniPri) {
	
		var minVal = ds_priority_find_min(priorityID)
		
		array_push(array, minVal)
		
		ds_priority_delete_value(priorityID, minVal)
	
	}
	
	return array
}

/// @description Transform N_Map to ds_riority
/// @param  {ds_map}		_nMap
/// @return {ds_priority}	    
function Mapn_to_ds_priority(_nMap) {
	
	var pid = ds_priority_create()
	
	var key = ds_map_find_first(_nMap)
	
	while(!is_undefined(key)) {
		ds_priority_add(pid, key, _nMap[?key])
		key = ds_map_find_next(_nMap, key)
	}
	
	return pid
}


/// @description Transform ds_priority to Mapn
/// @param  {ds_priority}		iPriority
/// @return {ds_map}	   
function Ds_priority_to_mapn(_iPriority) {
	
	var oPriority = ds_priority_create()
	ds_priority_copy(oPriority, _iPriority)
	
	var mapN = ds_map_create()
	
	while(!ds_priority_empty(oPriority)) {
		
		var value = Ds_priority_find_min_priority(oPriority)
		
		var key = ds_priority_delete_min(oPriority);
	
		ds_map_add(mapN, key, value)
	}
		
	return mapN
}

/// @description Return an Array Contains All Min Value in Ds_priority
/// @param  {ds_priority} _input
/// @return {array}
function Ds_priority_delete_min_array(priorityID) {
	
	if(0 >= ds_priority_size(priorityID))
		show_error("@Ds_priority_find_min_array | ERR! PRIORITY QUEUE EMPTY",true)

	// First Min

	var iniVal = ds_priority_find_min(priorityID)
	var iniPri = ds_priority_find_priority(priorityID, iniVal)
	
	var array = []
	
	// Find min and delete, repeat
	
	while(Ds_priority_find_min_priority(priorityID) <= iniPri) {
	
		var minVal = ds_priority_find_min(priorityID)
		
		array_push(array, minVal)
		
		ds_priority_delete_value(priorityID, minVal)
	
	}
	
	return array
}


/// @description Transform ds_priority to Mapn
/// @param  {ds_priority}		_iPriority
/// @param  {int}				_p
/// @return {array}	   
function Ds_priority_find_value_array(_id, _p) {
	
	var priorityID = ds_priority_create()
	ds_priority_copy(priorityID, _id)
	
	while(true) {
		
		var tPriority = Ds_priority_find_min_priority(priorityID)
		
		var tArray = Ds_priority_delete_min_array(priorityID)
		
		if(tPriority == _p)
			return tArray
		
		if(ds_priority_empty(priorityID))
			return undefined
	}
}

#region DS_PRIORITY

/// @description Return Min Priority Number of Ds_priority
/// @param  {ds_priority} _input
/// @return {int}
function Ds_priority_find_min_priority(_id) {
	return ds_priority_find_priority(_id, ds_priority_find_min(_id))
} 

#endregion

/// @description Return Min Priority Number of Ds_priority
/// @param  {ds_priority} _input
/// @return {int}
function Ds_priority_find_max_priority(_id) {
	return ds_priority_find_priority(_id, ds_priority_find_max(_id))
} 