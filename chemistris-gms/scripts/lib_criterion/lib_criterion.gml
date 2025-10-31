/// LIB_CHAR_CRITERION INCLUDES FUNCTIONS TO CHECK CHAR TYPE WHICH INHERITED FROM AFCC ///
//------------------------------------------------------------------------------------///
// @Is_uppercase(_char)
// @Is_lowercase(_char)
// @Is_digit(_char)
// @Is_upper_or_empty(_char)

/// @description Check Whether Input Is an Uppercase Char
/// @param {string} _char
/// @return {bool}

function Is_uppercase(_char) {
	
	if (is_string(_char)) {
		if (string_length(_char) == 1)
			return (ord("A") <= ord(_char) && ord(_char) <= ord("Z"))
		else
			show_error("@Is_uppercase | ERR! ILLEGAL INPUT: NOT A CHAR", true)
	}
	
	else
		show_error("@Is_uppercase | ERR! ILLEGAL INPUT: NOT A STRING", true)
}

/// @description Check Whether Input Is a Lowercase Char
/// @param {string} _char
/// @returns {bool}	

function Is_lowercase(_char) {

	if (is_string(_char)) {
		if (string_length(_char) == 1) 
			return (ord("a") <= ord(_char) && ord(_char) <= ord("z"))
		else
			show_error("@Is_lowercase | ERR! ILLEGAL INPUT: NOT A CHAR", true)
	}
	
	else
		show_error("@Is_lowercase | ERR! ILLEGAL INPUT: NOT A STRING", true)
}

/// @description Check Whether Input Is a Digit
/// @param {string} _char
/// @returns {bool}

function Is_digit(_char) {

	if (is_string(_char)) {
		if (string_length(_char) == 1)
			return (ord("0") <= ord(_char) && ord(_char) <= ord("9"))
		else
			show_error("@Is_digit | ERR! ILLEGAL INPUT: NOT A CHAR", true)
	}
	
	else
		show_error("@Is_digit | ERR! ILLEGAL INPUT: NOT A STRING", true)
}

/// @desc Check Whether Input Is an Uppercase Char or Empty
/// @arg {string} _char
/// @return {bool} 

// Is_upper_or_empty = is_upper && is_empty

function Is_upper_or_empty (_char) {
	
	if (is_string(_char)) {
		if (string_length(_char) == 0)
			return true
		else if (string_length(_char) == 1){
			
			// return Is_uppercase(_char)
			
			if (Is_uppercase(_char))
				return true
			else
				return false
		}
		else
			show_error("@Is_upper_or_empty | ERR! ILLEGAL INPUT: NOT A CHAR", true)
	}
	else
		show_error("@Is_upper_or_empty | ERR! ILLEGAL INPUT: NOT A STRING", true)
}
