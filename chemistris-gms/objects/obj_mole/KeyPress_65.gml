
if (isCONTROLLED) {

	for (var _i=0; _i<ds_list_size(insideAtomSList); _i++)
		destinationCellSList[|_i] = insideAtomSList[|_i].cellS.cellLt

	if (Is_mole_destination_allowed(self.id, destinationCellSList) && (x - CELL_SIDE_PX) > REACTOR_LEFT) {
		x-=CELL_SIDE_PX
		//hspeed = -10
		isMOVED = true
		
	}
}
