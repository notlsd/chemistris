/// LIB_ALGO_REACTANT INCLUDE FUNCTIONS RELATED TO REACTANT SUB ALGORITHM ///
/// ---------------------------------------------------------------------///
/// @Get_reactant_obj_list_of_array(_inID, _reactantNameArray)
/// ⇲⇲⇲ @Update_reactant_obj_list_of_array_recursion(_iROLA)
/// ⇲⇲⇲⇲⇲⇲⇲ @Merge_SOBJ_mole_list_from(_reactantObjArray)
/// 
/// @Delete_unmatched_mole_obj_array_with(_moleObjListOfArray, _refMoleNameArray) 	

/// @description Algorithm to Find Reactant Obj List of Array
/// @param  {instance}  _inID             [ Instance ID to Initialize Algorithm ]
/// @param  {array}     _reactantNameArray [ Inpput Reactant String Array ]
/// @return {ds_list<array>}               [ List of Possible Reactant Obj Array ]
function Get_reactant_obj_list_of_array(_inID, _reactantNameArray) {

    /* oROLA = Output Reactant OBJ List of Array, which is a list of arraies consists all posssible reactant combination. Each array is a possible reactant combination. */
    
    var oROLA = ds_list_create()
    
    var searchLayers = array_length(_reactantNameArray)
    
    ds_list_add(oROLA, array_create(searchLayers, noone))
    
    oROLA[|0][@0] = _inID

    
    // First Falling Molecule. Returned oROLA is not acceptable.
    if (ds_list_size(_inID.sObjMoleList) == 0) 
        return oROLA
	
	// Recursion for Other Circumstance
	else
		return Update_reactant_obj_list_of_array_recursion(oROLA)
}

/// @description Expand Reactant Obj List of Array by Recursion
/// @param  {ds_list<array>}   _iROLA	[ Input Reactant Obj List of Array ]
/// @return {ds_list<array>}               
function Update_reactant_obj_list_of_array_recursion(_iROLA) {
	
	// This function is the core of reactant sub-algorithm
	var pos = Array_find_value_first(_iROLA[|0], noone)
	
	// Cannot find available position, algorithm terminated
	if(is_undefined(pos))
		return _iROLA
    
    // Update one round of surrounding obj mole in oROLA
    var oROLA = ds_list_create()
	
	// The lack of this loop on previous version results in a bug that _iROLA is incompletely iterated
	for (var _k=0; _k<ds_list_size(_iROLA); _k++) {
    
    	// Merge one round of surrounding obj mole in iROLA
		var sObjMoleListMerged = Merge_SOBJ_mole_list_from(_iROLA[|_k]);
    
    	// Update result of one case
	    for (var _i=0; _i<ds_list_size(sObjMoleListMerged); _i++) {
	        
			// var oROLArrayUpdate = Array_copy_by_value(_iROLA[|_k]);
			
			var oROLArrayUpdate = []
			
			array_copy(oROLArrayUpdate, 0, _iROLA[|_k], 0, array_length(_iROLA[|_k]))
        
			oROLArrayUpdate[@pos] = sObjMoleListMerged[|_i];
        
			ds_list_add(oROLA, oROLArrayUpdate);
		}
	}
	
	// Delete repeated array in each step
	Sort_and_delete_repeated_array_in_4(oROLA)
    	
    return Update_reactant_obj_list_of_array_recursion(oROLA)
}

/// @description Merge surrounding obj mole list from reactant obj array
/// @param  {array<obj_mole>}	_reactantObjArray
/// @return {ds_list<obj_mole>} [ SOBJ mole list of the whole reactant obj array ] 
function Merge_SOBJ_mole_list_from(_reactantObjArray) {
	
	var sObjMoleListMerged = ds_list_create()
	
	// 1st round: merge everything
	var _i = 0
	while(_reactantObjArray[@_i] != noone) {
		sObjMoleListMerged = Ds_list_merge(sObjMoleListMerged, _reactantObjArray[@_i].sObjMoleList)
		_i++
	}
	
	// 2nd round: Delete repeated
	var _j = 0
	while(_reactantObjArray[@_j] != noone) {
		Ds_list_delete_mutiple_value(sObjMoleListMerged, _reactantObjArray[@_j])
		_j++
	}
	
	return sObjMoleListMerged
} 

/// @description Delete Unmatched MOLE_OBJ Array with Reference Molecular Name Array
/// @param  {ds_list<array<object<mole>>>}  _moleObjListOfArray
/// @param  {array<string>}                 _refMoleNameArray
/// @return {ds_list<array>}      
function Delete_unmatched_mole_obj_array_with(_moleObjListOfArray, _refMoleNameArray) {
    
    // Sorting to compare
    for (var _i = 0; _i < ds_list_size(_moleObjListOfArray); _i++) {
        array_sort(_moleObjListOfArray[|_i], false)     
    }
    
    array_sort(_refMoleNameArray, false)
    
	var returnListOfArray = ds_list_create()
	
    // Delete Unmatch Molecular Combination
    var findingArray = array_create(array_length(_refMoleNameArray))
    
    var _j = 0
    while (_j < ds_list_size(_moleObjListOfArray)) {
        for (var _k=0; _k< array_length(_moleObjListOfArray[|_j]); _k++) {
            findingArray[_k] = _moleObjListOfArray[|_j][_k].moleType
        }
        
        array_sort(findingArray, false)
        
        if (array_equals(findingArray, _refMoleNameArray))
            ds_list_add(returnListOfArray, _moleObjListOfArray[|_j])
		
        _j++
    }
    
    return returnListOfArray
}
