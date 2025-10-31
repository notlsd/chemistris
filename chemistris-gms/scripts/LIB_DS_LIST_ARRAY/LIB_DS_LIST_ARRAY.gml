/// LIB_LIST_ARRAY_INCLUDES_FUNCTIONS_TO_PROCESS_DS_LIST<ARRAY> ///
//-------------------------------------------------------------///
// NOTE FOR PASSING FUNCTION AS ARGUMENT IS HERE              ///
//-----------------------------------------------------------///
// @Cascade_to_array(_listOfArray)
// @List_of_array_copy_by_value(_listOfArray)
// @Delete_incompleted_array_in(_listOfArray)
// @Sort_and_delete_repeated_array_in_4(_listOfArray)
// @Sort_and_delete_repeated_value_in(_listOfArray)

/// @description Cascade List of Array to a Single Array
/// @param  {ds_list<array>} _listOfArray
/// @return {array}		 
function Cascade_to_array(_listOfArray) {
    
    var returnArray = []
    
    for(var _i = 0; _i<ds_list_size(_listOfArray); _i++)
    	array_copy(returnArray, array_length(returnArray), _listOfArray[|_i], 0, array_length(_listOfArray[|_i]))
    	
    return returnArray
}

/// @description Copy a List of Array by Value
/// @param  {ds_list<array>} _listOfArray
/// @return {ds_list<array>}		 
function List_of_array_copy_by_value(_listOfArray) {
	
	var oLA = ds_list_create()
	
	for (var _i=0; _i<ds_list_size(_listOfArray); _i++) {
		
		var tmp = []
		array_copy(tmp, 0, _listOfArray[|_i], 0, array_length(_listOfArray[|_i]))
		ds_list_add(oLA, tmp)
		
		//ds_list_add(oLA, Array_copy_by_value(_listOfArray[|_i]))
		
		
	}
	
	return oLA
	
}

/// @description Delete Incompleted (Consist Noone) Array in List of Array 
/// @param  {ds_list<array>} _listOfArray
/// @return {ds_list<array>}		
function Delete_incompleted_array_in(_listOfArray) {
	var _i = 0
	while( _i < ds_list_size(_listOfArray)) {
		if(Is_exist_in(noone, _listOfArray[|_i]))
			ds_list_delete(_listOfArray, _i)
		else
			_i++
	}
	
	return _listOfArray
}

/*HERE*/

//function Delete_undefined

/// @description Sort List of Array and if Array Repeats, Delete it 
/// @param  {ds_list<array>} _listOfArray
/// @return {ds_list<array>}		 
/// @description Sort List of Array and if Array Repeats, Delete it 
/// @param  {ds_list<array>} _listOfArray
/// @return {ds_list<array>}         
function Sort_and_delete_repeated_array_in(_listOfArray) {

    for (var _n = 0; _n < ds_list_size(_listOfArray); _n++)
        array_sort(_listOfArray[|_n], false)        

	// wrong on this sort!
    ds_list_sort(_listOfArray, false)

    var _m = 0
    while (_m < ds_list_size(_listOfArray) - 1) {
        if (array_equals(_listOfArray[|_m], _listOfArray[|_m + 1])) {
            ds_list_delete(_listOfArray, _m + 1)
        }
        else {
            _m++
        }
    }
    return _listOfArray
}


/// @description Sort List of Array and if Array Repeats, Delete it 
/// @param  {ds_list<array>} _listOfArray
/// @return {ds_list<array>}		 
/// @description Sort List of Array and if Array Repeats, Delete it 
/// @param  {ds_list<array>} _listOfArray
/// @return {ds_list<array>}         
function Sort_and_delete_repeated_array_in_4(_listOfArray) {
    // Sort each array in the list
    for (var _n = 0; _n < ds_list_size(_listOfArray); _n++) {
        array_sort(_listOfArray[| _n], false);
    }

    // Traverse the list of arrays
    for (var _i = 0; _i < ds_list_size(_listOfArray) - 1; _i++) {
        // Only proceed if the current array is not already empty
        if (ds_list_find_value(_listOfArray, _i) != undefined) {
            for (var _j = _i + 1; _j < ds_list_size(_listOfArray); _j++) {
                // Compare the current array to another array
                if (array_equals(_listOfArray[| _i], _listOfArray[| _j])) {
                    // Replace the duplicate array with an empty array
                    ds_list_replace(_listOfArray, _j, []);
                }
            }
        }
    }

    // Remove any empty arrays from the list
    for (var _k = ds_list_size(_listOfArray) - 1; _k >= 0; _k--) {
        if (array_length(ds_list_find_value(_listOfArray, _k)) == 0) {
            ds_list_delete(_listOfArray, _k);
        }
    }

    // Return the list of arrays, now with each array being unique and no empty arrays
    return _listOfArray;
}


function Sort_and_delete_repeated_array_in_3(_listOfArray) {

    for (var _n = 0; _n < ds_list_size(_listOfArray); _n++)
        array_sort(_listOfArray[|_n], false); // Sort each array in the list

    var _m = 0;
    while (_m < ds_list_size(_listOfArray) - 1) {
        if (array_equals(_listOfArray[|_m], _listOfArray[|_m + 1])) {
            ds_list_delete(_listOfArray, _m + 1); // Delete duplicate arrays
        }
        else {
            _m++;
        }
    }
    return _listOfArray;
}


/* BUG HERE */

function Sort_and_delete_repeated_array_in_2(_iListofArray) {

    var n=0
	while (n < ds_list_size(_iListofArray)) {
		if (is_undefined(_iListofArray[|n]))
			ds_list_delete(_iListofArray, n)
		else
			n++
	}
	
	
	for (var i=0; i<ds_list_size(_iListofArray); i++) {
		
		//if(is_undefined(_iListofArray[|i]))
		
        array_sort(_iListofArray[|i], false)
		
	}
	
	var oListofArray = ds_list_create()
	
	ds_list_add(oListofArray, _iListofArray[|0])
	
	//if(ds_list_size(_iListofArray)>1) {
	
	for (var j=1; j<ds_list_size(_iListofArray); j++) {
		
		var isRepeated = false
		
	    for (var k=0; k<ds_list_size(oListofArray); k++) {
			if(array_equals(_iListofArray[|j], oListofArray[|k])) {
				isRepeated = true
				break	
			}	
		}
		
		if(isRepeated == false)
			ds_list_add(oListofArray, _iListofArray[|j])
		
	}
	//}
	
	return oListofArray
}


/// @description Sort List of Array and if Any Value in Array Repeats, Delete Array 
/// @param  {ds_list<array>} _listOfArray
/// @return {ds_list<array>}		 
function Sort_and_delete_repeated_value_in(_listOfArray) {
	
	for (var _n = 0; _n < ds_list_size(_listOfArray); _n++)
		array_sort(_listOfArray[|_n], false)		
	
	ds_list_sort(_listOfArray, false)
	
	var _m = 0
	while (_m < ds_list_size(_listOfArray)) {
		if (Is_repeated(_listOfArray[|_m]))
			ds_list_delete(_listOfArray, _m)
		else
			_m++
	}
	return _listOfArray
}


/* NOTE FOR PASSING FUNCTION AS ARGUMENT

This can be implied from official reference of array_sort(), as following:
https://manual.yoyogames.com/#rhsearch=array_sort&rhhlterm=array_sort&t=GameMaker_Language%2FGML_Reference%2FVariable_Functions%2Farray_sort.htm


Also Explained in following link: 
https://www.reddit.com/r/gamemaker/comments/eeezgn/is_there_any_way_to_pass_a_reference_to_a/

	Sort of, sure!

	In GameMaker, resources are given an index. So all of your script names behind the scenes is just calling its index. The way you get its index is by leaving the "()" off of the end of the function.

	Let's say you have "scr_function1()" and "scr_function2()". You can pass in the name of it without the "()", then use script_execute to execute the script with that name.

	It just looks like: scr_function1(scr_function2);

	Then inside of scr_function1() it'd look like:

	/// scr_function1()

	script = argument[0];

	script_execute(script);

	///
*///

/* EXAMPLES

// METHOD I: Declare Function When Calling

global.test = Sort_and_delete_repeated(listABC, function(la, i) {return Is_repeated(la[|i])})

function Sort_and_delete_repeated(_listOfArray, _func = function(_la, _i){}) {
	
	for (var _n = 0; _n < ds_list_size(_listOfArray); _n++)
		array_sort(_listOfArray[|_n], false)		
	
	ds_list_sort(_listOfArray, false)
	
	var _m = 0
	while (_m < ds_list_size(_listOfArray)) {
		if (_func(_listOfArray, _m))
			ds_list_delete(_listOfArray, _m)
		else
			_m++
	}
	return _listOfArray
}

// METHOD II: PUT FUNCTION INTO A VIRIABLE

var func = function(_listOfArray, _m) {
	
	return Is_repeated(_listOfArray[|_m])
}

function Sort_and_delete_repeated(_listOfArray, func) {
	
	for (var _n = 0; _n < ds_list_size(_listOfArray); _n++)
		array_sort(_listOfArray[|_n], false)		
	
	ds_list_sort(_listOfArray, false)
	
	var _m = 0
	while (_m < ds_list_size(_listOfArray)) {
		if (func(_listOfArray, _m))
			ds_list_delete(_listOfArray, _m)
		else
			_m++
	}
	
	return _listOfArray
}

Notice that cannot combine Sort_and_delete_repeated_array_in_4(_listOfArray) & Sort_and_delete_repeated_value_in(_listOfArray) here, because even criterion can be changed, the While() loop is not the same.

*/