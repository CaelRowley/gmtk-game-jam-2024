extends Node2D
class_name Demo

const tile_size := 128

@onready var shadow_tile_map := $ShadowTileMap as TileMapLayer
@onready var next_tile_map := $NextTileMap as TileMapLayer
@onready var placed_tiles_map := %PlacedTilesMap as TileMapLayer
@onready var row_confetti := preload("res://blocks/row_confetti.tscn")

var decor_manager: BlockDecorManager
var npc_manager: NPCManager
var main_camera: CameraController
var block_dispenser: BlockDispenser

func _ready() -> void:
	Settings.set_value(Settings.SECTIONS.Gameplay, Settings.KEYS.SkipTutorial, true)
	# reset all player stats
	BlockManager.placed_blocks = []
	BlockManager.current_block = null
	Player.food = 50
	Player.water = 50
	Player.electricity = 50
	Player.people = 0
	Player.coins = 0
	Player.lvl = 1
	Player.score = 0
	BlockManager.reset()
	
	Player.update_coins(50)
	Player.coins_changed.connect(_on_coins_changed)
	shadow_tile_map.clear()
	var parent = self
	for child in GetUtil.get_all_children(self):
		if child is CameraController:
			main_camera = child
		if child is BlockDispenser:
			block_dispenser = child
	
	decor_manager = BlockDecorManager.new()
	add_child(decor_manager)
	decor_manager.init(self)
	
	npc_manager = NPCManager.new()
	add_child(npc_manager)
	npc_manager.init(self)
	
	$Camera2D.zoom_changed.connect(_on_zoom_changed)
	
	update_ui()
	AudioManager.play_music(AudioManager.music_level01_track)
	block_dispenser.init(self)
	$CanvasLayer/PauseMenu/PanelContainer/VBoxContainer/MasterSlider.value = Settings.get_value(Settings.SECTIONS.Audio, Settings.KEYS.Master)
	$CanvasLayer/PauseMenu/PanelContainer/VBoxContainer/MusicSlider.value = Settings.get_value(Settings.SECTIONS.Audio, Settings.KEYS.Music)
	$CanvasLayer/PauseMenu/PanelContainer/VBoxContainer/SFXSlider.value = Settings.get_value(Settings.SECTIONS.Audio, Settings.KEYS.SFX)
	$CanvasLayer/PauseMenu/PanelContainer/VBoxContainer/CheckBox.set_pressed_no_signal(Settings.get_value(Settings.SECTIONS.Display, Settings.KEYS.Fullscreen))


func _on_coins_changed():
	$CanvasLayer/GameUI/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/GridContainer/CoinsContainer/HBoxContainer/Coins.text = str(Player.coins)


func _on_zoom_changed(level: int):
	Player.lvl = maxi(Player.lvl, level)
	change_music_for_level(level)

func change_music_for_level(level: int):
	if level == 1:
		AudioManager.play_music(AudioManager.music_level01_track)
	elif level == 2:
		AudioManager.play_music(AudioManager.music_level02_track,false, 0.5)
	elif level == 3:
		AudioManager.play_music(AudioManager.music_level03_track,false, 0.5)
	elif level == 4:
		AudioManager.play_music(AudioManager.music_level04_track,false, 0.5)
	pass


func _input(event: InputEvent) -> void:
	if  BlockManager.current_block != null && event.is_action_pressed("ui_accept"):
		place_tile()
	if BlockManager.current_block != null && event.is_action_pressed("clockwise"):
		rotate_clockwise()
	if BlockManager.current_block != null && event.is_action_pressed("counter_clockwise"):
		rotate_counter_clockwise()
	if event.is_action_pressed("ui_cancel"):
		$CanvasLayer/PauseMenu.visible = !$CanvasLayer/PauseMenu.visible


func place_tile() -> void:
	var filled_rows_before := BlockManager.get_filled_rows_count()
	var mouse_pos := get_local_mouse_position()
	var tile := placed_tiles_map.local_to_map(mouse_pos) as Vector2
	var place_tile_sfx = [AudioManager.sfx_place_pop_01,AudioManager.sfx_place_pop_02,AudioManager.sfx_place_pop_03]
	if !is_tile_connected(tile) || is_tile_overlapping(tile) || is_tile_protruding(tile):
		animate_cant_place()
		return
	
	if Player.lvl < 4:
		if BlockManager.current_block.type == Block.Type.CLOUD_BUSTER:
			if BlockManager.current_block.get_peak(tile) > get_cloud_threshold()-4:
				animate_cant_place()
				return
			else:
				AudioManager.play_sfx(AudioManager.drill)
				match get_cloud_threshold():
					-10:
						$BarrierManager/CloudsBarrier1.is_unbreakable = false
					-32:
						$BarrierManager/CloudsBarrier2.is_unbreakable = false
					-87:
						$BarrierManager/CloudsBarrier3.is_unbreakable = false
		else:
			if BlockManager.current_block.get_peak(tile) < get_cloud_threshold():
				animate_cant_place()
				return
	
	AudioManager.play_sfx(place_tile_sfx.pick_random())
	next_tile_map.clear()
	var coords = []
	for cell in BlockManager.current_block.coords:
		coords.push_back(tile + cell)
	var new_block := Block.new()

	new_block.init(coords, BlockManager.current_block.type, BlockManager.current_block.value, true)
	BlockManager.add_placed_block(new_block)
	decor_manager.add_decor(new_block, placed_tiles_map)
	update_cells()
	upkeep()
	BlockManager.current_block = null
	block_dispenser.progress_upcoming_block(null)
	shadow_tile_map.clear()
	var filled_rows_after := BlockManager.get_filled_rows_count()
	if filled_rows_after > filled_rows_before:
		print(filled_rows_after)
		var row_confetti_scene := row_confetti.instantiate() as Node2D
		row_confetti_scene.position = mouse_pos
		add_child(row_confetti_scene)
	
	$CanvasLayer/FailMenu/PanelContainer/VBoxContainer/Score.text = "Final Score: " + str(Player.score)
	if Player.food <= 0:
		$CanvasLayer/FailMenu.show()
		$CanvasLayer/FailMenu/PanelContainer/VBoxContainer/Food.show()
	if Player.water <= 0:
		$CanvasLayer/FailMenu.show()
		$CanvasLayer/FailMenu/PanelContainer/VBoxContainer/Water.show()
	if Player.electricity <= 0:
		$CanvasLayer/FailMenu.show()
		$CanvasLayer/FailMenu/PanelContainer/VBoxContainer/Power.show()
	if Player.food <= 0 and Player.water <= 0 and Player.electricity <= 0:
		$CanvasLayer/FailMenu/PanelContainer/VBoxContainer/Wow.show()


func update_cells() -> void:
	for block in BlockManager.placed_blocks:
		var terrain_id := block.get_source() - 1
		placed_tiles_map.set_cells_terrain_connect(block.coords, 0, terrain_id, true)
		if !block.is_placed_by_player:
			block.is_placed_by_player = block.is_connected_to_player_block()
	for block in BlockManager.placed_blocks:
		decor_manager.update_decor(block, block.is_producing(placed_tiles_map))


func is_tile_connected(tile: Vector2) -> bool:
	for cell in  BlockManager.current_block.coords:
		for block in BlockManager.placed_blocks:
			if block.is_placed_by_player:
				for coord in block.coords:
					if coord == tile + cell + Vector2(0, -1):
						return true
					if coord == tile + cell + Vector2(0, 1):
						return true
					if coord == tile + cell + Vector2(1, 0):
						return true
					if coord == tile + cell + Vector2(-1, 0):
						return true
	return false


func is_tile_overlapping(tile: Vector2) -> bool:
	for cell in BlockManager.current_block.coords:
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell)):
			return true
	return false


func is_tile_protruding(tile: Vector2) -> bool:
	for cell in BlockManager.current_block.coords:
		if tile.x + cell.x > ($Camera2D.zoom_level*2 -1) or tile.x + cell.x < (-(2*$Camera2D.zoom_level)):
			return true
	return false


func animate_cant_place() -> void:
	AudioManager.play_sfx(AudioManager.sfx_accent_boing)
	var tween = get_tree().create_tween()
	tween.tween_property(next_tile_map, "scale", Vector2.ONE*1.2, 0.1)
	tween.tween_property(next_tile_map, "scale", Vector2.ONE*1, 0.1)


func rotate_clockwise() -> void:
	if BlockManager.current_block.type != Block.Type.CLOUD_BUSTER:
		for i in range(BlockManager.current_block.coords.size()):
			var new_coords := BlockManager.current_block.coords.duplicate() as Array
			var new_rotation := new_coords[i].rotated(deg_to_rad(90)) as Vector2
			new_coords[i].x = roundi(new_rotation.x)
			new_coords[i].y = roundi(new_rotation.y)
			BlockManager.current_block.coords = new_coords


func rotate_counter_clockwise() -> void:
	if BlockManager.current_block.type != Block.Type.CLOUD_BUSTER:
		for i in range(BlockManager.current_block.coords.size()):
			var new_coords := BlockManager.current_block.coords.duplicate() as Array
			var new_rotation := new_coords[i].rotated(deg_to_rad(-90)) as Vector2
			new_coords[i].x = roundi(new_rotation.x)
			new_coords[i].y = roundi(new_rotation.y)
			BlockManager.current_block.coords = new_coords


#func get_water() -> int:
	#var count := 0
	#for block in BlockManager.placed_blocks:
		#if block.type == Block.Type.WATER:
			#for cell in block.get_top_cells(placed_tiles_map):
				#if cell == -1:
					#count += 1
	#print("water: ", count)
	#return count
#
#
#func get_food() -> int:
	#var count := 0
	#for block in BlockManager.placed_blocks:
		#if block.type == Block.Type.FOOD:
			#for cell in block.get_left_cells(placed_tiles_map):
				#if cell == -1:
					#count += 1
			#for cell in block.get_right_cells(placed_tiles_map):
				#if cell == -1:
					#count += 1
	#print("food: ", count)
	#return count
#
#
#func get_electricity() -> int:
	#var count := 0
	#for block in BlockManager.placed_blocks:
		#if block.type == Block.Type.ELECTRICITY:
			#for cell in block.get_top_cells(placed_tiles_map):
				#if cell == -1:
					#count += 1
			#for cell in block.get_bot_cells(placed_tiles_map):
				#if cell == -1:
					#count += 1
			#for cell in block.get_left_cells(placed_tiles_map):
				#if cell == -1:
					#count += 1
			#for cell in block.get_right_cells(placed_tiles_map):
				#if cell == -1:
					#count += 1
	#print("electricity: ", count)
	#return count

func upkeep():
	var food := 15
	var water := 15
	var electricity := 15
	var coins := 0
	var people := 0
	for block in BlockManager.placed_blocks:
		food += block.get_food(placed_tiles_map)
		water += block.get_water(placed_tiles_map)
		electricity += block.get_electricity(placed_tiles_map)
		people += block.get_people(placed_tiles_map)
		coins += block.get_coins(placed_tiles_map)
	Player.food += food
	Player.water += water
	Player.electricity += electricity
	Player.coins += coins
	Player.people = people
	
	Player.food -= Player.people
	Player.water -= Player.people
	Player.electricity -= Player.people
	
	Player.update_score()
	update_ui()

	#Food
	var food_change := food-Player.people
	if food_change > 0:
		$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/FoodContainer/Change.text = "(+" + str(food_change) + ")"
	else:
		$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/FoodContainer/Change.text = "(" + str(food_change) + ")"
	#Water
	var water_change := water-Player.people
	if water_change > 0:
		$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/WaterContainer/Change.text = "(+" + str(water_change) + ")"
	else:
		$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/WaterContainer/Change.text = "(" + str(water_change) + ")"
	#Electricity
	var electricity_change := electricity-Player.people
	if electricity_change > 0:
		$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/PowerContainer/Change.text = "(+" + str(electricity_change) + ")"
	else:
		$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/PowerContainer/Change.text = "(" + str(electricity_change) + ")"
	#Coins
	$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/CoinContainer/Change.text = "(+" + str(coins) + ")"


func update_ui() -> void:
	$CanvasLayer/GameUI/HBoxContainer/VBoxContainerLeft/LevelContainer/Level.text = str(Player.lvl)
	$CanvasLayer/GameUI/HBoxContainer/VBoxContainerLeft/HeightContainer/Floors.text = str(BlockManager.get_height())
	$CanvasLayer/GameUI/HBoxContainer/VBoxContainerLeft/PeopleContainer/People.text = str(Player.people)
	$CanvasLayer/GameUI/HBoxContainer/VBoxContainer/Control/Value.text = str(Player.score)
	$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/FoodContainer/Total.text = str(Player.food)
	$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/WaterContainer/Total.text = str(Player.water)
	$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/PowerContainer/Total.text = str(Player.electricity)
	$CanvasLayer/GameUI/HBoxContainer/VBoxContainerRight/CoinContainer/Total.text = str(Player.coins)



func get_cloud_threshold() -> int:
	match Player.lvl:
		1:
			return -10
		2:
			return -32
		3:
			return -87
		4:
			return -99999999
	return 0

#func _on_get_cloud_buster_pressed() -> void:
	#var cloud_buster_cost := 0 * (Player.lvl * Player.lvl) 
	#if Player.coins >= cloud_buster_cost:
		#if BlockManager.get_peak() < get_cloud_threshold()+2:
			#if BlockManager.current_block != null and BlockManager.current_block.type == Block.Type.CLOUD_BUSTER:
				#print("Stop cheating")
			#else:
				#Player.coins -= cloud_buster_cost
			#BlockManager.select_cloud_buster()


func _on_master_slider_value_changed(value: float) -> void:
	Settings.set_value(Settings.SECTIONS.Audio, Settings.KEYS.Master, value)
	AudioManager.set_volume(AudioManager.AUDIO_BUSES.Master, value)
	Settings.save_config()

func _on_music_slider_value_changed(value: float) -> void:
	Settings.set_value(Settings.SECTIONS.Audio, Settings.KEYS.Music, value)
	AudioManager.set_volume(AudioManager.AUDIO_BUSES.Music, value)
	Settings.save_config()

func _on_sfx_slider_value_changed(value: float) -> void:
	Settings.set_value(Settings.SECTIONS.Audio, Settings.KEYS.SFX, value)
	AudioManager.set_volume(AudioManager.AUDIO_BUSES.SFX, value)
	Settings.save_config()

func _on_check_box_toggled(button_pressed: bool) -> void:
	Settings.set_value(Settings.SECTIONS.Display, Settings.KEYS.Fullscreen, button_pressed)
	if (get_window().mode != get_window().MODE_FULLSCREEN and Settings.get_value(Settings.SECTIONS.Display, Settings.KEYS.Fullscreen)) or (get_window().mode == get_window().MODE_FULLSCREEN and !Settings.get_value(Settings.SECTIONS.Display, Settings.KEYS.Fullscreen)):
		get_window().mode = get_window().MODE_FULLSCREEN if Settings.get_value(Settings.SECTIONS.Display, Settings.KEYS.Fullscreen) else get_window().MODE_WINDOWED
	Settings.save_config()


func _on_restart_button_pressed() -> void:
	SceneManager.goto_scene("res://levels/game.tscn")


func _on_quit_button_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()


func _on_resume_button_pressed() -> void:
	$CanvasLayer/PauseMenu.visible = !$CanvasLayer/PauseMenu.visible


func _on_tutorial_button_pressed() -> void:
	SceneManager.goto_scene("res://levels/new_tut.tscn")


func _on_pause_button_pressed() -> void:
	$CanvasLayer/PauseMenu.visible = !$CanvasLayer/PauseMenu.visible
