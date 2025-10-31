
if (isCONTROLLED) {
	
	show_debug_message("Counter1")

	var newGridX
	var newGridY

	for (var _i=0; _i<ds_list_size(insideAtomSList); _i++) {
	
		newGridX = self.coreAtom.cellS.gridX - (self.coreAtom.cellS.gridY - insideAtomSList[|_i].cellS.gridY)
	
		newGridY = self.coreAtom.cellS.gridY + (self.coreAtom.cellS.gridX - insideAtomSList[|_i].cellS.gridX)

		if (Is_in_close_interval(newGridX, 0, ds_grid_width(global.cellGrid)-1) && Is_in_close_interval(newGridY, 0, ds_grid_height(global.cellGrid)-1)) {
			destinationCellSList[|_i] = global.cellGrid[# newGridX, newGridY+N_HIDDEN_VER_CELLS]
		}
		else {
			destinationCellSList[|_i] = noone
		}
	}
	
	//x = REACTOR_LEFT + (self.coreAtom.cellS.gridX + 1/2) * CELL_SIDE_PX
	//y = REACTOR_UP   + (self.coreAtom.cellS.gridY + 1/2) * CELL_SIDE_PX
	
	isMOVED = true
	
	show_debug_message("Counter2")
}