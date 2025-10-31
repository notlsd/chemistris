/// LIB_AT_CL_GD_OBJ INCLUDES CONSTRUCTORS AND FUNCTIONS RELATED TO ATOM & CELL & GRID WITH OBJ_MOLE & OBJ_COND /// 
/// -----------------------------------------------------------------------------------------------------------///
/// CONSTRUCTORS ///
/// ---------------
/// @Cell_constructor(_gridX, _gridY, _up, _down, _left, _right)
/// @Atom_constructor_global(_cellS, _id, _atom, _mole)
/// --------------
/// CELL GRID ///
/// ------------
/// @Cell_grid_initializer_with_offset_y(_cellGrid)
/// @Cell_grid_resetter(_cellGrid)
/// ---------------------
/// HEPLPER FUNCTION ///
/// -------------------
/// @Recouple_atom_to_new_cell_via_list (_atomSList, _cellSList)
/// @Is_mole_destination_allowed(_moleID, _destinationStructCellList)
/// ----------------------------
/// FALLING OBJECT CREATION ///
/// --------------------------
/// @Falling_next_obj()
/// ⇲⇲⇲ @Get_level_fall_reactant_array(_lvEquaArray, _equa2reactnMap)
/// ⇲⇲⇲ @Create_mole_instance_with_offset_y(_x, _y, _cellGrid, _mole)
/// ⇲⇲⇲ @Create_cond_instance_with_offset_y(_condition, _cellGrid)

/* 如表所示：阿拉伯数字是 gridX 与 gridY 的值；中文数字是 GRID 索引 [#X, Y] 的值。
   特别注意：Y 值有 N_HIDDEN_VER_CELLS 的差值！gridY = Y - N_HIDDEN_VER_CELLS。

    |[〇〇][〇壹][〇贰][〇叁][〇肆][〇伍][〇陆][〇柒][〇捌][〇玖]
-----------------------------------------------------------------
〇〇|[0,-5][1,-5][2,-5][3,-5][4,-5][5,-5][6,-5][7,-5][8,-5][9,-5] 
〇壹|[0,-4][1,-4][2,-4][3,-4][4,-4][5,-4][6,-4][7,-4][8,-4][9,-4]
〇贰|[0,-3][1,-3][2,-3][3,-3][4,-3][5,-3][6,-3][7,-3][8,-3][9,-3]
〇叁|[0,-2][1,-2][2,-2][3,-2][4,-2][5,-2][6,-2][7,-2][8,-2][9,-2]
〇肆|[0,-1][1,-1][2,-1][3,-1][4,-1][5,-1][6,-1][7,-1][8,-1][9,-1]
〇伍|[0,00][1,00][2,00][3,00][4,00][5,00][6,00][7,00][8,00][9,00]
〇陆|[0,01][1,01][2,01][3,01][4,01][5,01][6,01][7,01][8,01][9,01]
〇柒|[0,02][1,02][2,02][3,02][4,02][5,02][6,02][7,02][8,02][9,02]
〇捌|[0,03][1,03][2,03][3,03][4,03][5,03][6,03][7,03][8,03][9,03]
〇玖|[0,04][1,04][2,04][3,04][4,04][5,04][6,04][7,04][8,04][9,04]
壹拾|[0,05][1,05][2,05][3,05][4,05][5,05][6,05][7,05][8,05][9,05]
拾壹|[0,06][1,06][2,06][3,06][4,06][5,06][6,06][7,06][8,06][9,06]
拾贰|[0,07][1,07][2,07][3,07][4,07][5,07][6,07][7,07][8,07][9,07]
拾叁|[0,08][1,08][2,08][3,08][4,08][5,08][6,08][7,08][8,08][9,08]
拾肆|[0,09][1,09][2,09][3,09][4,09][5,09][6,09][7,09][8,09][9,09]
拾伍|[0,10][1,10][2,10][3,10][4,10][5,10][6,10][7,10][8,10][9,10]
拾陆|[0,11][1,11][2,11][3,11][4,11][5,11][6,11][7,11][8,11][9,11]
拾柒|[0,12][1,12][2,12][3,12][4,12][5,12][6,12][7,12][8,12][9,12]
拾捌|[0,13][1,13][2,13][3,13][4,13][5,13][6,13][7,13][8,13][9,13]
拾玖|[0,14][1,14][2,14][3,14][4,14][5,14][6,14][7,14][8,14][9,14] */

/// @description Constructor of Cell Struct
/// @param {int}			_gridX	[X Coordinate of Cell in the Grid]
/// @param {int}		    _gridY  [Y Coordinate of Cell in the Grid]
/// @param {struct<cell>}   _up     
/// @param {struct<cell>}   _down   
/// @param {struct<cell>}   _left   
/// @param {struct<cell>}   _right  
function Cell_constructor(_gridX, _gridY, _up, _down, _left, _right) constructor {

	atomS = noone;
	
	gridX = _gridX;
    gridY = _gridY;
	
	cellUp = _up;
	cellDn = _down;
	cellLt = _left;
	cellRt = _right
	
	Random_next_cell = function() {
		
		randomize()
	
		var nextCell = [cellUp,cellDn,cellLt,cellRt]
	
		return nextCell[irandom(array_length(nextCell)-1)]
	}
}

/// @description Constructor of Atom Struct
/// @param {struct<cell>} _cellS [ Cell Struct Contains Location Info ]
/// @param {instance}     _id         [ Binding Molecular Instance ID ]
/// @param {string}		  _atom		  [ Atom Name String ]
/// @param {string}		  _mole		  [ Mole Name String ]
function Atom_constructor_global(_cellS, _id, _atom, _mole) constructor {
	
    atomName = _atom;
    moleName = _mole;
    
    atomTile = ds_map_find_value(global.atomTilemap, atomName);
	moleTile = ds_map_find_value(global.moleTilemap, moleName);
	
	moleID = _id;
	
	cellS = _cellS;
	cellS.atomS = self;
	
	Display = function(){
		
		if(cellS.gridY >= 0){
			
			tilemap_set(Get_tilemap_element_from("lay_tileset_atom"), atomTile, cellS.gridX, cellS.gridY)
			
			tilemap_set(Get_tilemap_element_from("lay_tileset_mole"), moleTile, cellS.gridX, cellS.gridY)
			
			return true		
		}
		
		else
			return false
	}
	
	Erase = function() {
		
		if(cellS.gridY >= 0) {
		
			tilemap_set(Get_tilemap_element_from("lay_tileset_atom"), TRANSPARENT, cellS.gridX, cellS.gridY)	
			/* WARNING INGORED */
		
			tilemap_set(Get_tilemap_element_from("lay_tileset_mole"), TRANSPARENT, cellS.gridX, cellS.gridY)
			/* WARNING INGORED */
		
			for(var i_=0; i_<CELL_SIDE_PX_TIMES_BOND+1; ++i_) {
				for(var j_=0; j_<CELL_SIDE_PX_TIMES_BOND+1; ++j_) {
					tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), TRANSPARENT, cellS.gridX*CELL_SIDE_PX_TIMES_BOND -1 +i_, cellS.gridY*CELL_SIDE_PX_TIMES_BOND -1 +j_)
					/* WARNING INGORED */
				}
			}
			
			return true		
		}
		
		else
			return false
	}
	
}

/// @description Initialize Cell Grid with Hidden Y Offset
/// @param  {ds_grid} _cellGrid
/// @param  {int}	  _offsetY
/// @return {void}
function Cell_grid_initializer_with_offset_y(_cellGrid, _offsetY) {
	for (var _i = 0; _i < ds_grid_width(_cellGrid); _i++) {
		for (var _j = 0; _j < ds_grid_height(_cellGrid); _j++) {
			ds_grid_add(_cellGrid, _i, _j, 
			new Cell_constructor(_i, _j-_offsetY, noone, noone, noone, noone))
		}
	}
	
	for (var _m = 0; _m < ds_grid_width(_cellGrid); _m++) {
		for (var _n = 0; _n < ds_grid_height(_cellGrid); _n++) {	
			if (_m > 0)
				_cellGrid[# _m, _n][$ "cellLt"] = _cellGrid[# _m - 1, _n];
			if (_m < ds_grid_width(_cellGrid) - 1)
				_cellGrid[# _m, _n][$ "cellRt"] = _cellGrid[# _m + 1, _n];
			if (_n > 0)
				_cellGrid[# _m, _n][$ "cellUp"] = _cellGrid[# _m, _n - 1];
			if (_n < ds_grid_height(_cellGrid) - 1)
				_cellGrid[# _m, _n][$ "cellDn"] = _cellGrid[# _m, _n + 1];	   		
		}
	}
}

/// @description Reset Cell Grid
/// @param  {ds_grid} _cellGrid
/// @return {void}
function Cell_grid_resetter(_cellGrid) {
	for (var _i = 0; _i < ds_grid_width(_cellGrid); _i++) {
		for (var _j = 0; _j < ds_grid_height(_cellGrid); _j++) {
			_cellGrid[# _i, _j][$ "atomS"] = noone
		}
	}
}

/// @description Decouple Old Atom-Cell Pairs and Recouple New One
/// @param {ds_list<struct<atomS>>} _atomSList
/// @param {ds_list<struct<cellS>>} _cellSList
/// @return {void} 				
function Recouple_atom_to_new_cell_via_list (_atomSList, _cellSList) {
	for (var _i=0; _i<ds_list_size(_atomSList); _i++) {
		_atomSList[|_i][$ "cellS"][$ "atomS"] = noone
		_atomSList[|_i].cellS = _cellSList[|_i]
	}
	
	for (var _j=0; _j<ds_list_size(_cellSList); _j++) {
		_cellSList[|_j].atomS = _atomSList[|_j]
	}
}

/// @description Determine Whether Mole Instance Can Be Moved to the Given Destination
/// @param {instance<obj_mole>}	   _moleID
/// @param {ds_list<struct<cell>>} _destinationStructCellList
/// @return {bool} 	
function Is_mole_destination_allowed(_moleID, _destinationStructCellList) {
	
	for (var i=0; i<ds_list_size(_destinationStructCellList); i++) {
		
	 	// Boundry Condition, Cell does not exist
	 	if (_destinationStructCellList[|i] == noone)
	 		return false
		
		// Cell exsit
		else
			// atom exsit, atom does not occupied
			if (_destinationStructCellList[|i][$ "atomS"] != noone)
				// atom is not self
				if (_destinationStructCellList[|i][$ "atomS"][$ "moleID"] != _moleID) 
		 			return false
	}
	
	return true
}

/// @description Initialize Next Falling Object
/// @return {instance}	    			 
function Falling_next_obj_global() {
	
	var reactantArray = global.lvArrayFallReact
	
	var _cellGrid = global.cellGrid
	
	/* TEST MODE */
	if(global.isTEST) {
		
		global.testFallIndex++
		
		if (Is_uppercase(string_char_at(global.testFallArray[global.testFallIndex], 1)))
			return Create_mole_instance_with_offset_y(global.testFallArray[global.testFallIndex], _cellGrid, irandom_range(REACTOR_LEFT, REACTOR_RIGHT),CELL_SIDE_PX/2, N_HIDDEN_VER_CELLS)
		else
			return Create_cond_instance_with_offset_y(global.testFallArray[global.testFallIndex], _cellGrid, N_HIDDEN_VER_CELLS)
	
	}
	
	/* RESET lvArrayFallReact WHEN SEARCH TO THE END */
	if(global.lvSeqFallReact == array_length(reactantArray)-1) {
		global.lvArrayFallReact = Get_level_fall_reactant_array(global.lvArrayEquaPoem, global.equa2react2nMap)
		global.lvSeqFallReact = 0
	}
	
	/* FALLING NEXT */
	var fallingObj = reactantArray[global.lvSeqFallReact]
	global.lvSeqFallReact++
	
	if (Is_uppercase(string_char_at(fallingObj, 1)))
		return Create_mole_instance_with_offset_y(fallingObj, _cellGrid, REACTOR_LEFT+(irandom_range(0, N_DISPLAYED_HOR_CELLS-1)+1/2)*CELL_SIDE_PX,CELL_SIDE_PX/2, N_HIDDEN_VER_CELLS)
	else
		return Create_cond_instance_with_offset_y(fallingObj, _cellGrid, N_HIDDEN_VER_CELLS)
}

/// @description Get Level Fall Reactant Array
/// @param  {array}         	_lvEquaArray	[Array of Level Equation Poem]
/// @param  {ds_map<ds_map>}	_equa2reactnMap [Map of EquationPoem->Reactant->N]
/// @return {array<obj_mole>}   
function Get_level_fall_reactant_array(_lvEquaArray, _equa2reactnMap) {
	
	/* [随机（去除反应条件）][定序][随机][定序][随机][定序]...... */
	
	// 临时定序数组
	var tMoleArray = []
	
	// 输出反应数组
	var oMoleArray = []
	
	// 制作临时定序数组
	for(var _i=0; _i<array_length(_lvEquaArray); _i++) {
		tMoleArray = Array_concat_lts(tMoleArray, Get_equa_mole_array(_lvEquaArray[_i], _equa2reactnMap, true))
	}
	
	// 临时定序数组放入输出反应数组相应位置
	for(var _j=0; _j<array_length(tMoleArray); _j++) {
		array_set(oMoleArray, _j*2, tMoleArray[_j]);
	}
	
	// 随机反应分子与条件放入输出反应数组相应位置
	randomize()
	for(var _k=0; _k<array_length(tMoleArray); _k++) {
		array_set(oMoleArray, _k*2+1, tMoleArray[irandom(array_length(tMoleArray)-1)]);
	}
	
	// 去除临时定序数组中的反应条件
	tMoleArray = []
	for(var _i=0; _i<array_length(_lvEquaArray); _i++) {
		tMoleArray = Array_concat_lts(tMoleArray, Get_equa_mole_array(_lvEquaArray[_i], _equa2reactnMap, false))
	}
	
	// 乱序并去首位的反应条件
	randomize()
	Array_shuffle_lts(tMoleArray)
	//Array_shuffle_lts(oMoleArray)
	oMoleArray[0] = tMoleArray[0]
	
	return oMoleArray
}

/// @description Create Molecular Instance (obj_mole)
/// @param  {string}                _moleName [分子式]
/// @param  {ds_grid<struct<cell>>} _cellGrid [背景版]
/// @param  {number}                _x        [X 座标，注意不是 GRID_X]
/// @param  {number}                _y        [Y 座标，注意不是 GRID_Y]
/// @param  {number}				_offsetY  [Y 座标偏移]
/// @return {object}                _moleID   [Created Molecular Instance ID]
function Create_mole_instance_with_offset_y(_moleName, _cellGrid, _x, _y, _offsetY) {

	// Initialization
	var moleID = instance_create_layer(_x, _y, "lay_instance", obj_mole)
	moleID.moleType = _moleName
	
	var atomNameList = Mole_name_to_atom_list(_moleName)
	
	// HERE
	
	moleID.xCoreCell = tilemap_get_cell_x_at_pixel(Get_tilemap_element_from("lay_tileset_mole"), _x, _y)
	moleID.yCoreCell = tilemap_get_cell_y_at_pixel(Get_tilemap_element_from("lay_tileset_mole"), _x, _y) + _offsetY 
	
	// Create First Core Atom
	var currentAtomS = new Atom_constructor_global(_cellGrid[# moleID.xCoreCell, moleID.yCoreCell], moleID, ds_list_find_value(atomNameList, 0), _moleName)
	
		moleID.coreAtom = currentAtomS
	
		currentAtomS.Display()
		
	ds_list_delete(atomNameList, 0)
	ds_list_add(moleID.insideAtomSList, currentAtomS)
	
	// 算法：先随机选取一个原子，再随机观察该原子隔壁的四个位置，如果可行，放邻接的原子；重复
	var selectedAtomName
	var nextcellS
	var newatomS
	var tmpAtomSasSearchRoot

	while (ds_list_size(atomNameList) > 0) {
		
		selectedAtomName = ds_list_find_value(atomNameList, 0)
		ds_list_delete(atomNameList, 0)
		
		// 只需要一重循环：条件是 nextcellS != noone && nextcellS.atomS == noone
		
		do {
			do {
			    tmpAtomSasSearchRoot = Random_from(moleID.insideAtomSList)
				nextcellS = tmpAtomSasSearchRoot.cellS.Random_next_cell()
			
			// 已触及边界，放弃此位置		
			} until (nextcellS != noone); 
			
		// 找到合适空位	    
		} until (nextcellS.atomS == noone);
		
		newatomS = new Atom_constructor_global(nextcellS, moleID, selectedAtomName, _moleName)
		    
		ds_list_add(moleID.insideAtomSList, newatomS)
		
		newatomS.Display()
	}
	
	// Modify Related List in obj_mole
	
	for (var _i=0; _i<ds_list_size(moleID.insideAtomSList); _i++)
		moleID.destinationCellSList[|_i] = moleID.insideAtomSList[|_i].cellS

	for (var _j=0; _j<ds_list_size(moleID.insideAtomSList); _j++)
		moleID.downsideCellSList[|_j] = moleID.insideAtomSList[|_j].cellS.cellDn
	
	return moleID
}

/// @description Create Reaction Condition Instance (obj_cond)
/// @param  {string}                _condition [ Reaction Condition Symbol ]
/// @param  {ds_grid<struct<cell>>} _cellGrid  [ Global Cell Grid ]
/// @param  {number}				_offsetY   [ Y Offset]
/// @return {instance}              
function Create_cond_instance_with_offset_y(_condition, _cellGrid, _offsetY) {
	
	// Initialization
	
	var _x = random_range (REACTOR_LEFT, REACTOR_RIGHT)
	
	while (0 == _x % CELL_SIDE_PX )
		random_range (REACTOR_LEFT, REACTOR_RIGHT)
	
	var _y = 0
	
	var condID = instance_create_layer(_x, _y, "lay_instance", obj_cond)
	
	condID.condType = _condition
	
	// Determine Condition Type
	
	condID.sprite_index = Get_cond_sprite_index(_condition)
	
	// Find Location
	
	condID.xIniCell = tilemap_get_cell_x_at_pixel(Get_tilemap_element_from("lay_tileset_mole"), _x, _y)
	condID.yIniCell = tilemap_get_cell_y_at_pixel(Get_tilemap_element_from("lay_tileset_mole"), _x, _y) + _offsetY 
	
	condID.selfcellS = _cellGrid[# condID.xIniCell, condID.yIniCell]
	
	return condID
}

/* https://www.compart.com/en/unicode/category/Sc */

/* 加热 	₳
   点燃 	₼
   光照 	¤
   放电 	₪
   高温 	¥
   高温高压	₩
   催化剂	@ */
	