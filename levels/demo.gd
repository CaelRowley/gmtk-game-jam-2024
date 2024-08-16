extends Node2D

@onready var back_map := $BackMapLayer as TileMapLayer
@onready var tile_map := $TileMapLayer as TileMapLayer
@onready var placement_map := $PlacementLayer as TileMapLayer

var is_placing := true


func _physics_process(delta: float) -> void:
	if is_placing:
		placement_map.clear()
		placement_map.set_cell(Vector2.ZERO, 0, Vector2.ONE*3)
		placement_map.set_cell(Vector2.ZERO + Vector2(1, 0), 0, Vector2.ONE*3)
		placement_map.set_cell(Vector2.ZERO + Vector2(1, 1), 0, Vector2.ONE*3)
		
		back_map.clear()
		var tile : Vector2 = back_map.local_to_map(get_global_mouse_position())
		back_map.set_cell(tile, 0, Vector2.ONE)
		back_map.set_cell(tile + Vector2(1, 0), 0, Vector2.ONE)
		back_map.set_cell(tile + Vector2(1, 1), 0, Vector2.ONE)
	placement_map.position = get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if is_placing && event.is_action_pressed("ui_accept"):
		var tile : Vector2 = tile_map.local_to_map(get_global_mouse_position())
		if is_instance_valid(tile_map.get_cell_tile_data(tile)):
			animate_cant_place()
			return
		if is_instance_valid(tile_map.get_cell_tile_data(tile + Vector2(1, 0))):
			animate_cant_place()
			return
		if is_instance_valid(tile_map.get_cell_tile_data(tile + Vector2(1, 1))):
			animate_cant_place()
			return
		animate_place()
		placement_map.clear()
		is_placing = false
		tile_map.set_cell(tile, 0, Vector2.ONE*3)
		tile_map.set_cell(tile + Vector2(1, 0), 0,Vector2.ONE*3)
		tile_map.set_cell(tile + Vector2(1, 1), 0,Vector2.ONE*3)
	if event.is_action_pressed("ui_cancel"):
		is_placing = true


func animate_place() -> void:
	AudioManager.play_sfx(AudioManager.sfx_achievement_01)


func animate_cant_place() -> void:
	AudioManager.play_sfx(AudioManager.sfx_accent_boing)
	var tween = get_tree().create_tween()
	tween.tween_property(placement_map, "scale", Vector2.ONE*1.2, 0.1)
	tween.tween_property(placement_map, "scale", Vector2.ONE*1, 0.1)
