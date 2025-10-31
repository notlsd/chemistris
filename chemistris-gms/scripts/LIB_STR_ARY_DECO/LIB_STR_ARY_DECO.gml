/// LIB_STR_ARY_DECODE INCLUDE FUNCTIONS DECODE STRING TO ARRAY ///
/// --------------------------------------------------------------///
/// @Parse_string_with_separator_into_array_via_func(_iStr, _sep, _func=function(_fARRAY, _fSTR){})
/// ⇲⇲⇲ @Level_table_counter_unit_decoder_of_PSWSIA(_oArray, _iStr) 

/* May change counter decoder format like 2CO+CO2 | 4 */

/// @description Parse String into Array with Separator
/// @param     {string}	  _iStr 						   [ Input String ]
/// @param     {string}	  _sep  						   [ Separator ]
/// @callback  {function} _func = function(_fARRAY, _fSTR) 
/// @return    {array}

/// @callback {function} _func	 [ How To Put Separated String Into Array ]
/// @param    {array}	 _fARRAY
/// @param	  {string} 	 _fSTR
/// @returns  {void}

function Parse_string_with_separator_into_array_via_func(_iStr, _sep, _func=function(_fARRAY, _fSTR){}) {
	
	// Initialization
	_fARRAY = []
	var searchBeg = 1
	var searchEnd = string_length(_iStr) + 1
	
	// Search until Separator, Notice Here Is an Infinite Loop
	while(true) {
		
		searchEnd  = string_pos_ext(_sep, _iStr, searchBeg)
		
		// No Seperator Anymore, Search to the End
		if(searchEnd == 0)
			searchEnd = string_length(_iStr) + 1
		
		_fSTR = string_trim(string_copy(_iStr, searchBeg, searchEnd-searchBeg))
		
		// Search to the End, Quit Infinite Loop
		if(_fSTR == "")
			break
		else
			_func(_fARRAY, _fSTR)
			
		searchBeg = searchEnd + 1
	}
	
	return _fARRAY
}


/// @description Decode One Unit of Counter Column in Level Table ("2H2" -> ["H2","H2"])
/// @param  {array}	 _oArray [ Output Array ]
/// @param  {string} _iStr   [ Input String ]
/// @return {void}
function Level_table_counter_unit_decoder_of_PSWSIA(_oArray, _iStr) {
	
	var oStr = string_lettersdigits(_iStr)
	
	var pos1stCap = Find_1st_capital_position(oStr)
	
	var mole = string_copy(oStr, pos1stCap, string_length(oStr)-pos1stCap+1)
	
	if(pos1stCap == 1)
		var times = 1
	else
		var times = real(Read_string_until_upper(oStr))
	
	repeat(times) {
		array_push(_oArray, mole)
	}
}