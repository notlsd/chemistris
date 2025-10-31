/// @description Get Molecule with Footnoted Format
/// @param  {string}	_mole
/// @return {string}

function Get_footnoted_mole_from(_iMole) {
	
	var oMole = _iMole
	
	var char = ""
	for (var _i=1; _i<=string_length(_iMole); _i++) {
		
		char = string_char_at(oMole, _i)
		
		if(Is_digit(char))
			oMole = string_replace(oMole, char, Get_footnote_from(char))
	}
	
	return oMole
}

/// @description Transform a Number to Its Footnote Format
/// @param  {string}	_n 
/// @return {string}

function Get_footnote_from(_n) {
	switch (_n) {
	    case "0":
	        return "₀"
	    case "1":
	    	return "₁"
	    case "2":
	    	return "₂"
	    case "3":
	    	return "₃"
	    case "4":
	    	return "₄"
	    case "5":
	        return "₅"
	    case "6":
	    	return "₆"
	    case "7":
	    	return "₇"
	    case "8":
	    	return "₈"
	    case "9":
	    	return "₉"
	    	
	    default:
	        show_error("@Get_footnote_from | ERR! NOT A NUMBER",true)
	        return
	}
}