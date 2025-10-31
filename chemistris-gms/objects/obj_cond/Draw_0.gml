
var xCell = tilemap_get_cell_x_at_pixel(Get_tilemap_element_from("lay_tileset_mole"), x, y)
var	yCell = tilemap_get_cell_y_at_pixel(Get_tilemap_element_from("lay_tileset_mole"), x, y)

var xDraw = REACTOR_LEFT + xCell * CELL_SIDE_PX + CELL_SIDE_PX / 2
var yDraw = REACTOR_UP +   yCell * CELL_SIDE_PX + CELL_SIDE_PX / 2

draw_sprite(self.sprite_index, -1, xDraw, yDraw)