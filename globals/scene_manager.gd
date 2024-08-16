extends Control

var previous_scene_path: String
var current_scene: Node = null

@onready var animation_player := %AnimationPlayer as AnimationPlayer


func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	previous_scene_path = current_scene.scene_file_path
	fade_in(1.0)


func goto_previous_scene(speed_scale_out: float = 2.0, speed_scale_in: float = 2.0, delay: float = 0.0) -> void:
	call_deferred("_deferred_goto_scene", previous_scene_path, speed_scale_out, speed_scale_in, delay)


func goto_scene(path: String, speed_scale_out: float = 2.0, speed_scale_in: float = 2.0, delay: float = 0.0) -> void:
	call_deferred("_deferred_goto_scene", path, speed_scale_out, speed_scale_in, delay)


func _deferred_goto_scene(path: String, speed_scale_out: float = 2.0, speed_scale_in: float = 2.0, delay: float = 0.0) -> void:
	previous_scene_path = current_scene.scene_file_path
	if (speed_scale_out > 0):
		await fade_out(speed_scale_out).animation_finished
	current_scene.queue_free()
	var next_scene := ResourceLoader.load(path) as PackedScene
	current_scene = next_scene.instantiate()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	await get_tree().create_timer(delay).timeout
	if (speed_scale_out > 0):
		fade_in(speed_scale_in)


func fade_in(speed_scale: float = 2.0) -> AnimationPlayer:
	animation_player.set_speed_scale(speed_scale)
	animation_player.play("fade_in")
	return animation_player


func fade_out(speed_scale: float = 2.0) -> AnimationPlayer:
	animation_player.set_speed_scale(speed_scale)
	animation_player.play("fade_out")
	return animation_player
