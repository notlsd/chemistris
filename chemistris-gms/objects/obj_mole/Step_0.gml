
if (isCONTROLLED) {

	// "DEAD" When Bottom Touched

	if (!Is_mole_destination_allowed(self.id, downsideCellSList)) {
	
		isCONTROLLED = false

		#region ESTABLISH GRAPH
		// Bio-directional link established @Update_s_obj_mole_list_from
	
		for (var _j=0; _j<ds_list_size(insideAtomSList); _j++) {
			Update_s_obj_mole_list_from(insideAtomSList[|_j].cellS.cellUp, self.id, sObjMoleList)
			Update_s_obj_mole_list_from(insideAtomSList[|_j].cellS.cellDn, self.id, sObjMoleList)
			Update_s_obj_mole_list_from(insideAtomSList[|_j].cellS.cellLt, self.id, sObjMoleList)
			Update_s_obj_mole_list_from(insideAtomSList[|_j].cellS.cellRt, self.id, sObjMoleList)
		}

		#endregion
		#region JUDGE FAILURE
		var countAtomDisplayed4FAILURE = 0
		
		for (var _n=0; _n<ds_list_size(insideAtomSList); _n++) {
			if(insideAtomSList[| _n].Display())
				countAtomDisplayed4FAILURE++
		}
				
		if (countAtomDisplayed4FAILURE < ds_list_size(insideAtomSList))
			instance_create_layer(0, 0, "lay_page", obj_page_fail)
		
		#endregion
		#region INITIALIZE NEXT
		else {
			for (var _j = 0; _j < array_length(global.lvArrayEquaPoem); _j++) {
				if(Algorithm_reaction_global(self, global.lvArrayEquaPoem[_j])) {
					isDELETED = true
					break
				}
			}
			
			if(!isDELETED)
				Falling_next_obj_global() 
		}
		#endregion
	}

	if (!isDELETED) {
		
		#region FALL NORMALY
		if (yNowCell != tilemap_get_cell_y_at_pixel(Get_tilemap_element_from("lay_tileset_mole"), x, y)/*y - yPre > CELL_SIDE_PX*/) {
		
			for (var _i=0; _i<ds_list_size(insideAtomSList); _i++) {
				destinationCellSList[|_i] = insideAtomSList[|_i].cellS.cellDn
				downsideCellSList[|_i] = insideAtomSList[|_i].cellS.cellDn
			}

			yNowCell = tilemap_get_cell_y_at_pixel(Get_tilemap_element_from("lay_tileset_mole"), x, y)
			
			yPre = y
			
			isMOVED = true
		}
		
	
		#endregion
	
		if (isMOVED) {
			
			x = REACTOR_LEFT + (self.coreAtom.cellS.gridX + 1/2) * CELL_SIDE_PX
			//y = REACTOR_UP   + (self.coreAtom.cellS.gridY + 1/2) * CELL_SIDE_PX
			
			if (Is_mole_destination_allowed(self.id, destinationCellSList)) {
				
				#region REDRAW WHEN SUCCESSFULLY MOVED
				for (var _m=0; _m<ds_list_size(insideAtomSList); _m++) {
					insideAtomSList[| _m].Erase()
				}
			
				Recouple_atom_to_new_cell_via_list(insideAtomSList, destinationCellSList)
			
				Draw_bond_inside_mole(insideAtomSList, global.moleTilemap[? moleType])
			
				for (var _n=0; _n<ds_list_size(insideAtomSList); _n++)
					insideAtomSList[| _n].Display()
			
				vspeed = ivSpeed
					
				#endregion
				isMOVED = false
				
				//xNowCell = tilemap_get_cell_x_at_pixel(Get_tilemap_element_from("lay_tileset_mole"), x, y)
			}
		}
	}
}

#region DEBUG

//if(debug_mode) {
//	show_debug_message("LIVESTEAM DATA @obj_mole")
//	show_debug_message("X-CORE-CELL = " + string(xCoreCell))
//	show_debug_message("Y-CORE-CELL = " + string(yCoreCell))
//	show_debug_message("X = " + string(x))
//	show_debug_message("Y = " + string(y))
//	show_debug_message("")
//}

#endregion