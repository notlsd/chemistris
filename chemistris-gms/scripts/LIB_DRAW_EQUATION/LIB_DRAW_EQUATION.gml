/// LIB_DRAW_EQUATION INCLUDE FUNCTIONS WHICH DRAW EQUATIONS IN LEVEL ///
/// -----------------------------------------------------------------///
/// @Draw_multiple_equation(_x, _y, _equaPoemArray)
/// ⇲⇲⇲ @Draw_equation_global(_x, _y, _equaPoem)
/// ⇲⇲⇲⇲⇲⇲⇲ @Count_equation_regular_letterdigits(_reactOrProduNmap)

/// @description Draw Chemistry Equation with Molecule's Color
/// @param  {number}		_x			   [ Left Up X Pixel of Equation Display ]
/// @param  {number}		_y			   [ Left Up Y Pixel of Equation Display ]
/// @param  {array<string>}	_equaPoemArray [ Array of Level Equation Poem ]
/// @return {void}
function Draw_multiple_equation(_x, _y, _equaPoemArray) {	
	for (var _i=0; _i<array_length(_equaPoemArray); _i++) {
	    Draw_equation_global(_x, _y + _i * 2 * string_height("X"), _equaPoemArray[_i])
	}
}

/// @description Draw Chemistry Equation with Molecule's Color
/// @param  {number}	_x 
/// @param  {number}	_y
/// @param  {string}	_equaPoem [ Code of Equation ]
/// @return {void}
function Draw_equation_global(_x, _y, _equaPoem){
	
	#region INITIALIZATION
	
	var plus = "+ "
	
	var reactMap = ds_map_find_value(global.equa2react2nMap, _equaPoem)
	
	var produMap = ds_map_find_value(global.equa2produ2nMap, _equaPoem)
	
	var equaStrN = Count_equation_regular_letterdigits(reactMap) + Count_equation_regular_letterdigits(produMap)
	
	draw_set_color(c_white)
	draw_set_halign(fa_left)
	draw_set_valign(fa_bottom)
	
	#endregion
	#region FONT CRITERION
	
	if(equaStrN > EQUATION_DISPLAY_M_OR_S_FONT_N)
		draw_set_font(global.fontS)
	else if(equaStrN <= EQUATION_DISPLAY_M_OR_S_FONT_N && equaStrN >= EQUATION_DISPLAY_L_OR_M_FONT_N)
		draw_set_font(global.fontM)
	else if(equaStrN < EQUATION_DISPLAY_L_OR_M_FONT_N)
		draw_set_font(global.fontL)
	else
		show_error("@Draw_equation_global | ERR! FONT NOT EXIST", true)
	
	var nowX = _x
	if(draw_get_font() == global.fontL)
		nowX = _x + OFFSET_OF_FONT_L_IN_EQUATION_DISPLAY_INI_PX_X
	
	var nowY = _y
	
	#endregion
	#region DRAW LEFT OF EQUATION
	
	var reactKey = ds_map_find_first(reactMap)
	
	var condition = ""
		
	while(!is_undefined(reactKey)) {
		
		// Meet Condition Symbol
		if(!Is_uppercase(string_char_at(reactKey,1))) {
			condition = reactKey
			reactKey = ds_map_find_next(reactMap, reactKey)
			continue
		}
		
		// Draw a Reactant
		var nowCol = global.moleColorMap[? reactKey]
		
		var nowDraw = string_concat(Get_footnoted_mole_from(reactKey), " ")
			
		if((reactMap[? reactKey] > 1))
			nowDraw = string_concat(string(reactMap[? reactKey]), nowDraw)
		
		draw_text_color(nowX, nowY, nowDraw, nowCol, nowCol,nowCol, nowCol, 1)
		
		nowX += string_width(nowDraw)
		
		// Draw "+" if Necessary
		if(!is_undefined(ds_map_find_next(reactMap, reactKey))) {
			draw_text_color(nowX, nowY, plus, c_white, c_white,c_white, c_white, 1)
			nowX += string_width(plus)
		}
		
		// Next
		reactKey = ds_map_find_next(reactMap, reactKey)
	}
	
	#endregion
	#region DRAW EQUAL CONDITION
	
	var reactionArrow = " →  "
	draw_text_color(nowX, nowY, reactionArrow, c_white, c_white,c_white, c_white, 1)
	
	if(condition != "") {
	
		var scale = 1
		if(draw_get_font() == global.fontM || draw_get_font() == global.fontS)
			scale = 0.5
	
		draw_sprite_ext(Get_cond_sprite_index(condition) , 0, nowX+string_width(reactionArrow)/2, nowY-string_height(reactionArrow) - OFFSET_DISPLAY_EQUATION_CONDITION_PX_Y, scale, scale, 0, c_white, 1);
	}
	
	nowX += string_width(reactionArrow)
	
	#endregion
	#region DRAW RIGHT OF EQUATION
	
	var produKey = ds_map_find_first(produMap)
		
	while(!is_undefined(produKey)) {
		
		// Draw a Product
		var nowCol = global.moleColorMap[? produKey]
		
		var nowDraw = string_concat(Get_footnoted_mole_from(produKey), " ")
			
		if((produMap[? produKey] > 1))
			nowDraw = string_concat(string(produMap[? produKey]), nowDraw)
		
		draw_text_color(nowX, nowY, nowDraw, nowCol, nowCol,nowCol, nowCol, 1)
		
		nowX += string_width(nowDraw)
		
		// Draw "+" if Necessary
		if(!is_undefined(ds_map_find_next(produMap, produKey))) {
			draw_text_color(nowX, nowY, plus, c_white, c_white,c_white, c_white, 1)
			nowX += string_width(plus)
		}
		
		// Next
		produKey = ds_map_find_next(produMap, produKey)
	}
	
	#endregion
	return
}

/// @description Count Regular Letters & Digits to Display
/// @param  {ds_map}	_reactOrProduNmap
/// @return {int}
function Count_equation_regular_letterdigits(_reactOrProduNmap) {
	
	/* eg. 3Fe + 2O2 -> Fe3O4 = "3Fe" + "2O" + "FeO"= 8 */
	
	var moleKey = ds_map_find_first(_reactOrProduNmap)
	
	var count = 0
	
	while(!is_undefined(moleKey)) {
		
		count += string_length(string_letters(moleKey))
		
		if(real(_reactOrProduNmap[? moleKey]) > 1)
			count += 1
		
		moleKey = ds_map_find_next(_reactOrProduNmap, moleKey)
	}
	
	return count
}

