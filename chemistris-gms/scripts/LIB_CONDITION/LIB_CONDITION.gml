/* https://www.compart.com/en/unicode/category/Sc */

/* 加热 	₳
   点燃 	₼
   光照 	¤
   放电 	₪
   高温 	¥
   高温高压	₩
   催化剂	@ */

function Get_cond_sprite_index(_condSymbol) {
	switch (_condSymbol) {
		
		case "₳":
			return asset_get_index("spr_heat")
			
		case "₼":
			return asset_get_index("spr_fire")
			
		case "¤":
			return asset_get_index("spr_light")
			
		case "₪":
			return asset_get_index("spr_elec")
			
		case "¥":
			return asset_get_index("spr_HT")
			
		case "₩":
			return asset_get_index("spr_HTHP")
			
		case "@":
			show_error("催化剂尚未实现！", true)
			
		default:
			show_error("ERR! UNAVLIABLE CONDITION SYMBOL", true)
	}
}

function Is_condtion_symbol(_char) {
	switch (_char) {
		case "₳":
		case "₼":
		case "¤":
		case "₪":
		case "¥":
		case "₩":
		case "@":
			return true
		
		default:
			return false
	}
}