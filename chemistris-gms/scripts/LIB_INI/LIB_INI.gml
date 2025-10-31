/// LIB_INI INCLUDES INITIALIZATION FUNCTIONS IN DIFFERENT STAGES ///
/// -------------------------------------------------------------///
///
/// @Game_ini_global()
/// @Level_room_ini_global()
/// @Level_data_ini_global(_lvName, _lvTableGrid)

/// @description Initialize the Whole Game
/// @return {void}

function Game_ini_global() {

	#region GAME INI
	
	game_set_speed(60, gamespeed_fps);
	
	randomize();

	#endregion
	#region FONT
	
	//BIG
	global.fontL = font_add("IBMPlexSansCondensed.ttf", 50, true, true, 0, 650);
	
	global.fontM = font_add("IBMPlexSansCondensed.ttf", 30, true, true, 0, 650);
	
	//SMALL
	global.fontS = font_add("IBMPlexSansCondensed.ttf", 20, true, true, 0, 650);
	
	global.font36 = font_add("IBMPlexSansCondensed.ttf", 27, true, true, 0, 650); //27 //36
	
	global.font28 = font_add("IBMPlexSansCondensed.ttf", 21, true, true, 0, 650); //21 //28
	
	
	//draw_set_font(global.font)
	
	#endregion
	#region DATA INI
	
	if (!file_exists("REACTANT d77c9dfee50f4fb89f1ecb2d53423b94.csv"))
		show_error("@Game_ini_global | FATAL ERR! CSV OF REACTANT NOT EXISTS",true)
		
	if (!file_exists("PRODUCT 4c15d94714214794b76bfc3393c7451d.csv"))
		show_error("@Game_ini_global | FATAL ERR! CSV OF PRODUCT NOT EXISTS",true)
	
	if (!file_exists("LEVEL beebc167bca74e318f87492c6d029cfb.csv"))
		show_error("@Game_ini_global | FATAL ERR! CSV OF LEVEL NOT EXISTS",true)
	
	global.mole2atom2nMap = ds_map_create()
	global.mole2atom2nMap = Add_mole_atom_n_map("REACTANT d77c9dfee50f4fb89f1ecb2d53423b94.csv", global.mole2atom2nMap)
	global.mole2atom2nMap = Add_mole_atom_n_map("PRODUCT 4c15d94714214794b76bfc3393c7451d.csv", global.mole2atom2nMap)
	
	global.equa2react2nMap = Get_equa_mole_n_map_from("REACTANT d77c9dfee50f4fb89f1ecb2d53423b94.csv")
	global.equa2produ2nMap = Get_equa_mole_n_map_from("PRODUCT 4c15d94714214794b76bfc3393c7451d.csv")
	
	global.equa2atom2nMap = Check_consistency(global.equa2react2nMap, global.equa2produ2nMap)
	
	global.lvTableGrid = load_csv("LEVEL beebc167bca74e318f87492c6d029cfb.csv")
	
	Clean_level_table_grid(global.lvTableGrid)
	
	#endregion
	#region TEST MODE
	
	global.isTEST = false
	global.testFallArray = ["NaOH","Cl2","NaOH","NaOH","NaOH","NaOH","NaOH","NaOH", "NaOH","NaOH","NaOH","NaOH","NaOH","NaOH", "NaOH","NaOH","NaOH","NaOH","NaOH","NaOH", "NaOH","NaOH","NaOH","NaOH","NaOH","NaOH"]
	global.testFallIndex = -1
	
	#endregion
	
	global.elementMapofLevelPriorityDS = Build_chapter_map_of_level_ds_priority_from(global.lvTableGrid)

	
	global.level = ""
	
	if(!file_exists("chemistris.dat")) {
		global.progressMap = Initialize_progress_map(global.lvTableGrid)
	
	}	
	else
		global.progressMap = ds_map_secure_load("chemistris.dat")
}

/// @description Initialize the Room of Level
/// @return {void}

function Level_room_ini_global() {
	
	global.cellGrid = ds_grid_create(N_DISPLAYED_HOR_CELLS, N_DISPLAYED_VER_CELLS + N_HIDDEN_VER_CELLS)

	Cell_grid_initializer_with_offset_y(global.cellGrid, N_HIDDEN_VER_CELLS);
	
	global.lvArrayEquaPoem  = []
	global.lvArrayCounter   = []
	global.lvArrayBanned    = []
	global.lvArrayFallReact = [] 
	global.lvSeqFallReact   = 0

}	

/// @description Initialize the Data of Level
/// @param  {string}  _lvName      Name of Level
/// @param  {ds_grid} _lvTableGrid Grid Table of Level CSV
/// @return {void}

function Level_data_ini_global(_lvName, _lvTableGrid) {
	
	var lvTableRow = ds_grid_value_y(_lvTableGrid, L0_LEVEL, 0, L0_LEVEL, ds_grid_height(_lvTableGrid)-1, _lvName);
	
	if(lvTableRow<0) {
		show_error("@Level_data_ini_global | FATAL ERR! NON-EXSIT LEVEL NAME",true)
	}
	
	// Equation Code & Falling React
	
	var code = _lvTableGrid[# L1_CODE, lvTableRow]
	
	global.lvArrayEquaPoem = Parse_string_with_separator_into_array_via_func(code, "&", function(_array, _text){array_push(_array, _text)}) 
	
	global.lvArrayFallReact = Get_level_fall_reactant_array(global.lvArrayEquaPoem, global.equa2react2nMap)
	
	// Counter
	
	var counter = _lvTableGrid[# L2_COUNT, lvTableRow]
	
	global.lvArrayCounter = Parse_string_with_separator_into_array_via_func(counter, "+", function(_array, _text){Level_table_counter_unit_decoder_of_PSWSIA(_array, _text)}) 
	
	Counter_draw("lay_tileset_counter", global.lvArrayCounter)
	
	var banned = _lvTableGrid[# L5_BAN, lvTableRow]
	
	if(banned != "")
		global.lvArrayBanned = Parse_string_with_separator_into_array_via_func(banned, "&", function(_array, _text){array_push(_array, _text)}) 
	
	Banned_draw("lay_tileset_banned", global.lvArrayBanned)
	
	//for(var i_=0; i_<array_length(global.lvArrayCounter); i_++) {
	//	tilemap_set(Get_tilemap_element_from("lay_tileset_counter"),  ds_map_find_value(global.moleTilemap, global.lvArrayCounter[i_]), i_, 0)	
	//}
}