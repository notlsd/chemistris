/// LIB_BOND INCLUDES FUNCTIONS TO DRAW BONDS ///
/// -----------------------------------------///
/// @Draw_bond_inside_mole(_atomSList, _moleColor)
/// @Draw_singular_bond(_bondTilemapX, _bondTilemapY, _moleColor, _isVertical)

/// @description Draw bond of a molecule 
/// @param  {ds_list}		_atomSList [ Atom Struct List of a Molecule ]
/// @param  {tilemap_data}	_moleColor [ Tilemap_data of Molecule ]
/// @return {void}	    	   

function Draw_bond_inside_mole(_atomSList, _moleColor) {
	
	/*
	Draw_bond_inside_mole() MOLECULAR LEVEL {
		for() ATOM LEVEL {
			if() UP
			if() DOWN
			if() LEFT
			if() RIGHT
		}
	}
	*/
	
	for(var i_=0; i_<ds_list_size(_atomSList); ++i_) {
		if(_atomSList[|i_].cellS.cellUp != noone && Is_exist_in(_atomSList[|i_].cellS.cellUp.atomS, _atomSList)) {
			Draw_singular_bond(_atomSList[|i_].cellS.gridX*CELL_SIDE_PX_TIMES_BOND, _atomSList[|i_].cellS.gridY*CELL_SIDE_PX_TIMES_BOND-1,  _moleColor, false)
		}
		
		if(_atomSList[|i_].cellS.cellDn != noone && Is_exist_in(_atomSList[|i_].cellS.cellDn.atomS, _atomSList)) {
			Draw_singular_bond(_atomSList[|i_].cellS.gridX*CELL_SIDE_PX_TIMES_BOND, (_atomSList[|i_].cellS.gridY+1)*CELL_SIDE_PX_TIMES_BOND-1,  _moleColor, false)
		}
		
		if(_atomSList[|i_].cellS.cellLt != noone && Is_exist_in(_atomSList[|i_].cellS.cellLt.atomS, _atomSList)) {
			Draw_singular_bond(_atomSList[|i_].cellS.gridX*CELL_SIDE_PX_TIMES_BOND-1, _atomSList[|i_].cellS.gridY*CELL_SIDE_PX_TIMES_BOND,  _moleColor, true)
		}
		
		if(_atomSList[|i_].cellS.cellRt != noone && Is_exist_in(_atomSList[|i_].cellS.cellRt.atomS, _atomSList)) {
			Draw_singular_bond((_atomSList[|i_].cellS.gridX+1)*CELL_SIDE_PX_TIMES_BOND-1, _atomSList[|i_].cellS.gridY*CELL_SIDE_PX_TIMES_BOND,  _moleColor, true)
		}
	}
	
	return
}

/// @description Draw Singular Bond
/// @param  {int}			_bondTilemapX [ X Cell in Bond Tilemap ] 
/// @param  {int}			_bondTilemapY [ Y Cell in Bond Tilemap ] 
/// @param  {tilemap_data}	_moleColor	  [ Tilemap_data of Molecule ]
/// @param  {bool}			_isVertical	  [ Vertival Bond OR Horizontal Bond]
/// @return {void}	    

function Draw_singular_bond(_bondTilemapX, _bondTilemapY, _moleColor, _isVertical) {
	if(_isVertical) {
		
		/* IGNORE WARNING: TWO ROWS */
		//tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), TRANSPARENT, _bondTilemapX, _bondTilemapY)
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), TRANSPARENT, _bondTilemapX, _bondTilemapY)
		
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), _moleColor, _bondTilemapX, _bondTilemapY+1)	
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), _moleColor, _bondTilemapX, _bondTilemapY+2)	
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), _moleColor, _bondTilemapX, _bondTilemapY+3)
		
		/* IGNORE WARNING: TWO ROWS */
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), TRANSPARENT, _bondTilemapX, _bondTilemapY+4)
		//tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), TRANSPARENT, _bondTilemapX, _bondTilemapY+6)
	
	}
	
	else {
		
		/* IGNORE WARNING: TWO ROWS */
		//tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), TRANSPARENT, _bondTilemapX, _bondTilemapY)
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), TRANSPARENT, _bondTilemapX, _bondTilemapY)	
		
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), _moleColor, _bondTilemapX+1, _bondTilemapY)	
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), _moleColor, _bondTilemapX+2, _bondTilemapY)	
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), _moleColor, _bondTilemapX+3, _bondTilemapY)
		
		/* IGNORE WARNING: TWO ROWS */
		tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), TRANSPARENT, _bondTilemapX+4, _bondTilemapY)
		//tilemap_set(Get_tilemap_element_from("lay_tileset_bond"), TRANSPARENT, _bondTilemapX+6, _bondTilemapY)
	}
	
	return
}
