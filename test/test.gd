extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music(AudioManager.music_orgate_track03)
	AudioManager.play_sfx(AudioManager.sfx_accent_boing)
	AudioManager.play_ui(AudioManager.sfx_achievement_01)
	AudioManager.play_from_file("res://audio/sfx/khorn_studio/Puzzle_Game_Merge_Echo_03.wav", AudioManager.AUDIO_BUSES.Master)
