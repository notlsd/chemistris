
// Activite algorithm when hit molecular
if (noone != selfcellS.atomS) {
	
	var isAlgoSUCCESS = false
	
	// Break when any one success
	for (var _j = 0; _j < array_length(global.lvArrayEquaPoem); _j++) {
	    if(Algorithm_reaction_global(self, global.lvArrayEquaPoem[_j])) {
			isAlgoSUCCESS = true
			break
		}
	}
	
	instance_destroy(self)

	if(!isAlgoSUCCESS) {
		Falling_next_obj_global()
	}
}

// Self-destroy when hit the bottom
else if (noone == selfcellS.cellDn) {
	
	instance_destroy(self)
	Falling_next_obj_global()
}

// Falling Function
else if (y - yPre > CELL_SIDE_PX) {

	selfcellS = selfcellS.cellDn
	yPre = y
}