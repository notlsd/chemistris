/// LIB_ALGO_MAIN INCLUDES FUNCTIONS RELATED TO MAIN ALGORITHM FLOW ///
/// ---------------------------------------------------------------///
/// @Algorithm_reaction_global(_self, _equaPoem)
/// @Algorithm_backend_global(_inID, _equaPoem)
/// @Algorithm_frontend_global(_algoBackendReturnS, _lvCounterArray)
/// @Algorithm_backend_return_constructor(_arrayReactantObj, _arrayDisplayedCapsuledCell, _produ2nMap)

/// @description Main Stream of Reaction Algorithm
/// @param  {instance}	_self	  [ Calling Instance ID ]
/// @param  {string}	_equaPoem [ Equation Poem ]
/// @return {bool}
function Algorithm_reaction_global(_self, _equaPoem) {
	
	#region MAJOR FLOW COMMENT
	
	/* 反应算法的主要流程：

	- 在算法调用前通过 equa2react2nMap 做一波预判断

		- obj_cond 入口：判断自身是否存在于 equaPoem 对应方程中，存在执行移除 obj_cond 之后的算法

		- obj_mole 入口：搜索自身是否存在于 equaPoem 对应方程中，若有，再搜索是否需要 obj_cond，若不需要，则执行算法

	- 执行核心前端 / 后端算法 */

	#endregion
	#region INITIALIZATION
	
	_self.speed = 0
	
	var inID = noone
	
	var reactArrayINC = Get_equa_mole_array(_equaPoem, global.equa2react2nMap, true)
	
	var reactArrayEXC = Get_equa_mole_array(_equaPoem, global.equa2react2nMap, false)
	
	#endregion
	#region ENTRANCE SPLITTING
	
	// OBJ_COND Entrance
	
	if (_self.object_index == asset_get_index("obj_cond")) {
		
		if (Is_exist_in(_self.condType, reactArrayINC))
			inID = _self.selfcellS.atomS.moleID
		else
			return false
	}
	
	// OBJ_MOLE Entrance
	
	else if (_self.object_index == asset_get_index("obj_mole")) {
		
		if ((array_length(reactArrayINC) == array_length(reactArrayEXC)) && Is_exist_in(_self.moleType, reactArrayINC))
		
			inID = _self.id
		else
			return false
	}
	
	// Entrance Error
	
	else
		show_error("@Algorithm_reaction_global | ERR! ILLEAGAL ALGORITHM CALLING INSTANCE",true)
	
	#endregion
	#region EXCUTION
	
	var algoBackendReturnS = Algorithm_backend_global(inID, _equaPoem)
	
	if(is_undefined(algoBackendReturnS)) {
		return false
	}
	
	else {
		//if(Algorithm_banned_global(algoBackendReturnS, global.lvArrayBanned)) {
		//	return true
		//}	
		
		if(Algorithm_frontend_global(algoBackendReturnS, global.lvArrayCounter, global.lvArrayBanned))
			return true
	}
	
	#endregion
}

/// @description Data Flow of Reaction Algorithm
/// @param  {instance}	_inID	[ Instance ID to Initialize Algorithm ]
/// @param  {string}	_equaPoem				  [ Equation Poem Code]
/// @return {struct<algorithm_backend_return>}    [ Success ]	    
/// @return {undefined}						      [ Fail ]
function Algorithm_backend_global(_inID, _equaPoem){
	
	#region MAJOR FLOW COMMENT
	
	/* 后端算法的主要流程：
	
	前半部分 (Pre-algoritm) 位于 LIB_ALGO_REACTANT：
	
	- 搜索参与反应的 OBJ，返回 reactantObjListOfArray，其中每个 Array 是一种可能的 OBj 组合
	
	- 去除不合法的的结果
	
		- 若不存在合法的结果则直接退出算法
	
		- 若存在合法的部分则将结果抛入后半部分
	
	后半部分 (Post-algoritm) 位于 LIB_ALGO_PRODUCT：
	
	- 读取 reactantObjListOfArray 中的某一结果，循环执行以下操作 #eg.# 2 * H2O -> 2 * H2 + O2 
	
		- 生成 mapofPPLASMAS = Map of Possible Product List of Array of Single Molecular Atom Struct 
		
		#eg.# map → H2 → [ Ha1 Ha2 ]
				  ↓	   ↳ [ Hb1 Hb2 ]
			      ↓	   ↳ [ Hc1 Hc2 ]
			      ↓
			      ↳ O2 → [ Oa1 Oa2 ]
		
		-------------------------------------------------------------------------------------------
		
		- 生成 mapofPPLASMAS = Map of Possible Product List of Array of Multi Molecular Atom Struct 
	
		#eg.# map → H2 → [ Ha1 Ha2 Hb1 Hb2 ]
			      ↓	   ↳ [ Ha1 Ha2 Hc1 Hc2 ]
			      ↓	   ↳ [ Hb1 Hb2 Hc1 Hc2 ]
			      ↓
			      ↳ O2 → [ Oa1 Oa2 ]
		
		------------------------------
			      
		- 生成 algorithmFinalListOfArray
		
		#eg.# [ Ha1 Ha2 Hb1 Hb2 Oa1 Oa2 ]
			  [ Ha1 Ha2 Hc1 Hc2 Oa1 Oa2 ]
			  [ Hb1 Hb2 Hc1 Hc2 Oa1 Oa2 ]
	
		- 若 algorithmFinalListOfArray 存在合法结果，构造 AlgorithmBackendReturnStruct（包括：选定的反应物 selectedObjArray； 有效的生成物之一 algorithmFinalListOfArray[|0]；）并返回
		
	- 若以上结果任意为空，则退出本次循环
	
	- 若后端算法执行至末尾，仍无有效结果，返回 undefined */
	
	#endregion
	#region PRE-ALGORITHM (REACTANT) 
	
	var _reactantNameArray = Get_equa_mole_array(_equaPoem, global.equa2react2nMap, false)
	
	var reactantObjListOfArray = Get_reactant_obj_list_of_array(_inID, _reactantNameArray)

	// Find Nothing
	reactantObjListOfArray = Delete_incompleted_array_in(reactantObjListOfArray)
	if(0 == ds_list_size(reactantObjListOfArray)) 
		return undefined
			
	// Delete Repeated
	reactantObjListOfArray = Sort_and_delete_repeated_array_in_4(reactantObjListOfArray)
	if(0 == ds_list_size(reactantObjListOfArray)) 
		return undefined
		
	// Delete Unmatched
	reactantObjListOfArray = Delete_unmatched_mole_obj_array_with(reactantObjListOfArray, _reactantNameArray)
	if(0 == ds_list_size(reactantObjListOfArray)) 
		return undefined	
	
	#endregion
	#region DEBUGER
	Debuger_list_of_array(reactantObjListOfArray)
	#endregion
	#region POST-ALGORITHM (PRODUCT)
	
	while(ds_list_size(reactantObjListOfArray)>0) {
	
		// Select one of results of reactantObjListOfArray to deal with
		var selectedObjArray = Random_from(reactantObjListOfArray)
		var seletedIndex = ds_list_find_index(reactantObjListOfArray, selectedObjArray)
		ds_list_delete(reactantObjListOfArray, seletedIndex)
		
		var produ2nMap = ds_map_create()
		
		ds_map_copy(produ2nMap, ds_map_find_value(global.equa2produ2nMap, _equaPoem))
		
		/* mapofPPLASMAS = Map of Possible Product List of Array of Singular-Mole Atom Struct */
		var mapofPPLASMAS = Get_map_of_PPLASMAS(selectedObjArray, _equaPoem, produ2nMap)
		if(Is_list_empty_in(mapofPPLASMAS)) 
			continue
	
		/* mapofPPLASMAS = Map of Possible Product List of Array of Singular-Mole Capsuled Displayed Cell 
		   Capsule Selected Data to Display Format */
		var mapofPPLASMCDC = Encapsule_displayed_cell_map_of_PPLASMAS(mapofPPLASMAS)
		
		/* mapofPPLASMAS = Map of Possible Product List of Array of Multiple-Mole Capsuled Displayed Cell */
		var mapofPPLAMMCDC = Get_map_of_PPLAMMCDC(mapofPPLASMCDC, produ2nMap)
		if(Is_list_empty_in(mapofPPLAMMCDC)) 
			continue
		
		/* Deal with algorithmFinalListOfArray */
		var algorithmFinalListOfArray = Get_algorithm_final_list_of_array_1(mapofPPLAMMCDC)
	
		
		/* Finally Repeatition Deletion, Lack of It Resulted in Serious Bug*/
		Delete_repeated_capsulted_displayed_cell_in(algorithmFinalListOfArray)
		
		/* Notice that for one reactant combination, there might be multiple legal result, using [|0] to return random one */
		if(ds_list_size(algorithmFinalListOfArray)>0)
			return new Algorithm_backend_return_constructor(selectedObjArray, algorithmFinalListOfArray[|0], produ2nMap)
	}

	return undefined
	#endregion
}

/// @description Display the Result of Backend Algorithm
/// @param  {struct<algo_backend_return>} _algoBackendReturnS 
/// @param  {array<string>}	              _lvCounterArray [ Array of Counter Name in Level]
/// @return {bool}
function Algorithm_frontend_global(_algoBackendReturnS, _lvCounterArray, _lvArrayBanned) {
	
	for (var k = 0; k<array_length(_lvArrayBanned); k++) {
		if(Is_map_key_exist(_algoBackendReturnS.produ2nMap, _lvArrayBanned[k])) {
			instance_create_layer(0, 0, "lay_page", obj_page_fail)
			return true
		}
	}	
	
	
	if(Is_map_key_exist(_algoBackendReturnS.produ2nMap, _lvCounterArray[0])) {
		
		Counter_update(_algoBackendReturnS, _lvCounterArray)
		
		Counter_draw( "lay_tileset_counter", _lvCounterArray)
		
		// Level Success		
		if(array_length(_lvCounterArray) <= 0)
			instance_create_layer(0, 0, "lay_page", obj_page_success)
		
		// Step Success	
		else {
			
			for (var _i = 0; _i < array_length(_algoBackendReturnS.arrayReactantObj); _i++) {
				instance_destroy(_algoBackendReturnS.arrayReactantObj[_i])
			}
	
			instance_create_layer(x, y, "lay_instance", obj_disp, {
		
				produ2nMap: _algoBackendReturnS.produ2nMap,
				arrayDisplayedCapsuledCell: _algoBackendReturnS.arrayDisplayedCapsuledCell
		
			});
						
		}
		
		return true
	}
	
	else
		return false
}

/// @description Constructor of Return Struct of Backend Algorithm
/// @param {array<object>}			_arrayReactantObj
/// @param {array<struct<atom>>}	_arrayDisplayedCapsuledCell 
/// @param {ds_map} 				_produ2nMap
function Algorithm_backend_return_constructor(_selectedObjArray, _algorithmFinalArray, _produ2nMap) constructor {
	
	/*	arrayReactantObj: Data of Reactant to Destory
		arrayDisplayedCapsuledCell: Data of Product to Display
		produ2nMap: NMAP of Product to transfer array back to Map for Display */
	
	arrayReactantObj = _selectedObjArray;
	arrayDisplayedCapsuledCell = _algorithmFinalArray
	produ2nMap = _produ2nMap
}

function Algorithm_banned_global(_algoBackendReturnS, _lvArrayBanned) {
	
	for (var _i = 0; _i < array_length(_lvArrayBanned); _i++) {
		if(Is_map_key_exist(_algoBackendReturnS.produ2nMap, _lvArrayBanned[_i]))
			instance_create_layer(0, 0, "lay_page", obj_page_fail)
	}		
}