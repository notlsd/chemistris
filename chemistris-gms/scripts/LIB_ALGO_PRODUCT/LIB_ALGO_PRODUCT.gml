/// LIB_ALGO_PRODUCT INCLUDES FUNCTIONS RELATED TO PRODUCT SUB ALGORITHM ///
/// --------------------------------------------------------------------///
/// WORKFLOW TO GET mapofPPLA(SM)AS |
/// ---------------------------------
/// @Get_map_of_PPLASMAS(_objArray, _equaName, _productNMap)
/// ⇲⇲⇲ @Update_PPLASMAS_of_whole_list(_equaName, _moleName, _selectedAtomSList)
/// ⇲⇲⇲⇲⇲⇲⇲ @Extract_from(_atomName, _atomSList)
/// ⇲⇲⇲⇲⇲⇲⇲⇲⇲⇲⇲ @Find_search_root_atom_type_global(_equaCode, _moleName)
///	⇲⇲⇲
/// ⇲⇲⇲ @Update_PPLASMAS_with_one_root(_root, _moleName, _selectedAtomSList)
/// ⇲⇲⇲⇲⇲⇲⇲ @Update_PPLASMAS_pseudo_recur_unit(_iPPLASMAS, _arrayNowMax, _selectedAtomSList, _allAtomNameList)
/// ⇲⇲⇲⇲⇲⇲⇲⇲⇲⇲⇲ @Check_cell_struct_with_one_array_of_PPLASMAS(_cellS, _arrayOfiPPLASMAS, _selectedAtomSList, _allAtomNameList, _oPPLASMAS)
/// ---------------------------------
/// WORKFLOW TO GET mapofPPLA(MM)AS |
/// ---------------------------------
/// @Get_map_of_PPLAMMCDC(_mapOfPPLASMAS, _productNMap)
/// ⇲⇲⇲ @Delete_repeated_capsulted_displayed_cell_in(_listOfArrayCDC)
/// ⇲⇲⇲⇲⇲⇲⇲ @Is_capsulted_displayed_cell_repeated(_arrayCDC)
/// ----------------------
/// WORKFLOW TO GET AFAL |
/// ----------------------
/// @Get_algorithm_final_list_of_array(_mapofPPLAMMCDC)
/// ⇲⇲⇲ @Update_AFLA_pseudo_recur_unit(_oAFLA, _iUpdateLA) 

/* 关于返回结构的说明：该结构查找所有分子可能的构型

mapOfPPLA(SM/MM)AS = Map of Possible Product List of Array of Atom Struct

mapOfPPLA(SM/MM)AS 分为单分子(SM) / 多分子(MM) 两个版本

最底层的值是 Atom Struct

其中：Array 是分子中组合的一种可能性
	  List  将所有的 Array 放在同一位置管理
	  Map   中的 Key 是分子式 */

#region WORKFLOW TO GET mapofPPLA(SM)AS

/// e) @Get_map_of_PPLASMAS
///    ⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑
/// d) @Update_PPLASMAS_of_whole_list
/// 	  ⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑
///    2) @Extract_from
///		  ⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑
///    1) @Find_search_root_atom_type_global
///
///    ⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑
/// c) @Update_PPLASMAS_with_one_root
///	   ⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑
/// b) @Update_PPLASMAS_pseudo_recur_unit
///    ⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑
/// a) @Check_cell_struct_with_one_array_of_PPLASMAS

/*  注意，上述流程图和下列程序的放置次序是反的

a) - 找到一个 Cell Struct，检查能否放入 List of Array


b)〔主流程〕
       
   - 对已经存在于返回结构里的每一个 Atom Struct ，沿周围扩大搜索一圈 Cell Struct（生成算法的逆）
       
   - 对结果去重


c) - 搜索完毕某一个起点的分子（当返回结果中的原子数到达分子中原子数时停止）

   - 对结果去重


d)〔选择和组装某一类分子〕

   - 1) 在分子中，选择反应中出现最少的原子类型
	
   - 2) 在这一类原子中选择一个作为起点
   
   - 删除已经搜索过的基点，防止重复
	
   - 合并本类所有搜索起点的结果。
	
   - 删除不完全结果
	
   - 对所有数据进行的可能性组合，当没有重合的时候即为可能的组合


e) - 合并不同种类生成物的结果

RETURN mapOfPPLA(SM)AS 至下一步 */

/// @description Get mapOfPPLA(SM)AS
/// @param  {array<object>}		_objArray	  
/// @param  {string}			_equaName
/// @param  {ds_map<ds_map>}	_productNMap
/// @return {ds_map<ds_list<array<struct<atom>>>>}
function Get_map_of_PPLASMAS(_objArray, _equaName, _productNMap) {
	
	/* mapofPPLASMAS = Map of Possible Product Single Mole Atom-Struct Array List */
	
	var selectedAtomSList = Obj_array_to_atom_struct_list(_objArray)
	
	// Map Initiate
	
	var mapofPPLASMAS = ds_map_create() 
	
	ds_map_copy(mapofPPLASMAS,  _productNMap)
	
	var moleKey = ds_map_find_first(mapofPPLASMAS)
		
	// 将不同种类分子的结果放入 mapOfPPLA(SM)AS
	
	while(!is_undefined(moleKey)) {
		
		// BUGS ON Cl2 + 2NaOH -> NaCl + NaClO
		
		var selectedAtomSList4OneMole = ds_list_create()
		ds_list_copy(selectedAtomSList4OneMole, selectedAtomSList)
		
		mapofPPLASMAS[?moleKey] = Update_PPLASMAS_of_whole_list(_equaName, moleKey, selectedAtomSList4OneMole)
		
		moleKey = ds_map_find_next(mapofPPLASMAS, moleKey)
	}
	
	// 去重！
	
	//mapofPPLASMAS = Delete_repeated_atom_in_map_of_list_of_array(mapofPPLASMAS)
	
	return mapofPPLASMAS
	
}

/// @description Merge Single Root Result
/// @param  {string}								_equaName	  
/// @param  {string}								_moleName
/// @param  {ds_list<struct<atom>>}					_selectedAtomSList
/// @return {ds_map<ds_list<array<struct<atom>>>>} 
function Update_PPLASMAS_of_whole_list(_equaName, _moleName, _selectedAtomSList){
	
	var searchRootAtomType = Find_search_root_atom_type_global(_equaName, _moleName)
	
	var searchRootAtomSList = Extract_from(searchRootAtomType, _selectedAtomSList)

	var oPPLASMAS = ds_list_create()
	
	for (var _n=0; _n<ds_list_size(searchRootAtomSList); _n++) {
		
		var oneRootPPASL = Update_PPLASMAS_with_one_root(searchRootAtomSList[|_n], _moleName, _selectedAtomSList)
		
		oPPLASMAS = Ds_list_merge(oPPLASMAS, oneRootPPASL)
		
		// Delete already searched root
		
		Ds_list_delete_single_value(_selectedAtomSList, searchRootAtomSList[|_n])
	}
	
	oPPLASMAS = Delete_incompleted_array_in(oPPLASMAS) 
	
	oPPLASMAS = Sort_and_delete_repeated_array_in_4(oPPLASMAS)
	
	return oPPLASMAS
}

/// @description Find Search Root Atom Type
/// @param  {string}	_equaCode	  
/// @param  {string}	_moleName
/// @return {string} 
function Find_search_root_atom_type_global(_equaCode, _moleName) {
    // 先找到反应中最少的原子；再找到分子中最少的原子
    
    // moleName -> array[atomName]    
    var atomNameArray = ds_map_keys_to_array(ds_map_find_value(global.mole2atom2nMap, _moleName))
    
    // Equation Level: ds_map<atomN> -> ds_priority<atomN>
    var atomNPriorityEqua = Mapn_to_ds_priority(ds_map_find_value(global.equa2atom2nMap, _equaCode))
    
    // Min atomName of Equation
    var minArrayEqua = Ds_priority_find_min_array(Find_array_in_priority(atomNameArray, atomNPriorityEqua))
    
    // Molecule Level: ds_map<atomN> -> ds_priority<atomN>
    var atomNPriorityMole = Mapn_to_ds_priority(ds_map_find_value(global.mole2atom2nMap, _moleName))
    
    // Min atomName of Molecule
    var minArrayEquaMole = Ds_priority_find_min_array(Find_array_in_priority(minArrayEqua, atomNPriorityMole))
    
    var returnVal =  Random_from(minArrayEquaMole)
    
    return returnVal
}

/// @description Extract from Atom Struct List with Atom Name
/// @param  {string}					_atomName	  
/// @param  {ds_list<struct<atom>>}		_selectedAtomSList
/// @return {ds_list<struct<atom>>} 
function Extract_from(_atomName, _atomSList) {
	
	var selectedAtomSList = ds_list_create()
	
	for(var _i=0; _i<ds_list_size(_atomSList); _i++)
		if(_atomSList[|_i].atomName == _atomName)
			ds_list_add(selectedAtomSList, _atomSList[|_i])
	
	return selectedAtomSList
}

/// @description Search One Molecule from One Root
/// @param  {string}								_root	  
/// @param  {string}								_moleName
/// @param  {ds_list<struct<atom>>}					_selectedAtomSList
/// @return {ds_map<ds_list<array<struct<atom>>>>} 
function Update_PPLASMAS_with_one_root(_root, _moleName, _selectedAtomSList) {   
	
	var allAtomNameList = Mole_name_to_atom_list(_moleName)
	
	var arrayLength = ds_list_size(allAtomNameList)
	
	var oPPLASMAS = ds_list_create()
	
	oPPLASMAS[|0] = array_create(arrayLength, noone)
	oPPLASMAS[|0][0] = _root
	
	for (var _arrayNowMax = 0; _arrayNowMax < arrayLength - 1; _arrayNowMax++) {
		 oPPLASMAS = Update_PPLASMAS_pseudo_recur_unit(oPPLASMAS, _arrayNowMax, _selectedAtomSList, allAtomNameList)
	}
	
	oPPLASMAS = Sort_and_delete_repeated_array_in_4(oPPLASMAS)
	
	return oPPLASMAS
}

/// @description Check all surrendings of PPLASMAS then update 
/// @param  {ds_list<array<struct<atom>>>}	_iPPLASMAS		
/// @param  {int}							_arrayNowMax
/// @param  {ds_list<struct<atom>>}			_selectedAtomSList
/// @param  {ds_list<string>}				_allAtomNameList
/// @return {ds_list<array<struct<atom>>>} 
function Update_PPLASMAS_pseudo_recur_unit(_iPPLASMAS, _arrayNowMax, _selectedAtomSList, _allAtomNameList){
	
	var oPPLASMAS = ds_list_create()
	
	for(var _li=0; _li<ds_list_size(_iPPLASMAS); _li++) {
		for(var _ai=0; _ai<=_arrayNowMax; _ai++) {
			Check_cell_struct_with_one_array_of_PPLASMAS(_iPPLASMAS[|_li][_ai].cellS.cellUp, _iPPLASMAS[|_li], _selectedAtomSList, _allAtomNameList, oPPLASMAS)
			Check_cell_struct_with_one_array_of_PPLASMAS(_iPPLASMAS[|_li][_ai].cellS.cellDn, _iPPLASMAS[|_li], _selectedAtomSList, _allAtomNameList, oPPLASMAS)
			Check_cell_struct_with_one_array_of_PPLASMAS(_iPPLASMAS[|_li][_ai].cellS.cellLt, _iPPLASMAS[|_li], _selectedAtomSList, _allAtomNameList, oPPLASMAS)
			Check_cell_struct_with_one_array_of_PPLASMAS(_iPPLASMAS[|_li][_ai].cellS.cellRt, _iPPLASMAS[|_li], _selectedAtomSList, _allAtomNameList, oPPLASMAS)
		}
	}
	
	oPPLASMAS = Sort_and_delete_repeated_array_in_4(oPPLASMAS)
	
	return oPPLASMAS
}

/// @description Check Cell Struct to See if it Can Put into Array of PPLASMAS
/// @param  {struct<cell>}                  _cellS            
/// @param  {array<struct<atom>>}			_arrayOfiPPLASMAS     
/// @param  {ds_list<struct<atom>>}         _selectedAtomSList
/// @param  {ds_list<string>}               _allAtomNameList
/// @param  {ds_list<array<struct<atom>>>}	_oPPLASMAS
/// @return {void}  
function Check_cell_struct_with_one_array_of_PPLASMAS(_cellS, _arrayOfiPPLASMAS, _selectedAtomSList, _allAtomNameList, _oPPLASMAS){
    
    /* Notice that _cellS is not PPLASMAS[n].cellS ! */
    
    // Check if Space Available
    
    if (_cellS == noone) {  
        return 
    }
    
    // Delete What Already Searched
    
    var remainSelectedAtomSList = ds_list_create()
    var remainAtomNameList = ds_list_create()
    
    ds_list_copy(remainSelectedAtomSList, _selectedAtomSList)
    ds_list_copy(remainAtomNameList, _allAtomNameList)
    
    var n = 0
    while (_arrayOfiPPLASMAS[n] != noone) {
        Ds_list_delete_single_value(remainSelectedAtomSList, _arrayOfiPPLASMAS[n])
        Ds_list_delete_single_value(remainAtomNameList, _arrayOfiPPLASMAS[n].atomName)
        n++
    }
    
    // Add Suitable Value to oPPLASMAS
    
    if (Is_exist_in(_cellS.atomS, remainSelectedAtomSList)) {
        if (Is_exist_in(_cellS.atomS.atomName, remainAtomNameList)) {
			
			// var arrayOfoPPLASMAS = Array_copy_by_value(_arrayOfiPPLASMAS)
			
			var arrayOfoPPLASMAS = []
			array_copy(arrayOfoPPLASMAS, 0, _arrayOfiPPLASMAS, 0, array_length(_arrayOfiPPLASMAS))
			
            arrayOfoPPLASMAS[n] = _cellS.atomS
            ds_list_add(_oPPLASMAS, arrayOfoPPLASMAS)
        }
    }
}

#endregion
#region WORKFLOW TO GET mapofPPLA(MM)AS

/// a) @Get_map_of_PPLAMMCDC

/* - 对 mapOfPPLA(SM)AS 中每一个 KEY（分子）中的结果进行 C(n=List长度,k=生成物分子数) 组合，得到 mapOfPPLA(MM)AS

	- 对结果去重

RETURN mapOfPPLA(MM)AS 至下一步 */

/// @description Merge to mapofPPLA(SM)CDC to get mapofPPLA(MM)CDC
/// @param  {ds_map<ds_list<array<struct<capsuled_displayed_cell>>>>} _mapofPPLASMCDC
/// @param  {ds_map}												  _productNMap
/// @return {ds_map<ds_list<array<struct<capsuled_displayed_cell>>>>}
function Get_map_of_PPLAMMCDC(_mapofPPLASMCDC, _productNMap) {

	// _mapofPPLASMCDC = Map of Possible Product List of Array Singular-Mole Capsuled Displayed Cell 
	
	/// mapofPPLAMMCDC = Map of Possible Product List of Array Multiple-Mole Capsuled Displayed Cell
	
	var mapofPPLAMMCDC = ds_map_create()
	
	ds_map_copy(mapofPPLAMMCDC, _mapofPPLASMCDC)
	
	var moleKey = ds_map_find_first(mapofPPLAMMCDC)

	while(!is_undefined(moleKey)) {
		
		// 对同一类型的生成物分子进行组合 C(n,k)
		
		var listofCnkedPPLASMCDC = Cnk_from(mapofPPLAMMCDC[?moleKey], _productNMap[?moleKey])
		
		var oPPLAMMCDC = ds_list_create()
		
		for(var _i = 0; _i < ds_list_size(listofCnkedPPLASMCDC); _i++)
			ds_list_add(oPPLAMMCDC, Cascade_to_array(listofCnkedPPLASMCDC[|_i]))
		
		oPPLAMMCDC = Delete_repeated_capsulted_displayed_cell_in(oPPLAMMCDC)
		
		mapofPPLAMMCDC[? moleKey] = oPPLAMMCDC
		
		moleKey = ds_map_find_next(mapofPPLAMMCDC, moleKey)
	}
	
	return mapofPPLAMMCDC
}


/// @description Delete Repeated Capsulted Displayed Cell
/// @param  ds_list<array<capsulted_displayed_cell>>
/// @return ds_list<array<capsulted_displayed_cell>>
function Delete_repeated_capsulted_displayed_cell_in(_listOfArrayCDC) {
	
	var _m = 0
	while (_m < ds_list_size(_listOfArrayCDC)) {
		if (Is_capsulted_displayed_cell_repeated(_listOfArrayCDC[|_m]))
			ds_list_delete(_listOfArrayCDC, _m)
		else
			_m++
	}
	
	return _listOfArrayCDC
}

/// @description Determin If Capsulted Displyed Cell Repeated in Given Array 
/// @param  {ds_list<array<capsulted_displayed_cell>>}
/// @return {bool}
function Is_capsulted_displayed_cell_repeated(_arrayCDC){
	for(var _i=0; _i < array_length(_arrayCDC); _i++)
		for(var _p=0; _p < array_length(_arrayCDC); _p++) 
			if(_p != _i)
				if(_arrayCDC[_i].dcAtomS == _arrayCDC[_p].dcAtomS)
					return true

	return false
}

////---------------------

#endregion 
#region WORKFLOW TO GET AFAL

/// a) @Get_algorithm_final_list_of_array
///       ⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑⇑
///	   1) @Update_AFLA_pseudo_recur_unit

/* - 利用类似于矩阵合并的运算（参见 LIB_ALGO_PRODUCT 最末注释），将 mapOfPPLA(MM)AS 中的 Map 结构去除，转换为纯粹的 List of Array

RETURN Algorithm-Final-List-of-Array (AFAL) 作为算法的最终返回数据 */

/// @description Get Final Data form of Algorithm as List of Array 
/// @param  {ds_map<ds_list<array<struct<atom>>>>}
/// @return {ds_list<array<struct<atom>>>}
function Get_algorithm_final_list_of_array(_mapofPPLAMMCDC){
	
	var key1 = ds_map_find_first(_mapofPPLAMMCDC)
	var key2 = ds_map_find_next(_mapofPPLAMMCDC, key1)
	var originLA = List_of_array_copy_by_value(_mapofPPLAMMCDC[? key1])
	
	if(is_undefined(key2))
		return originLA
		
	else {
		while(!is_undefined(key2)) {
			originLA = Update_AFLA_pseudo_recur_unit(originLA, _mapofPPLAMMCDC[? key2])
			key2 = ds_map_find_next(_mapofPPLAMMCDC, key2)
		}
		
		return originLA 
	}
	
}

/// @description Get Final Data form of Algorithm as List of Array 
/// @param  {ds_map<ds_list<array<struct<atom>>>>}
/// @return {ds_list<array<struct<capsuled_displayed_cell>>>}
function Get_algorithm_final_list_of_array_1(_mapofPPLAMMCDC){
	
	var key1 = ds_map_find_first(_mapofPPLAMMCDC)
	var key2 = ds_map_find_next(_mapofPPLAMMCDC, key1)
	var oAFLA = List_of_array_copy_by_value(_mapofPPLAMMCDC[? key1])
	
	if(is_undefined(key2))
		return oAFLA
		
	else {
		while(!is_undefined(key2)) {
			oAFLA = Update_AFLA_pseudo_recur_unit_1(oAFLA, _mapofPPLAMMCDC[? key2])
			key2 = ds_map_find_next(_mapofPPLAMMCDC, key2)
		}
		
		return oAFLA
	}
	
}	


//modify original but Add new in recur

/// @description Update Algorithm Final List of Array by Extend and Merge Matrix
/// @param  {<ds_list<array>>} _oAFLA
/// @param  {<ds_list<array>>} _iUpdateLA
/// @return {<ds_list<array>>}
/// @description Update Algorithm Final List of Array by Extend and Merge Matrix
/// @param  {<ds_list<array>>} _oAFLA
/// @param  {<ds_list<array>>} _iUpdateLA
/// @return {<ds_list<array>>}
function Update_AFLA_pseudo_recur_unit_1(_oAFLA, _iUpdateLA) {
	
	
	var listSizeOriginalAFLA = ds_list_size(_oAFLA)
	
	var tmpStorageAFLA = List_of_array_copy_by_value(_oAFLA)
	
	// Step I: Detailed Comment Below
	//if(ds_list_size(_iUpdateLA)>1)
		for (var i=1; i<ds_list_size(_iUpdateLA); i++)
			Ds_list_merge(_oAFLA, tmpStorageAFLA)
	
	// Step II: Detailed Comment Below
	
	var k=0;
	while(k<ds_list_size(_oAFLA)) {
		for (var j=0; j<ds_list_size(_iUpdateLA); j++) {
			repeat(listSizeOriginalAFLA) {
				Array_concat_lts(_oAFLA[|k], Array_copy_by_value(_iUpdateLA[|j]))
				k++
			}		
		}
	}
		
		//var tmp = []
		//array_copy(tmp, 0, _iUpdateLA[|(k div (ds_list_size(_oAFLA) div ds_list_size(_iUpdateLA)))], 0, array_length(_iUpdateLA[|(k div (ds_list_size(_oAFLA) div ds_list_size(_iUpdateLA)))]))
		//Array_concat_lts(_oAFLA[|k], Array_copy_by_value(_iUpdateLA[|(k div (ds_list_size(_oAFLA) div ds_list_size(_iUpdateLA)))]))
		
		//Array_concat_lts(_oAFLA[|k] ,Array_copy_by_value(_iUpdateLA[|(k div (ds_list_size(_oAFLA) div ds_list_size(_iUpdateLA)))]))
		show_debug_message("HERE")
	
	//}
	
	return _oAFLA
	
	/* DETAILED COMMENT ABOUT @Update_AFLA_pseudo_recur_unit

	NO SIZE LIMIT OF _oAFLA & _iUpdateLA
	
	#eg. _oAFLA
	
	[ A00 A01 A02 A03 ]
	[ A10 A11 A12 A13 ]
	[ A20 A21 A22 A23 ]
	
	#eg. _iUpdateLA
			      
	[ B00 B01 ]
	[ B10 B11 ]
	
	# STEP I
	
	[ A00 A01 A02 A03 ]
	[ A10 A11 A12 A13 ]
	[ A20 A21 A22 A23 ]
	[ A00 A01 A02 A03 ]
	[ A10 A11 A12 A13 ]
	[ A20 A21 A22 A23 ]
	
	# STEP II
	
	_j % ds_list_size(_iUpdateLA) set each B row in right position elegantly
	
	[ A00 A01 A02 A03 B00 B01 ]
	[ A10 A11 A12 A13 B00 B01 ]
	[ A20 A21 A22 A23 B00 B01 ]
	[ A00 A01 A02 A03 B10 B11 ]
	[ A10 A11 A12 A13 B10 B11 ]
	[ A20 A21 A22 A23 B10 B11 ]
	
	returnOLA = STEP II Result */
}

/// ---------------

#endregion


/// @func Update_AFLA_pseudo_recur_unit(_oAFLA, _iUpdateLA)
/// @arg {array} _oAFLA
/// @arg {array} _iUpdateLA
function Update_AFLA_pseudo_recur_unit_2(_oAFLA, _iUpdateLA) {
    var returnOLA = [];
    var originalLength = array_length(_oAFLA);
    var updateLALength = array_length(_iUpdateLA);

    // Step I: Duplicate _oAFLA
    for (var i = 0; i < originalLength; ++i) {
        array_push(returnOLA, _oAFLA[i]);
        array_push(returnOLA, _oAFLA[i]);  // Duplicate each row
    }

    // Step II: Append _iUpdateLA rows
    for (var i = 0; i < array_length_2d(returnOLA, 0); ++i) {
        var updateRow = _iUpdateLA[i % updateLALength];
        for (var j = 0; j < array_length_1d(updateRow); ++j) {
            array_push(returnOLA[i], updateRow[j]);
        }
    }

    return returnOLA;
}

