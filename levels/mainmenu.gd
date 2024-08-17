extends Control

var howto_scene = preload("res://levels/howtoplay.tscn").instantiate()

func _ready() -> void:
	AudioManager.play_music(AudioManager.music_menu01_track, false, 0.0,0.0)


func _on_start_game_pressed() -> void:
	print("Im starting")


func _on_endless_mode_pressed() -> void:
	pass # Replace with function body.


func _on_how_to_play_pressed() -> void:
	get_tree().root.add_child(howto_scene)


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_start_game_mouse_entered() -> void:
	print("Im starting")
