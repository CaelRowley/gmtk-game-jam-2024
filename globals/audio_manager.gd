extends Node

const AUDIO_CUTOFF_VOLUME := -40
const AUDIO_BUSES := {
	"Master": "Master", 
	"Music": "Music", 
	"SFX": "SFX", 
	"UI": "UI"
}

# Music
# Orgate
const music_orgate_track01 := preload("res://audio/music/orgate/track01.wav")
const music_orgate_track03 := preload("res://audio/music/orgate/track03.wav")

# AutoPlay
const music_autoplay_background := preload("res://audio/music/autoplay/background_song.wav")
const music_autoplay_revival := preload("res://audio/music/autoplay/revival.mp3")
const music_autoplay_satellite_debris := preload("res://audio/music/autoplay/satellite_debris.mp3")

# SFX
# Khorn Studio - Puzzle Games Vol 1
const sfx_accent_boing := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Accent_Boing_02.wav")
const sfx_achievement_01 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Achievement_01.wav")
const sfx_achievement_02 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Achievement_02.wav")
const sfx_magic_item_unlock_01 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Magic_Item_Unlock_1.ogg")
const sfx_magic_item_unlock_02 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Magic_Item_Unlock_2.ogg")
const sfx_magic_item_unlock_05 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Magic_Item_Unlock_5.ogg")
const sfx_merge_crackle_03 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Merge_Crackle_03.wav")
const sfx_merge_echo_01 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Merge_Echo_01.wav")
const sfx_merge_echo_02 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Merge_Echo_02.wav")
const sfx_merge_echo_03 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Merge_Echo_03.wav")
const sfx_merge_echo_04 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Merge_Echo_04.wav")
const sfx_merge_echo_05 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Merge_Echo_05.wav")
const sfx_whoosh_heavy_03 := preload("res://audio/sfx/khorn_studio/Puzzle_Game_Whoosh_Heavy_03.wav")

var music_one_shot := false

@onready var music_player_1 := %MusicPlayer1 as AudioStreamPlayer
@onready var music_player_2 := %MusicPlayer2 as AudioStreamPlayer

@onready var current_music_player := music_player_1
@onready var prev_music_player := music_player_2


func play_music(audio: AudioStream, one_shot := false, time_out := 0.1, time_in := 0.2) -> void:
	music_one_shot = one_shot

	if current_music_player == music_player_1:
		current_music_player = music_player_2
		prev_music_player = music_player_1
	else:
		current_music_player = music_player_1
		prev_music_player = music_player_2

	current_music_player.stream = audio
	current_music_player._set_playing(true)

	var turn_off_tween := create_tween()
	turn_off_tween.set_trans(Tween.TRANS_QUART)
	turn_off_tween.set_ease(Tween.EASE_OUT)
	turn_off_tween.tween_property(prev_music_player, "volume_db", AUDIO_CUTOFF_VOLUME, time_out)

	var turn_on_tween := create_tween()
	turn_on_tween.set_trans(Tween.TRANS_LINEAR)
	turn_on_tween.set_ease(Tween.EASE_OUT)
	turn_on_tween.tween_property(
		current_music_player,
		"volume_db",
		0.0,
		time_in
	)

	await turn_off_tween.finished
	prev_music_player.stop()


func play_sfx(audio: AudioStream) -> void:
	var audio_player := AudioStreamPlayer.new()
	audio_player.set_bus(AUDIO_BUSES.SFX)
	add_child(audio_player)
	audio_player.stream = audio
	audio_player.play()

	await audio_player.finished
	remove_child(audio_player)
	audio_player.queue_free()


func play_ui(audio: AudioStream) -> void:
	var audio_player := AudioStreamPlayer.new()
	audio_player.set_bus(AUDIO_BUSES.UI)
	add_child(audio_player)
	audio_player.stream = audio
	audio_player.play()

	await audio_player.finished
	remove_child(audio_player)
	audio_player.queue_free()


func play_from_file(path: String, bus: String) -> void:
	var effect := load(path) as AudioStream
	var audio_player := AudioStreamPlayer.new()
	audio_player.set_bus(bus)
	add_child(audio_player)
	audio_player.stream = effect
	audio_player.play()

	await audio_player.finished
	remove_child(audio_player)
	audio_player.queue_free()


func set_volume(audio_bus: String, volume: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus), linear_to_db(volume))


func get_volume(audio_bus: String) -> float:
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(audio_bus))


func _on_music_player_1_finished() -> void:
	if current_music_player == music_player_1 and !music_one_shot:
		play_music(current_music_player.stream)


func _on_music_player_2_finished() -> void:
	if current_music_player == music_player_2 and !music_one_shot:
		play_music(current_music_player.stream)


func is_music_playing() -> bool:
	return music_player_1.playing || music_player_2.playing
