extends Node2D

const tile_size := 128
const source_to_tile_type_map = {
	1: "WATER",
	2: "FOOD",
	3: "FRAMES",
	4: "BUSINESS",
	5: "PEOPLE",
	6: "ELECRTRICITY",
}
const tile_type_to_source_map = {
	"WATER": 1,
	"FOOD": 2,
	"FRAMES": 3,
	"BUSINESS": 4,
	"PEOPLE": 5,
	"ELECRTRICITY": 6,
}

var block := [Vector2(0,0)]
var i_block := [Vector2(0,0), Vector2(0,-1)]
var c_block := [Vector2(0,0), Vector2(1,0), Vector2(0,1)]

var current_tile = c_block
var current_tile_type = tile_type_to_source_map.WATER

@onready var shadow_tile_map := $ShadowTileMap as TileMapLayer
@onready var next_tile_map := $NextTileMap as TileMapLayer
@onready var placed_tiles_map := %PlacedTilesMap as TileMapLayer


func _physics_process(delta: float) -> void:
	if current_tile != null:
		next_tile_map.clear()
		shadow_tile_map.clear()
		for cell in current_tile:
			next_tile_map.set_cell(cell, current_tile_type, Vector2.ZERO)
		var tile := shadow_tile_map.local_to_map(get_local_mouse_position()) as Vector2
		for cell in current_tile:
			shadow_tile_map.set_cell(tile + cell, 0, Vector2.ONE)
	next_tile_map.position = get_local_mouse_position() - (Vector2.ONE * tile_size / 2.0)


func _unhandled_input(event: InputEvent) -> void:
	if current_tile != null && event.is_action_pressed("ui_accept"):
		place_tile()
	if event.is_action_pressed("ui_cancel"):
		get_random_tile()
	if current_tile != null && event.is_action_pressed("clockwise"):
		rotate_clockwise()
	if current_tile != null && event.is_action_pressed("counter_clockwise"):
		rotate_counter_clockwise()


func place_tile() -> void:
	var tile := placed_tiles_map.local_to_map(get_local_mouse_position()) as Vector2
	if !is_tile_connected(tile) || is_tile_overlapping(tile):
		animate_cant_place()
		return
	AudioManager.play_sfx(AudioManager.sfx_achievement_01)
	next_tile_map.clear()
	for cell in current_tile:
		placed_tiles_map.set_cell(tile + cell, current_tile_type, Vector2.ZERO)
	get_random_tile()


func is_tile_connected(tile: Vector2) -> bool:
	for cell in current_tile:
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
	for cell in current_tile:
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell)):
			print(placed_tiles_map.get_cell_source_id(tile + cell))
			return true
	return false


func animate_cant_place() -> void:
	AudioManager.play_sfx(AudioManager.sfx_accent_boing)
	var tween = get_tree().create_tween()
	tween.tween_property(next_tile_map, "scale", Vector2.ONE*1.2, 0.1)
	tween.tween_property(next_tile_map, "scale", Vector2.ONE*1, 0.1)


func get_random_tile() -> void:
	current_tile = [block, i_block, c_block].pick_random()
	current_tile_type = [1,2,3,4,5,6].pick_random()


func rotate_clockwise() -> void:
	for i in range(current_tile.size()):
		current_tile[i] = current_tile[i].rotated(deg_to_rad(90))
		current_tile[i].x = roundi(current_tile[i].x)
		current_tile[i].y = roundi(current_tile[i].y)


func rotate_counter_clockwise() -> void:
	for i in range(current_tile.size()):
		current_tile[i] = current_tile[i].rotated(deg_to_rad(-90))
		current_tile[i].x = roundi(current_tile[i].x)
		current_tile[i].y = roundi(current_tile[i].y)
