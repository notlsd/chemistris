function Clean_level_table_grid(_lvTableGrid) {
	
	var arrayAbandoned = []
	
	for(var i=ROW_TABLE_1ST_CONTENT; i<ds_grid_height(_lvTableGrid); i++) {
		if(_lvTableGrid[# L6_ON, i] == "No")
			array_push(arrayAbandoned, i)
	}
	
	Ds_grid_delete_rows(_lvTableGrid, arrayAbandoned) 
}

function Ds_grid_delete_rows(_gridID, _arrayRow) {
	
	array_sort(_arrayRow, true)
	
	for(var i=0; i<array_length(_arrayRow); i++) {
		
		ds_grid_set_grid_region(_gridID, _gridID, 0, _arrayRow[i]+1, ds_grid_width(_gridID), ds_grid_height(_gridID), 0, _arrayRow[i]);
		
		for(var k=i; k<array_length(_arrayRow); k++) {
			_arrayRow[k] -= 1
		}	
		
		ds_grid_resize(_gridID, ds_grid_width(_gridID), ds_grid_height(_gridID)-1);
	}
}