/// @description EMPTY DATA STRUCTURE

show_debug_message("HERE!")

for (var _n=0; _n<array_length(arrayDisplayedCapsuledCell); _n++) {
    arrayDisplayedCapsuledCell[_n].dcAtomS.Erase()
    arrayDisplayedCapsuledCell[_n].dcAtomS.cellS.atomS = noone
    delete arrayDisplayedCapsuledCell[_n].dcAtomS
}