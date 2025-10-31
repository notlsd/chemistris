/// @description Build Chapter Map of Level DS Priority
/// @param  {ds_grid}   _lvTable
/// @return {ds_map<ds_priority>}
function Build_chapter_map_of_level_ds_priority_from(_lvTable) {
    
    var mapofPriorityDS = ds_map_create()
    
    // Initialize with HEADER
    for(var _i=ROW_TABLE_1ST_CONTENT; _i<ds_grid_height(_lvTable); _i++){
        
        if(!Is_map_key_exist(mapofPriorityDS, _lvTable[# L3_CHAP, _i])) {
            ds_map_add(mapofPriorityDS, _lvTable[# L3_CHAP, _i], ds_priority_create())
        }

        ds_priority_add(mapofPriorityDS[? _lvTable[# L3_CHAP, _i]], _lvTable[# L0_LEVEL, _i], real(_lvTable[# L4_ORDER, _i]));
    }
    
    return mapofPriorityDS
}

function Victory_pass(_lvName) {
    
    // Save Progess
    global.progressMap[? _lvName] = levelStatus.PASSED

    // Initialize to Unlock Next
    var lvTableY = ds_grid_value_y(global.lvTableGrid, L0_LEVEL, ROW_TABLE_1ST_CONTENT, L0_LEVEL, ds_grid_height(global.lvTableGrid)-1, _lvName);
    
    var lvOrderInChNow = real(global.lvTableGrid[# L4_ORDER, lvTableY])
    
    var chNow = global.lvTableGrid[# L3_CHAP, lvTableY]
    
    var lvPriorityInChNow = global.elementMapofLevelPriorityDS[? chNow]
    
    var chNowMapN = Ds_priority_to_mapn(lvPriorityInChNow)
        
    var chProgessMap = Build_chapter_progress_map(chNowMapN, global.progressMap)
    
    // Update next chapter
    if(Is_all_value_in_the_map_equal_to(chProgessMap, levelStatus.PASSED)) {
        
        var chapArray = global.chapterUnlockMap[? chNow]
        
        for(var _i=0; _i<array_length(chapArray); _i++) {
            
            var lvArray = Ds_priority_find_min_array(global.elementMapofLevelPriorityDS [? chapArray[_i]])
            
            for(var _j=0; _j<array_length(lvArray); _j++) {
				if (global.progressMap[? lvArray[_j]] == levelStatus.LOCKED)
					global.progressMap[? lvArray[_j]] = levelStatus.UNLOCKED
            }   
        }
    }
    
    
    else if(lvOrderInChNow < Ds_priority_find_max_priority(lvPriorityInChNow)) {
        // this level, CHECK NEXT !!!!!!!
        var lvOrderInChNext = lvOrderInChNow + 1
     
        var arrayUnlockedNext = Ds_priority_find_value_array(lvPriorityInChNow, lvOrderInChNext) 
    
        for(var k=0; k<array_length(arrayUnlockedNext); k++) {
            if(global.progressMap[? arrayUnlockedNext[k]] == levelStatus.LOCKED) {
                global.progressMap[? arrayUnlockedNext[k]] = levelStatus.UNLOCKED
            }       
        }
    }
	
	ds_map_secure_save(global.progressMap, "chemistris.dat")
}