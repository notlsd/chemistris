/// @description Update sObjMoleList from specified Cell Struct & Self ID
/// @param {struct<cell>} _cellS   [ Targeted Cell Struct ]
/// @param {instance}	  _selfMoleID   [ Self Mole ID ]
/// @param {ds_list}      _sObjMoleList [ Surrending obj_mole List ]
/// @return {void}  

function Update_s_obj_mole_list_from(_cellS, _selfMoleID, _sObjMoleList) {
    
	//检查空间是否存在
    if (_cellS == noone) {  
        return
	}
	
	// else if 会出bug，因为 _cellS 根本不存在
	//检查空间是否被占用
	if (_cellS.atomS == noone) {
        return
	}
	
	//检查是否为自己
    else if (_cellS.atomS.moleID == _selfMoleID) {
        return
	}
	
	//检查是否在列表里
    else if (Is_exist_in(_cellS.atomS.moleID, _sObjMoleList)) {
        return
	}
	
	//建立双向链接！
    else {
        ds_list_add(_sObjMoleList, _cellS.atomS.moleID)
        var tmp = variable_instance_get(_cellS.atomS.moleID, "sObjMoleList");  
        ds_list_add(tmp, _selfMoleID)
	}
}

/// @description Get Equation-Mole Array 
/// @param	{string}		 _equaCode
/// @param  {ds_map<ds_map>} _equaMoleNMap
/// @param	{bool}			 _isCondIncluded
/// @return {array}	

function Get_equa_mole_array(_equaCode, _equaMoleNMap, _isCondIncluded) {
	
	if(is_undefined(ds_map_find_value(_equaMoleNMap, _equaCode)))
		show_error("@Get_equa_mole_array | ERR! ILLEGAL INPUT: UNREGISTERD EQUATION RT_CODE", true)
	
	else {
		
		var moleNMap = ds_map_find_value(_equaMoleNMap, _equaCode)
		var mole = ds_map_find_first(moleNMap)
		var equaMoleArray = []
		
		while (!is_undefined(mole)) {
			if(!_isCondIncluded) {
				if(Is_condtion_symbol(mole)) {
					mole = ds_map_find_next(moleNMap, mole)
					continue
				}
			}
			
			repeat (ds_map_find_value(moleNMap, mole))
				array_push(equaMoleArray, mole)
			
			mole = ds_map_find_next(moleNMap, mole)
		}
		
		array_sort(equaMoleArray, true)
		
		return equaMoleArray
	}
}
