/// LIB_CNK INCLUDES FUNCTIONS TO IMPLEMENT COMBINATION (N, K) ///
//------------------------------------------------------------///
// Cnk_from(_ilist, _k)										 ///
// Cnk_recursion(_iList, _i, _k, _oList, _o, _oListOfList)  ///
//---------------------------------------------------------///
//
// Reference: Method II of the following link
//
/* https://www.geeksforgeeks.org/print-all-possible-combinations-of-r-elements-in-a-given-array-of-size-n/ */
//
// Offline Backup: 
//
/* https://www.notion.so/notlsd/Print-all-possible-combinations-of-r-elements-in-a-given-array-of-size-n-141a60f0f0c84b0fa3e6a6cbde5a98d6 */
//

/// @description Combination(n, k)
/// @param  {ds_list}		   _iList [ n is ommited since n is ds_list_size() ]
/// @param  {int}			   _k		   
/// @return {ds_list<ds_list>}        
/// [ oListOfList: Single result put into a list; All result put into another list ]  	    
///
function Cnk_from(_iList, _k) {
    var oListOfList = ds_list_create()
    var oList = ds_list_create()
    
    Cnk_recursion(_iList, 0, _k, oList, 0, oListOfList);
    
    return oListOfList
}

/// @description Combination(n, k) Recursion Unit
/// @param  {ds_list}		   _iList		[ Input List ]
/// @param  {int}			   _i			[ Input Index ]
/// @param  {int}			   _k			[ K of C(n,k) ]
/// @param  {ds_list}		   _oList		[ One Output List ]
/// @param  {int}			   _o			[ One Output Index ]
/// @param  {ds_list<ds_list>} _oListOfList [ All Output in List of List ]
/// @return {void}

function Cnk_recursion(_iList, _i, _k, _oList, _o, _oListOfList) {
    
    // Return legal combination
    // Notice _k = 0 is a leagel result and will return an empty list. This will be used when calling.
    if(_o == _k) {
		
		/* Notice that list is passed by address. If do not copy before add, oList will have all transient value of C(n,k), but only return the last! */
		
		var tmpList = ds_list_create()
		ds_list_copy(tmpList, _oList)
        ds_list_add(_oListOfList, tmpList)
        
        return;
    }
    
    // k >= n
    if (_i >= ds_list_size(_iList))
    	return;
    	
	// Temporarily set current output = current input
	_oList[|_o] = _iList[|_i]
	
    // Current input is included, to the next
    Cnk_recursion(_iList, _i+1, _k, _oList, _o+1, _oListOfList)
    
    // Current input is excluded, cover output temporarily set before
    Cnk_recursion(_iList, _i+1, _k, _oList, _o, _oListOfList)
    
    /* _i+1 to exclude current input */
    
    /* Notice Cnk_recursion(... _i+1 ... _o+1 ...) will continue calling to the end and then start calling Cnk_recursion(... _i+1 ... _o ...) */
}
