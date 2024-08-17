extends Node2D

@onready var back_map := $BackMapLayer as TileMapLayer
@onready var tile_map := $TileMapLayer as TileMapLayer
@onready var placement_map := $PlacementLayer as TileMapLayer

var tile_size := 128

var block := [Vector2(0,0)]
var i_block := [Vector2(0,0), Vector2(0,-1)]
var c_block := [Vector2(0,0), Vector2(1,0), Vector2(0,1)]

var current_tile = c_block

func _physics_process(delta: float) -> void:
	if current_tile != null:
		placement_map.clear()
		back_map.clear()
		for cell in current_tile:
			placement_map.set_cell(cell, 0, Vector2.ONE*3)
		var tile := back_map.local_to_map(get_local_mouse_position()) as Vector2
		for cell in current_tile:
			back_map.set_cell(tile + cell, 0, Vector2.ONE)
	placement_map.position = get_local_mouse_position() - (Vector2.ONE * tile_size / 2.0)


func _unhandled_input(event: InputEvent) -> void:
	if current_tile != null && event.is_action_pressed("ui_accept"):
		place_tile()
	if event.is_action_pressed("ui_cancel"):
		get_random_tile()
	if current_tile != null && event.is_action_pressed("clockwise"):
		rotate_clockwise()
	if current_tile != null && event.is_action_pressed("counter_clockwise"):
		rotate_counter_clockwise()


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


func place_tile() -> void:
	var tile := tile_map.local_to_map(get_local_mouse_position()) as Vector2
	if !is_tile_connected(tile) || is_tile_overlapping(tile):
		animate_cant_place()
		return
	AudioManager.play_sfx(AudioManager.sfx_achievement_01)
	placement_map.clear()
	for cell in current_tile:
		tile_map.set_cell(tile + cell, 0, Vector2.ONE*3)
	current_tile = null


func is_tile_connected(tile: Vector2) -> bool:
	for cell in current_tile:
		if is_instance_valid(tile_map.get_cell_tile_data(tile + cell + Vector2(0, -1))):
			return true
		if is_instance_valid(tile_map.get_cell_tile_data(tile + cell + Vector2(0, 1))):
			return true
		if is_instance_valid(tile_map.get_cell_tile_data(tile + cell + Vector2(1, 0))):
			return true
		if is_instance_valid(tile_map.get_cell_tile_data(tile + cell + Vector2(-1, 0))):
			return true
	return false


func is_tile_overlapping(tile: Vector2) -> bool:
	for cell in current_tile:
		if is_instance_valid(tile_map.get_cell_tile_data(tile + cell)):
			return true
	return false


func animate_cant_place() -> void:
	AudioManager.play_sfx(AudioManager.sfx_accent_boing)
	var tween = get_tree().create_tween()
	tween.tween_property(placement_map, "scale", Vector2.ONE*1.2, 0.1)
	tween.tween_property(placement_map, "scale", Vector2.ONE*1, 0.1)


func get_random_tile() -> void:
	current_tile = [block, i_block, c_block].pick_random()
