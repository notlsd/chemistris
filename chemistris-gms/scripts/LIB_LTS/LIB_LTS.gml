/// LIB_LTS INCLUDES INITIALIZATION FUNCTIONS IN DIFFERENT STAGES ///
/// -------------------------------------------------------------///
///
/// @Game_ini_global()
/// @Level_room_ini_global()
/// @Level_data_ini_global(_lvName, _lvTableGrid)

function Array_shuffle_lts(_iArray){
	
	var list = Array_to_ds_list(_iArray)
	
	ds_list_shuffle(list)
	
	var oArray = Ds_list_to_array(list)
	
	return oArray
	
}

function Array_concat_lts(_a1, _a2){
	for(var _i=0; _i<array_length(_a2); _i++){
		array_push(_a1, _a2[_i])
		
	}
	
	return _a1
}