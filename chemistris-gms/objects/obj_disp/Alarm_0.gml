/// @description RENEW GAME BOARD

instance_destroy(self)

#region FALLING OTHERS AFTER SELF-DESTRUCTION

do {

	ds_list_clear(listFlagOthersFallAfterSelfDestroy)

	with(obj_mole) {
		
		if (Is_mole_destination_allowed(id, downsideCellSList)) {
	
			#region ERASE PREVIOUS POSITION
			for (var _m=0; _m<ds_list_size(insideAtomSList); _m++) {
				insideAtomSList[| _m].Erase()
			}
				
			Recouple_atom_to_new_cell_via_list(insideAtomSList, downsideCellSList)
			
			#endregion
			#region DISPLAY NEW POSITION & UPDATE DATA STRUCTURE	
			Draw_bond_inside_mole(insideAtomSList, global.moleTilemap[? moleType])
					
			for (var _n=0; _n<ds_list_size(insideAtomSList); _n++) { 
				
				insideAtomSList[| _n].Display()
				
				destinationCellSList[|_n] = insideAtomSList[|_n].cellS.cellDn
				
				downsideCellSList[|_n] = insideAtomSList[|_n].cellS.cellDn
					
				Update_s_obj_mole_list_from(insideAtomSList[|_n].cellS.cellUp, id, sObjMoleList)
				Update_s_obj_mole_list_from(insideAtomSList[|_n].cellS.cellDn, id, sObjMoleList)
				Update_s_obj_mole_list_from(insideAtomSList[|_n].cellS.cellLt, id, sObjMoleList)
				Update_s_obj_mole_list_from(insideAtomSList[|_n].cellS.cellRt, id, sObjMoleList)
			}
			
			#endregion
			ds_list_add(other.listFlagOthersFallAfterSelfDestroy, id)
		}
	}
} until (ds_list_empty(listFlagOthersFallAfterSelfDestroy))

#endregion
Falling_next_obj_global() 





