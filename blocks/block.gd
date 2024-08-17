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


func init(new_coords: Array, new_type: Type) -> void:
	coords = new_coords
	type = new_type


func get_top_cells(tile_map: TileMapLayer) -> Array:
	var top_cells := []
	for cell in coords:
		top_cells.push_back(tile_map.get_cell_source_id(cell + Vector2(0, -1)))
	return top_cells


func get_source():
	return type_to_source_map[type]
