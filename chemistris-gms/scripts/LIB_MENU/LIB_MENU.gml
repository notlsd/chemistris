function Draw_menu_global() {
	
	var chapterPriorityDS = Build_chapter_priority_ds_global(global.elementMapofLevelPriorityDS)

	var chapterUpY = MENU_BOX_OF_ELEMENT_CHAPTER_UP
	
	while(!ds_priority_empty(chapterPriorityDS)) {
		
		//if(Is_all_value_in_the_map_equal_to(_map, _val))
		
		var chapter = ds_priority_delete_min(chapterPriorityDS);
		
		var nmap = Ds_priority_to_mapn(global.elementMapofLevelPriorityDS [? chapter])
		
		var chProgessMap = Build_chapter_progress_map(nmap, global.progressMap)
		
		// DRAW CHAPTR
		
		if(!Is_all_value_in_the_map_equal_to(chProgessMap, levelStatus.LOCKED)) {
		
			draw_set_color(global.chapterColorMap[? chapter])
		
			chapterUpY = Draw_chapter_rectangle_global(chapter, MENU_BOX_OF_ELEMENT_CHAPTER_LEFT,chapterUpY) + CHAPTER_MARGINS
			
			Update_periodic_table_of_elements_global(chapter, "lay_tileset_unlocked")
		}
		
		if(Is_all_value_in_the_map_equal_to(chProgessMap, levelStatus.PASSED)) {
		
			//draw_set_color(global.chapterColorMap[? chapter])
		
			//chapterUpY = Draw_chapter_rectangle_global(chapter, MENU_BOX_OF_ELEMENT_CHAPTER_LEFT,chapterUpY) + CHAPTER_MARGINS
			
			Update_periodic_table_of_elements_global(chapter, "lay_tileset_passed")
		}	
	}
}

function Update_periodic_table_of_elements_global(_element, _layerTileset) {

	var tilemap = layer_tilemap_get_id(_layerTileset)
	
	var benchmarkTilemap = layer_tilemap_get_id("lay_tileset_locked")
	

	// var key = ds_map_find_first(global.atomTilemap)
	// while(_element == key) {
	// 	key = ds_map_find_next(ds_map_find_first(global.atomTilemap), key)
	// }
	
	var value = global.atomTilemap[? _element]
	
	//var h = tilemap_get_height(tilemap)
	
	for(var _x=0; _x<tilemap_get_width(tilemap); _x++) {
		for(var _y=0; _y<tilemap_get_height(tilemap); _y++){
			
			//if(_x==0 && _y==0)
			//	continue
			
        	if(value == tilemap_get(benchmarkTilemap, _x, _y)){
				
				Tileset_menu(_layerTileset, value, _x, _y)
				
				//tilemap_set(tilemap, value, _x, _y)
				
				//tilemap_set(Get_tilemap_element_from("lay_tileset_locked"), TRANSPARENT, _x, _y)
				
				//tilemap_set(Get_tilemap_element_from("lay_tileset_unlocked"), TRANSPARENT, _x, _y)
        		
				return true
			}
		}
    }
    
    return false
}

function Tileset_menu(_layerTileset, _value, _x, _y) {
	
	var tilemap = layer_tilemap_get_id(_layerTileset)
	
	switch(_layerTileset) {
		case "lay_tileset_locked":
			//tilemap_set(Get_tilemap_element_from("lay_tileset_unlocked"), TRANSPARENT, _x, _y)
			//tilemap_set(Get_tilemap_element_from("lay_tileset_passed"), TRANSPARENT, _x, _y)
			tilemap_set(tilemap, _value, _x, _y)
			break
			
		case "lay_tileset_unlocked":
			//tilemap_set(Get_tilemap_element_from("lay_tileset_locked"), TRANSPARENT, _x, _y)
			//tilemap_set(Get_tilemap_element_from("lay_tileset_passed"), TRANSPARENT, _x, _y)
			tilemap_set(tilemap, _value, _x, _y)
			break
			
		case "lay_tileset_passed":
			tilemap_set(Get_tilemap_element_from("lay_tileset_locked"), TRANSPARENT, _x, _y)
			tilemap_set(Get_tilemap_element_from("lay_tileset_unlocked"), TRANSPARENT, _x, _y)
			tilemap_set(tilemap, _value, _x, _y)
			break
	
	}
}

function Draw_chapter_rectangle_global(_element, _iniX, _iniY) {
	
	draw_set_color(global.chapterColorMap[? _element])
	draw_set_font(global.font36)
	draw_set_valign(fa_top)
	draw_set_halign(fa_left)
	
	// var textX = MENU_BOX_OF_ELEMENT_CHAPTER_LEFT + string_width("X")
	
	var textX = _iniX
	var textY = _iniY // + string_height("▧")
	
	draw_text(textX-OFFSET_CHAPTER_CAPITAL, textY, _element)
	
	// textY += string_height("X")
	
	//while(!is_undefined(chapter)) {
	
	var lvPriorityDS = ds_priority_create()
	ds_priority_copy(lvPriorityDS, global.elementMapofLevelPriorityDS[?_element])
	

	while(!ds_priority_empty(lvPriorityDS)) {
		
		draw_set_font(global.font28)
	
		var level = ds_priority_delete_min(lvPriorityDS);
	
		textY = Draw_level_status(level, global.progressMap, textX, textY, global.chapterColorMap[? _element])
		
		//textY += string_height("X")
	}
			
	Draw_rectangle_width_color(MENU_BOX_OF_ELEMENT_CHAPTER_LEFT - MENU_BOX_OF_ELEMENT_CHAPTER_MARGINS,_iniY - MENU_BOX_OF_ELEMENT_CHAPTER_MARGINS, MENU_BOX_OF_ELEMENT_CHAPTER_RIGHT + MENU_BOX_OF_ELEMENT_CHAPTER_MARGINS, textY /*+ string_height("X")*/ + MENU_BOX_OF_ELEMENT_CHAPTER_MARGINS,MENU_BOX_OF_ELEMENT_CHAPTER_WIDTH, global.chapterColorMap [? _element])
	
	return textY + /*string_height("X") +*/ MENU_BOX_OF_ELEMENT_CHAPTER_MARGINS
		
}	

function Draw_level_status(_level, _progressMap, _x, _y, _color){
	
	switch (_progressMap[? _level]) {
		case levelStatus.UNLOCKED:
		
			draw_set_color(c_white)
			draw_set_valign(fa_top)
			draw_set_halign(fa_left)
			
			draw_text(_x, _y, Get_footnoted_mole_from(_level))
			
			if (mouse_check_button_pressed(mb_left) && mouse_x >= MENU_BOX_OF_ELEMENT_CHAPTER_LEFT && mouse_x <= MENU_BOX_OF_ELEMENT_CHAPTER_RIGHT && mouse_y >= _y && mouse_y <= _y + string_height("X")) {
				
				global.level = _level
				
				room_goto(rom_level)
				
			}
			
			_y+=string_height("X")
			
			break
			
		case levelStatus.LOCKED:
			break
			
		case levelStatus.PASSED:
			
			draw_set_color(_color)
			draw_set_valign(fa_top)
			draw_set_halign(fa_left)
			draw_text(_x, _y, Get_footnoted_mole_from(_level))
			
			draw_set_halign(fa_right)
			draw_sprite_ext(spr_check, 0, MENU_BOX_OF_ELEMENT_CHAPTER_RIGHT, _y,1,1,0,_color,1)
			
			if (mouse_check_button_pressed(mb_left) && mouse_x >= MENU_BOX_OF_ELEMENT_CHAPTER_LEFT && mouse_x <= MENU_BOX_OF_ELEMENT_CHAPTER_RIGHT && mouse_y >= _y && mouse_y <= _y + string_height("X")) {
				
				global.level = _level
				
				room_goto(rom_level)
			
			}
			
			_y+=string_height("X")
			
			break
	}
	return _y
}

function Draw_rectangle_width_color(_x1, _y1, _x2, _y2, _w, _c) {
	
	draw_set_color(_c)
	
	draw_line_width(_x2, _y1, _x2, _y2, _w)
	draw_line_width(_x1, _y2, _x2, _y2, _w)
	draw_line_width(_x1, _y1, _x1, _y2, _w)
	draw_line_width(_x1, _y1, _x2, _y1, _w)
	
}
    
function Build_chapter_priority_ds_global(_elementMapOfLevelPriorityDS) {
	
	var chapterPriorityDS = ds_priority_create()
	
	var key = ds_map_find_first(_elementMapOfLevelPriorityDS)
	
	while(!is_undefined(key)) {
		
		ds_priority_add(chapterPriorityDS, key, global.atomTilemap[? key])
		
		key = ds_map_find_next(_elementMapOfLevelPriorityDS, key)
	}
	
	return chapterPriorityDS
}

/// @description Transform N_Map to ds_riority
/// @param  {ds_map}		_nMap
/// @param  {ds_map}		_nMap
/// @return {ds_priority}	    
function Build_chapter_progress_map(_chapterLvMap, _progressMap) {
	
	var chapterProgressMap = ds_map_create()
	ds_map_copy(chapterProgressMap, _chapterLvMap)
	
	var key = ds_map_find_first(_chapterLvMap)
	
	while(!is_undefined(key)) {
		
		chapterProgressMap[? key] = _progressMap[? key]
		
		key = ds_map_find_next(chapterProgressMap, key)
	}
	
	return chapterProgressMap
}


//global.progressMap = Initialize_progress_map(global.lvTableGrid) 
//ds_map_add(global.progressMap, "+ H2O", levelStatus.PASSED);
//ds_map_add(global.progressMap, "- H2O", levelStatus.UNLOCKED);
//ds_map_add(global.progressMap, "H2O2", levelStatus.LOCKED);

function Initialize_progress_map(_lvTableGrid) {
    
    var progressMap = ds_map_create()
    
    // Initialize with 1 to ignore 表头
    for(var _i=1; _i<ds_grid_height(_lvTableGrid); _i++){
        ds_map_add(progressMap, _lvTableGrid[# L0_LEVEL, _i], levelStatus.LOCKED)
    }
    
    progressMap[? "+ H2O"] = levelStatus.UNLOCKED
	
	//progressMap[? "Cl2 + NaOH"] = levelStatus.LOCKED
	
	//progressMap[? "+ Cl2"] = levelStatus.PASSED
    
    return progressMap
}



function Is_all_value_in_the_map_equal_to(_map, _val) {
	
	var key = ds_map_find_first(_map)
	
	while(!is_undefined(key)) {
		
		if(_map[? key] != _val)
			return false
		
		key = ds_map_find_next(_map, key)
	}
	
	return true
}