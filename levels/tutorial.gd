extends Node2D

const tile_size := 128

@onready var shadow_tile_map := $ShadowTileMap as TileMapLayer
@onready var next_tile_map := $NextTileMap as TileMapLayer
@onready var placed_tiles_map := %PlacedTilesMap as TileMapLayer
@onready var row_confetti := preload("res://blocks/row_confetti.tscn")

var main_camera: CameraController

#Tutorial Pages
@onready var page_01 = $CanvasLayer/Tutorial/MarginContainer/Page01
@onready var page_02 = $CanvasLayer/Tutorial/MarginContainer/Page02_Action
@onready var page_03 = $CanvasLayer/Tutorial/MarginContainer/Page03
@onready var page_04 = $CanvasLayer/Tutorial/MarginContainer/Page04_Action
@onready var page_05 = $CanvasLayer/Tutorial/MarginContainer/Page05
@onready var page_06 = $CanvasLayer/Tutorial/MarginContainer/Page06
@onready var page_07 = $CanvasLayer/Tutorial/MarginContainer/Page07_Action
@onready var page_08 = $CanvasLayer/Tutorial/MarginContainer/Page08
@onready var page_09 = $CanvasLayer/Tutorial/MarginContainer/Page09_Action
@onready var page_10 = $CanvasLayer/Tutorial/MarginContainer/Page10
@onready var page_11 = $CanvasLayer/Tutorial/MarginContainer/Page11_Action
@onready var page_12 = $CanvasLayer/Tutorial/MarginContainer/Page12
@onready var page_13 = $CanvasLayer/Tutorial/MarginContainer/Page13
@onready var page_14 = $CanvasLayer/Tutorial/MarginContainer/Page14_Action
@onready var page_15 = $CanvasLayer/Tutorial/MarginContainer/Page15

var game_scene = preload("res://levels/game.tscn").instantiate()

var tutorial_page := 2


func _ready() -> void:
	# reset all player stats
	BlockManager.placed_blocks = []
	BlockManager.current_block = null
	Player.food = 0
	Player.water = 0
	Player.electricity = 0
	Player.people = 0
	Player.coins = 0
	Player.lvl = 1
	Player.score = 0
	BlockManager.reset()
	
	Player.update_coins(50)
	Player.coins_changed.connect(_on_coins_changed)
	shadow_tile_map.clear()
	
	#$CanvasLayer/GameUI/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Level.text = "Level: " + str(Player.lvl)
	#$CanvasLayer/GameUI/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Floors.text = "Floors: " + str(BlockManager.get_height())
	$CanvasLayer/GameUI/PanelContainer2/Score.text = "Score: " + str(Player.score)
	$CanvasLayer/GameUI/PanelContainer/VBoxContainer/HBoxContainer/CenterContainer/HBoxContainer/People.text = str(Player.people)
	$"CanvasLayer/GameUI/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/GridContainer/Food Container/HBoxContainer/Food".text = str(Player.food)
	$CanvasLayer/GameUI/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/GridContainer/WaterContainer/HBoxContainer/Water.text = str(Player.water)
	$CanvasLayer/GameUI/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/GridContainer/ElectricityContainer/HBoxContainer/Electricity.text = str(Player.electricity)
	$CanvasLayer/GameUI/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/GridContainer/CoinsContainer/HBoxContainer/Coins.text = str(Player.coins)
	AudioManager.play_music(AudioManager.music_level01_track)
	$CanvasLayer/PauseMenu/VBoxContainer/MasterSlider.value = Settings.get_value(Settings.SECTIONS.Audio, Settings.KEYS.Master)
	$CanvasLayer/PauseMenu/VBoxContainer/MusicSlider.value = Settings.get_value(Settings.SECTIONS.Audio, Settings.KEYS.Music)
	$CanvasLayer/PauseMenu/VBoxContainer/SFXSlider.value = Settings.get_value(Settings.SECTIONS.Audio, Settings.KEYS.SFX)
	$CanvasLayer/PauseMenu/VBoxContainer/CheckBox.set_pressed_no_signal(Settings.get_value(Settings.SECTIONS.Display, Settings.KEYS.Fullscreen))
	
	if Settings.get_value(Settings.SECTIONS.Gameplay, Settings.KEYS.SkipTutorial):
		$CanvasLayer/Tutorial/MarginContainer/Page01/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page02_Action/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page03/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page04_Action/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page05/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page06/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page07_Action/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page08/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page09_Action/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page10/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page11_Action/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page12/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page13/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page14_Action/SkipContainer.show()
		$CanvasLayer/Tutorial/MarginContainer/Page15/SkipContainer.show()


func _process(_delta: float) -> void:
	if BlockManager.current_block != null:
		next_tile_map.clear()
		shadow_tile_map.clear()
		var tile := shadow_tile_map.local_to_map(get_local_mouse_position()) as Vector2
		for cell in BlockManager.current_block.coords:
			next_tile_map.set_cell(cell, BlockManager.current_block.get_source(), Vector2.ZERO)
			shadow_tile_map.set_cell(tile + cell, 0, Vector2.ONE)
	next_tile_map.position = get_local_mouse_position() - (Vector2.ONE * tile_size / 2.0)


func _input(event: InputEvent) -> void:
	if  BlockManager.current_block != null && event.is_action_pressed("ui_accept"):
		place_tile()
	if BlockManager.current_block != null && event.is_action_pressed("clockwise"):
		rotate_clockwise()
	if BlockManager.current_block != null && event.is_action_pressed("counter_clockwise"):
		rotate_counter_clockwise()
	if event.is_action_pressed("ui_cancel"):
		$CanvasLayer/PauseMenu.visible = !$CanvasLayer/PauseMenu.visible


func _on_coins_changed():
	$CanvasLayer/GameUI/PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/GridContainer/CoinsContainer/HBoxContainer/Coins.text = str(Player.coins)


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
	update_cells()
	upkeep()
	BlockManager.current_block = null
	shadow_tile_map.clear()
	var filled_rows_after := BlockManager.get_filled_rows_count()
	if filled_rows_after > filled_rows_before:
		print(filled_rows_after)
		var row_confetti_scene := row_confetti.instantiate() as Node2D
		row_confetti_scene.position = mouse_pos
		add_child(row_confetti_scene)
	BlockManager.current_block = null
	match tutorial_page:
		2:
			page_02.visible = false
			page_03.visible = true
		4:
			page_04.visible = false
			page_05.visible = true
		7:
			page_07.visible = false
			page_08.visible = true
		9:
			page_09.visible = false
			page_10.visible = true
		11:
			page_11.visible = false
			page_12.visible = true
		14: 
			page_14.visible = false
			page_15.visible = true
	#BlockManager.select_random_block()


func update_cells() -> void:
	for block in BlockManager.placed_blocks:
		placed_tiles_map.set_cells_terrain_connect(block.coords, 0, block.get_source() - 1, false)
		#for coord in block.coords:
		#	placed_tiles_map.set_cell(coord, block.get_source(), Vector2.ZERO)
			

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
	for i in range(BlockManager.current_block.coords.size()):
		var new_coords := BlockManager.current_block.coords.duplicate() as Array
		var new_rotation := new_coords[i].rotated(deg_to_rad(90)) as Vector2
		new_coords[i].x = roundi(new_rotation.x)
		new_coords[i].y = roundi(new_rotation.y)
		BlockManager.current_block.coords = new_coords


func rotate_counter_clockwise() -> void:
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


func income():
	Player.food = 15				#starting value fails in 15 rounds
	Player.water = 20				#starting value fails in 20 rounds
	Player.electricity = 30 		#starting value fails in 30 rounds
	Player.people = 0
	Player.coins = 0
	for block in BlockManager.placed_blocks:
		Player.food += block.get_food(placed_tiles_map)
		Player.water += block.get_water(placed_tiles_map)
		Player.electricity += block.get_electricity(placed_tiles_map)
		Player.people += block.get_people(placed_tiles_map)
		Player.coins += block.get_coins(placed_tiles_map)
	
	#UI Stat Elements
	#$CanvasLayer/GameUI/HList/People.text = "People: " + str(Player.people)
	
	#Food
	var food_min_value = Player.food
	var food_max_value = Player.food
	#$CanvasLayer/GameUI/HList/Food/ProgressBar.min_value = food_min_value
	#$CanvasLayer/GameUI/HList/Food/ProgressBar.max_value = food_max_value
	#$CanvasLayer/GameUI/HList/Food.text =str(food_min_value) + " / " + str(food_max_value)
	#Water
	var water_min_value = Player.water
	var water_max_value = Player.water
	#$CanvasLayer/GameUI/HList/Water/ProgressBar.min_value = water_min_value
	#$CanvasLayer/GameUI/HList/Water/ProgressBar.max_value = water_max_value
	#$CanvasLayer/GameUI/HList/Water.text =str(water_min_value) + " / " + str(water_max_value)
	
	#Electricity
	var electricity_min_value = Player.electricity
	var electricity_max_value = Player.electricity
	#$CanvasLayer/GameUI/HList/Electricity/ProgressBar.min_value = Player.electricity
	#$CanvasLayer/GameUI/HList/Electricity/ProgressBar.max_value = Player.electricity
	#$CanvasLayer/GameUI/HList/Electricity.text =str(electricity_min_value) + " / " + str(electricity_max_value)
	
	#$CanvasLayer/GameUI/HList/Coins.text = "Coins: " + str(Player.coins)


func upkeep():
	pass


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


#Tutorial Menu Actions
func _on_return_button_pressed() -> void:
	Settings.set_value(Settings.SECTIONS.Gameplay, Settings.KEYS.SkipTutorial, true)
	SceneManager.goto_scene("res://levels/game.tscn")


func _on_page_01_next_button_pressed() -> void:
	tutorial_page = 2
	BlockManager.set_block(Block.Type.RESIDENTIAL, {
			"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
			"value": 3,
		})
	page_01.visible = false
	page_02.visible = true

func _on_page_03_next_button_pressed() -> void:
	tutorial_page = 4
	BlockManager.set_block(Block.Type.FOOD, {
			"coords": [Vector2(0,0)],
			"value": 3,
		})
	page_03.visible = false
	page_04.visible = true

func _on_page_05_next_button_pressed() -> void:
	page_05.visible = false
	page_06.visible = true

func _on_page_06_next_button_pressed() -> void:
	tutorial_page = 7
	BlockManager.set_block(Block.Type.WATER, {
			"coords": [Vector2(0,0), Vector2(0,1)],
			"value": 3,
		})
	page_06.visible = false
	page_07.visible = true

func _on_page_08_next_button_pressed() -> void:
	tutorial_page = 9
	BlockManager.set_block(Block.Type.ELECTRICITY, {
			"coords": [Vector2(0,0)],
			"value": 3,
		})
	page_08.visible = false
	page_09.visible = true

func _on_page_10_next_button_pressed() -> void:
	tutorial_page = 11
	BlockManager.set_block(Block.Type.BUSINESS, {
		"coords": [Vector2(0,0), Vector2(0,1)],
		"value": 3,
	})
	page_10.visible = false
	page_11.visible = true

func _on_page_12_next_button_pressed() -> void:
	print("12")
	page_12.visible = false
	page_13.visible = true


func _on_page_13_next_button_pressed() -> void:
	tutorial_page = 14
	BlockManager.set_block(Block.Type.FRAME, {
		"coords": [Vector2(0,0), Vector2(0,1)],
		"value": 3,
	})
	page_13.visible = false
	page_14.visible = true


func _on_page_15_exit_button_pressed() -> void:
	Settings.set_value(Settings.SECTIONS.Gameplay, Settings.KEYS.SkipTutorial, true)
	SceneManager.goto_scene("res://levels/game.tscn")
