extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		SceneManager.goto_scene("res://test/test.tscn")
	if event.is_action_pressed("ui_cancel"):
		SceneManager.goto_previous_scene()
