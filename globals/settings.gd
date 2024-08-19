extends Node


const CONFIG_FILE := "user://config.cfg"

const SECTIONS := {
	"Audio": "Audio",
	"Display": "Display",
	"Gameplay": "Gameplay",
}

const KEYS := {
	"Master": "Master",
	"Music": "Music",
	"SFX": "SFX",
	"Fullscreen": "Fullscreen",
	"SkipTutorial": "SkipTutorial",
}

var default_config: Dictionary = {
	SECTIONS.Audio:  {
		KEYS.Master: 1.0,
		KEYS.Music: 0.5,
		KEYS.SFX: 0.5,
	},
	SECTIONS.Display: {
		KEYS.Fullscreen: true,
	},
	SECTIONS.Gameplay: {
		KEYS.SkipTutorial: false,
	},
}

@onready var config := ConfigFile.new()


func _init():
	#To see directiory files are saves
	print(OS.get_user_data_dir())


func _ready():
	load_config()


func save_config() -> int:
	return config.save(CONFIG_FILE)


func load_config():
	var err := config.load(CONFIG_FILE)
	if err: 
		revert_config()
		return
	if not _check_config(): 
		revert_config()
		return

	AudioManager.set_volume(AudioManager.AUDIO_BUSES.Master, get_value(SECTIONS.Audio, KEYS.Master))
	AudioManager.set_volume(AudioManager.AUDIO_BUSES.Music, get_value(SECTIONS.Audio, KEYS.Music))
	AudioManager.set_volume(AudioManager.AUDIO_BUSES.SFX, get_value(SECTIONS.Audio, KEYS.SFX))
	
	if (get_window().mode != get_window().MODE_FULLSCREEN and get_value(SECTIONS.Display, KEYS.Fullscreen)) or (get_window().mode == get_window().MODE_FULLSCREEN and !get_value(SECTIONS.Display, KEYS.Fullscreen)):
		get_window().mode = get_window().MODE_FULLSCREEN if get_value(SECTIONS.Display, KEYS.Fullscreen) else get_window().MODE_WINDOWED


func revert_config():
	for section in default_config.keys():
		for key in default_config[section]:
			config.set_value(section, key, default_config[section][key])
	save_config()
	load_config()


func set_value(section: String, key: String, value):
	config.set_value(section, key, value)


func get_value(section: String, key: String):
	if config.has_section_key(section, key):
		return config.get_value(section, key)
	return null


func _check_config() -> bool:
	if (get_value(SECTIONS.Audio, KEYS.Master) != null
		and get_value(SECTIONS.Audio, KEYS.Music) != null
		and get_value(SECTIONS.Audio, KEYS.SFX) != null
		and get_value(SECTIONS.Display, KEYS.Fullscreen) != null
		and get_value(SECTIONS.Gameplay, KEYS.SkipTutorial) != null
	): 
		return true
	
	return false
