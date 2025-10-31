/// LIB_DS_MAP_LIST INCLUDES FUNCTIONS TO PROCESS DS_MAP<DS_LIST> ///
//---------------------------------------------------------------///
// @Is_list_empty_in(_mapOfList)

/// @description Find the corresponding priority of array in priority
/// @param  {ds_map<ds_list>}    _mapOfList
/// @return {bool}

function Is_list_empty_in(_mapOfList){
    
    var key = ds_map_find_first(_mapOfList)
    
    while(!is_undefined(key)) {
        if(ds_list_empty(_mapOfList[? key]))
            return true
        
        key = ds_map_find_next(_mapOfList, key)
    }
    
    return false
}  
