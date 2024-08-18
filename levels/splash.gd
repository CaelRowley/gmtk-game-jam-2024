extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("splash_screen_animation")

func play_next_scene() -> void:
	SceneManager.goto_scene("res://levels/game.tscn")
