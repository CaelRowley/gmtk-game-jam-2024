extends Node2D


func _ready() -> void:
	AudioManager.play_sfx(AudioManager.sfx_achievement_01)
	$CPUParticles2D.emitting = true
