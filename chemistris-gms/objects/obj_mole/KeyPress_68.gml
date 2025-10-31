if (isCONTROLLED) {

	for (var _i=0; _i<ds_list_size(insideAtomSList); _i++)
		destinationCellSList[|_i] = insideAtomSList[|_i].cellS.cellRt

	if (Is_mole_destination_allowed(self.id, destinationCellSList) && (x + CELL_SIDE_PX) < REACTOR_RIGHT) {
		x+=CELL_SIDE_PX
		isMOVED = true
	}
}