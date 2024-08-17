class_name Block

extends Node

enum Type {
	FOOD,
	WATER,
	ELECTRICITY,
	RESIDENTIAL,
	BUSINESS,
	FRAME,
}

const type_to_source_map = {
	Block.Type.WATER: 1,
	Block.Type.FOOD: 2,
	Block.Type.FRAME: 3,
	Block.Type.BUSINESS: 4,
	Block.Type.RESIDENTIAL: 5,
	Block.Type.ELECTRICITY: 6,
}

var coords: Array
var type := Type.FRAME
var value: int


func init(new_coords: Array, new_type: Type, new_value: int) -> void:
	coords = new_coords
	type = new_type
	value = new_value


func get_top_cells(tile_map: TileMapLayer) -> Array:
	var top_cells := []
	for cell in coords:
		top_cells.push_back(tile_map.get_cell_source_id(cell + Vector2(0, -1)))
	return top_cells


func get_bot_cells(tile_map: TileMapLayer) -> Array:
	var top_cells := []
	for cell in coords:
		top_cells.push_back(tile_map.get_cell_source_id(cell + Vector2(0, 1)))
	return top_cells


func get_left_cells(tile_map: TileMapLayer) -> Array:
	var top_cells := []
	for cell in coords:
		top_cells.push_back(tile_map.get_cell_source_id(cell + Vector2(-1, 0)))
	return top_cells


func get_right_cells(tile_map: TileMapLayer) -> Array:
	var top_cells := []
	for cell in coords:
		top_cells.push_back(tile_map.get_cell_source_id(cell + Vector2(1, 0)))
	return top_cells


func get_source():
	return type_to_source_map[type]


func get_food(tile_map: TileMapLayer) -> int:
	if type != Type.FOOD:
		return 0
	for cell in coords:
		# If any side tile is empty
		if tile_map.get_cell_source_id(cell + Vector2(1, 0)) == -1:
			return value
		if tile_map.get_cell_source_id(cell + Vector2(-1, 0)) == -1:
			return value
	return 0


func get_water(tile_map: TileMapLayer) -> int:
	if type != Type.WATER:
		return 0
	for cell in coords:
		# If any above tile is empty
		if tile_map.get_cell_source_id(cell + Vector2(0, -1)) == -1:
			return value
	return 0


func get_electricity(tile_map: TileMapLayer) -> int:
	if type != Type.ELECTRICITY:
		return 0
	for cell in coords:
		# If any connecting tile is empty
		if tile_map.get_cell_source_id(cell + Vector2(0, -1)) == -1:
			return value
		if tile_map.get_cell_source_id(cell + Vector2(0, 1)) == -1:
			return value
		if tile_map.get_cell_source_id(cell + Vector2(1, 0)) == -1:
			return value
		if tile_map.get_cell_source_id(cell + Vector2(-1, 0)) == -1:
			return value
	return 0


func get_people() -> int:
	if type != Type.RESIDENTIAL:
		return 0
	return value


func get_coins(tile_map: TileMapLayer) -> int:
	if type != Type.BUSINESS:
		return 0
	for cell in coords:
		# If any connecting tile is empty
		if tile_map.get_cell_source_id(cell + Vector2(0, -1)) == type_to_source_map[Type.RESIDENTIAL]:
			return value
		if tile_map.get_cell_source_id(cell + Vector2(0, 1)) == type_to_source_map[Type.RESIDENTIAL]:
			return value
		if tile_map.get_cell_source_id(cell + Vector2(1, 0)) == type_to_source_map[Type.RESIDENTIAL]:
			return value
		if tile_map.get_cell_source_id(cell + Vector2(-1, 0)) == type_to_source_map[Type.RESIDENTIAL]:
			return value
	return 0
