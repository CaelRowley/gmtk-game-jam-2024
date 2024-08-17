extends Node2D

const tile_size := 128
const source_to_type_map = {
	1: Block.Type.WATER,
	2: Block.Type.FOOD,
	3: Block.Type.FRAME,
	4: Block.Type.BUSINESS,
	5: Block.Type.RESIDENTIAL,
	6: Block.Type.ELECTRICITY,
}
const type_to_source_map = {
	Block.Type.WATER: 1,
	Block.Type.FOOD: 2,
	Block.Type.FRAME: 3,
	Block.Type.BUSINESS: 4,
	Block.Type.RESIDENTIAL: 5,
	Block.Type.ELECTRICITY: 6,
}

@onready var shadow_tile_map := $ShadowTileMap as TileMapLayer
@onready var next_tile_map := $NextTileMap as TileMapLayer
@onready var placed_tiles_map := %PlacedTilesMap as TileMapLayer


func _process(_delta: float) -> void:
	if BlockManager.current_block != null:
		next_tile_map.clear()
		shadow_tile_map.clear()
		var tile := shadow_tile_map.local_to_map(get_local_mouse_position()) as Vector2
		for cell in BlockManager.current_block.coords:
			next_tile_map.set_cell(cell, BlockManager.current_block.get_source(), Vector2.ZERO)
			shadow_tile_map.set_cell(tile + cell, 0, Vector2.ONE)
	next_tile_map.position = get_local_mouse_position() - (Vector2.ONE * tile_size / 2.0)


func _input(event: InputEvent) -> void:
	if  BlockManager.current_block != null && event.is_action_pressed("ui_accept"):
		place_tile()
	if BlockManager.current_block != null && event.is_action_pressed("clockwise"):
		rotate_clockwise()
	if BlockManager.current_block != null && event.is_action_pressed("counter_clockwise"):
		rotate_counter_clockwise()


func place_tile() -> void:
	var tile := placed_tiles_map.local_to_map(get_local_mouse_position()) as Vector2
	if !is_tile_connected(tile) || is_tile_overlapping(tile):
		animate_cant_place()
		return
	AudioManager.play_sfx(AudioManager.sfx_achievement_01)
	next_tile_map.clear()
	var coords = []
	for cell in BlockManager.current_block.coords:
		coords.push_back(tile + cell)
	var new_block := Block.new()
	new_block.init(coords, BlockManager.current_block.type)
	BlockManager.add_placed_block(new_block)
	update_cells()
	get_random_block()


func update_cells() -> void:
	for block in BlockManager.placed_blocks:
		for coord in block.coords:
			placed_tiles_map.set_cell(coord, block.get_source(), Vector2.ZERO)


func is_tile_connected(tile: Vector2) -> bool:
	for cell in  BlockManager.current_block.coords:
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell + Vector2(0, -1))):
			return true
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell + Vector2(0, 1))):
			return true
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell + Vector2(1, 0))):
			return true
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell + Vector2(-1, 0))):
			return true
	return false


func is_tile_overlapping(tile: Vector2) -> bool:
	for cell in BlockManager.current_block.coords:
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell)):
			return true
	return false


func animate_cant_place() -> void:
	AudioManager.play_sfx(AudioManager.sfx_accent_boing)
	var tween = get_tree().create_tween()
	tween.tween_property(next_tile_map, "scale", Vector2.ONE*1.2, 0.1)
	tween.tween_property(next_tile_map, "scale", Vector2.ONE*1, 0.1)


func get_random_block() -> void:
	var new_block := Block.new()
	var ran_coords := [BlockManager.BLOCKS.Block, BlockManager.BLOCKS.IBlock, BlockManager.BLOCKS.CBlock].pick_random() as Array
	var ran_type := [0, 1 ,2,3,4,5].pick_random() as int
	new_block.init(ran_coords, ran_type)
	BlockManager.current_block = new_block

#
func rotate_clockwise() -> void:
	for i in range(BlockManager.current_block.coords.size()):
		var new_coords := BlockManager.current_block.coords.duplicate()
		var new_rotation := new_coords[i].rotated(deg_to_rad(90)) as Vector2
		new_coords[i].x = roundi(new_rotation.x)
		new_coords[i].y = roundi(new_rotation.y)
		BlockManager.current_block.coords = new_coords


func rotate_counter_clockwise() -> void:
	for i in range(BlockManager.current_block.coords.size()):
		var new_coords := BlockManager.current_block.coords.duplicate()
		var new_rotation := new_coords[i].rotated(deg_to_rad(-90)) as Vector2
		new_coords[i].x = roundi(new_rotation.x)
		new_coords[i].y = roundi(new_rotation.y)
		BlockManager.current_block.coords = new_coords
