/// LIB_DATA_MAP INCLUDES CORE DATA ABOUT NAME-TILESET/COLOR PAIRS ///
/// --------------------------------------------------------------///
/// @global.atomTilemap -> 元素（原子）的字表
///
/// @global.moleTilemap -> 分子与相应的图形素材的对应表（注意有三个，分子方框表[50*50px，厚5px 的方框]，分子小砖表[5*5px，实心]与计数器表[尺寸待定,若需要灌满 / 倒空效果，需要另行处理]，请保持其序列的完全一致）

/// @global.moleColorMap -> 请选择合适的编码格式，参阅下方链接
/// https://manual.yoyogames.com/#t=GameMaker_Language%2FGML_Reference%2FDrawing%2FColour_And_Alpha%2FColour_And_Alpha.htm&rhsearch=color

/* BUGS ON TILESET_LAYER: When change spr_tileset_ but nothing happens, just change the tileset in room / layer, change the tileset and then change back*/

#region ATOM TILEMAP 
global.atomTilemap = ds_map_create()

ds_map_add(global.atomTilemap, "H",   1);
ds_map_add(global.atomTilemap, "He",  2);
ds_map_add(global.atomTilemap, "Li",  3);
ds_map_add(global.atomTilemap, "Be",  4);
ds_map_add(global.atomTilemap, "B",   5);
ds_map_add(global.atomTilemap, "C",   6);
ds_map_add(global.atomTilemap, "N",   7);
ds_map_add(global.atomTilemap, "O",   8);
ds_map_add(global.atomTilemap, "F",   9);
ds_map_add(global.atomTilemap, "Ne", 10);
ds_map_add(global.atomTilemap, "Na", 11);
ds_map_add(global.atomTilemap, "Mg", 12);
ds_map_add(global.atomTilemap, "Al", 13);
ds_map_add(global.atomTilemap, "Si", 14);
ds_map_add(global.atomTilemap, "P",  15);
ds_map_add(global.atomTilemap, "S",  16);
ds_map_add(global.atomTilemap, "Cl", 17);
ds_map_add(global.atomTilemap, "Ar", 18);
ds_map_add(global.atomTilemap, "K",  19);
ds_map_add(global.atomTilemap, "Ca", 20);
ds_map_add(global.atomTilemap, "Sc", 21);
ds_map_add(global.atomTilemap, "Ti", 22);
ds_map_add(global.atomTilemap, "V",  23);
ds_map_add(global.atomTilemap, "Cr", 24);
ds_map_add(global.atomTilemap, "Mn", 25);
ds_map_add(global.atomTilemap, "Fe", 26);
ds_map_add(global.atomTilemap, "Co", 27);
ds_map_add(global.atomTilemap, "Ni", 28);
ds_map_add(global.atomTilemap, "Cu", 29);
ds_map_add(global.atomTilemap, "Zn", 30);
ds_map_add(global.atomTilemap, "Ga", 31);
ds_map_add(global.atomTilemap, "Ge", 32);
ds_map_add(global.atomTilemap, "As", 33);
ds_map_add(global.atomTilemap, "Se", 34);
ds_map_add(global.atomTilemap, "Br", 35);
ds_map_add(global.atomTilemap, "Kr", 36);

#endregion
#region MOLECULAR TILEMAP
global.moleTilemap = ds_map_create()

ds_map_add(global.moleTilemap, "H2",           1);
ds_map_add(global.moleTilemap, "H2O",          2);
ds_map_add(global.moleTilemap, "H2O2",         3);
ds_map_add(global.moleTilemap, "O2",           4);
ds_map_add(global.moleTilemap, "O3",           5);
ds_map_add(global.moleTilemap, "C",			   7);
ds_map_add(global.moleTilemap, "CO",		   6);
ds_map_add(global.moleTilemap, "CO2",		   8);
ds_map_add(global.moleTilemap, "Cl2",		   9);
ds_map_add(global.moleTilemap, "HCl",		  10);
ds_map_add(global.moleTilemap, "Si",		  11);
ds_map_add(global.moleTilemap, "SiO2",		  12);
ds_map_add(global.moleTilemap, "Fe",          13);
ds_map_add(global.moleTilemap, "Fe2O3",       14);
ds_map_add(global.moleTilemap, "Fe3O4",       15);


ds_map_add(global.moleTilemap, "NaCl",		  20);
ds_map_add(global.moleTilemap, "NaClO",	      21);
ds_map_add(global.moleTilemap, "NaClO2",	  22);
ds_map_add(global.moleTilemap, "NaClO3",	  23);
ds_map_add(global.moleTilemap, "NaHCO3",	  24);
ds_map_add(global.moleTilemap, "NaOH",	      25);
ds_map_add(global.moleTilemap, "ClO2",        26);
ds_map_add(global.moleTilemap, "HClO",	      27);
ds_map_add(global.moleTilemap, "Na2CO3",	  28);





ds_map_add(global.moleTilemap, "Cu2(OH)2CO3", BLUE);
ds_map_add(global.moleTilemap, "K2MnO4",      BLUE);
ds_map_add(global.moleTilemap, "KMnO4",       PINK);
ds_map_add(global.moleTilemap, "CaO",		  BLACK);
ds_map_add(global.moleTilemap, "CaCO3",		  GREEN);

#endregion
#region MOLECULAR COLOR MAP
global.moleColorMap = ds_map_create()

ds_map_add(global.moleColorMap, "H2",         #9FD9DB);
ds_map_add(global.moleColorMap, "H2O",        #4A7FAC);
ds_map_add(global.moleColorMap, "H2O2",       #77C8CA);
ds_map_add(global.moleColorMap, "O2",         #B1E2B0);
ds_map_add(global.moleColorMap, "O3",         #D66161);
ds_map_add(global.moleColorMap, "CO",		  #585958);
ds_map_add(global.moleColorMap, "C",		  #D69C61);
ds_map_add(global.moleColorMap, "CO2",		  #AFBDAF);
ds_map_add(global.moleColorMap, "Cl2",		  #B6CF98);
ds_map_add(global.moleColorMap, "HCl",		  #D69C61);
ds_map_add(global.moleColorMap, "Si",		  #E27B9A);
ds_map_add(global.moleColorMap, "SiO2",		  #85C684);
ds_map_add(global.moleColorMap, "Fe",         #959595);
ds_map_add(global.moleColorMap, "Fe2O3",      #D66161);
ds_map_add(global.moleColorMap, "Fe3O4",      #585958);


ds_map_add(global.moleColorMap, "NaCl",		  #77C8CA);
ds_map_add(global.moleColorMap, "NaClO",	  #D66161);
ds_map_add(global.moleColorMap, "NaClO2",	  #D69C61);
ds_map_add(global.moleColorMap, "NaClO3",	  #6D44C9);
ds_map_add(global.moleColorMap, "NaOH",		  #85C684);
ds_map_add(global.moleColorMap, "ClO2",		  #836949);
ds_map_add(global.moleColorMap, "HClO",		  #7C84E6);
ds_map_add(global.moleColorMap, "NaHCO3",	  #B4AE5F);
ds_map_add(global.moleColorMap, "Na2CO3",	  #B4AD91);



//ds_map_add(global.moleColorMap, "NaClO2",       $FFCC11);
//ds_map_add(global.moleColorMap, "NaClO",        #11CCFF);
ds_map_add(global.moleColorMap, "CaO",		  c_black);
ds_map_add(global.moleColorMap, "CaCO3",	  c_green);

#endregion



global.chapterUnlockMap = ds_map_create()
ds_map_add(global.chapterUnlockMap, "H",  ["O"]);
ds_map_add(global.chapterUnlockMap, "O",  ["C","Fe"]);
ds_map_add(global.chapterUnlockMap, "C",  ["Cl"]);
ds_map_add(global.chapterUnlockMap, "Cl", ["Na"]);


global.chapterColorMap = ds_map_create()
ds_map_add(global.chapterColorMap,"H",  global.moleColorMap[? "H2"]);
ds_map_add(global.chapterColorMap,"O",  global.moleColorMap[? "O2"]);
ds_map_add(global.chapterColorMap,"C",  global.moleColorMap[? "C"]);
ds_map_add(global.chapterColorMap,"Cl", global.moleColorMap[? "Cl2"]);
ds_map_add(global.chapterColorMap,"Na", global.moleColorMap[? "NaCl"]);
ds_map_add(global.chapterColorMap,"Ca", global.moleColorMap[? "CaO"]);
ds_map_add(global.chapterColorMap,"Fe", global.moleColorMap[? "Fe"]);