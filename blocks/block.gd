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


func get_food(tile_map: TileMapLayer, count := 0, visited := []) -> int:
	# Prevent stack overflow
	if count > 1000:
		return 0
	# Prevent not food
	if type != Type.FOOD:
		return 0
	if !is_connected_to_residential(tile_map):
		return 0
	# Check condition
	for cell in coords:
		# If any side tile is empty
		if tile_map.get_cell_source_id(cell + Vector2(1, 0)) == -1:
			return value
		if tile_map.get_cell_source_id(cell + Vector2(-1, 0)) == -1:
			return value
	# Prevent loop from revisting self
	if visited.has(coords):
		return 0
	visited.push_back(coords)
	# Check all connected blocks for condition
	for cell in coords:
		for target in [Vector2(0, -1), Vector2(0, 1), Vector2(1, 0), Vector2(-1, -0)]:
			if tile_map.get_cell_source_id(cell + target) == type_to_source_map[type]:
				for block in BlockManager.placed_blocks:
					for coord in block.coords:
						if coord == cell + target and block.coords != coords:
							if block.get_food(tile_map, count+1, visited) > 0:
								return value
	return 0


func get_water(tile_map: TileMapLayer, count := 0, visited := []) -> int:
	# Prevent stack overflow
	if count > 1000:
		return 0
	# Prevent not water
	if type != Type.WATER:
		return 0
	if !is_connected_to_residential(tile_map):
		return 0
	# Check condition
	if is_connected_to_residential(tile_map):
		for cell in coords:
			# If any above tile is empty
			if tile_map.get_cell_source_id(cell + Vector2(0, -1)) == -1:
				return value
	# Prevent loop from revisting self
	if visited.has(coords):
		return 0
	visited.push_back(coords)
	# Check all connected blocks for condition
	for cell in coords:
		for target in [Vector2(0, -1), Vector2(0, 1), Vector2(1, 0), Vector2(-1, -0)]:
			if tile_map.get_cell_source_id(cell + target) == type_to_source_map[type]:
				for block in BlockManager.placed_blocks:
					for coord in block.coords:
						if coord == cell + target and block.coords != coords:
							if block.get_water(tile_map, count+1, visited) > 0:
								return value
	return 0


func get_electricity(tile_map: TileMapLayer, count := 0, visited := []) -> int:
	# Prevent stack overflow
	if count > 1000:
		return 0
	# Prevent not electricity
	if type != Type.ELECTRICITY:
		return 0
	if !is_connected_to_residential(tile_map):
		return 0
	# Check condition
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
	# Prevent loop from revisting self
	if visited.has(coords):
		return 0
	visited.push_back(coords)
	# Check all connected blocks for condition
	for cell in coords:
		for target in [Vector2(0, -1), Vector2(0, 1), Vector2(1, 0), Vector2(-1, -0)]:
			if tile_map.get_cell_source_id(cell+target) == type_to_source_map[Type.ELECTRICITY]:
				for block in BlockManager.placed_blocks:
					for coord in block.coords:
						if coord == cell+target and block.coords != coords:
							if block.get_electricity(tile_map, count+1, visited) > 0:
								return value
	return 0


func get_people() -> int:
	if type != Type.RESIDENTIAL:
		return 0
	return value


func get_coins(tile_map: TileMapLayer) -> int:
	# Prevent not business
	if type != Type.BUSINESS:
		return 0
	# Check condition
	if is_connected_to_residential(tile_map):
		return value
	return 0


func is_connected_to_residential(tile_map: TileMapLayer, visited := []) -> bool:
	for cell in coords:
		if tile_map.get_cell_source_id(cell + Vector2(0, -1)) == type_to_source_map[Type.RESIDENTIAL]:
			return true
		if tile_map.get_cell_source_id(cell + Vector2(0, 1)) == type_to_source_map[Type.RESIDENTIAL]:
			return true
		if tile_map.get_cell_source_id(cell + Vector2(1, 0)) == type_to_source_map[Type.RESIDENTIAL]:
			return true
		if tile_map.get_cell_source_id(cell + Vector2(-1, 0)) == type_to_source_map[Type.RESIDENTIAL]:
			return true
	if visited.has(coords):
		return false
	visited.push_back(coords)
	# Check all connected blocks for residential
	for cell in coords:
		for target in [Vector2(0, -1), Vector2(0, 1), Vector2(1, 0), Vector2(-1, -0)]:
			if tile_map.get_cell_source_id(cell + target) == type_to_source_map[type]:
				for block in BlockManager.placed_blocks:
					for coord in block.coords:
						if coord == cell + target and block.coords != coords:
							if block.is_connected_to_residential(tile_map, visited):
								return true
	return false
