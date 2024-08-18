extends Node2D
class_name Demo

const tile_size := 128

@onready var shadow_tile_map := $ShadowTileMap as TileMapLayer
@onready var next_tile_map := $NextTileMap as TileMapLayer
@onready var placed_tiles_map := %PlacedTilesMap as TileMapLayer

var decor_manager: BlockDecorManager
var main_camera: CameraController
var max_zoom_lvl := 1

func _ready() -> void:
	for child in get_children():
		if child is CameraController:
			main_camera = child
	
	decor_manager = BlockDecorManager.new()
	add_child(decor_manager)
	decor_manager.init(self)
	$Camera2D.zoom_changed.connect(_on_zoom_changed)
	
	$CanvasLayer/GameUI/HList/Level.text = "Level: " + str(max_zoom_lvl)
	$CanvasLayer/GameUI/HList/Height.text = "Height: " + str(BlockManager.get_height())
	$CanvasLayer/GameUI/HList/Score.text = "Score: " + str(Player.score)
	$CanvasLayer/GameUI/HList/People.text = "People: " + str(Player.people)
	$CanvasLayer/GameUI/HList/Food.text = "Food: " + str(Player.food)
	$CanvasLayer/GameUI/HList/Water.text = "Water: " + str(Player.water)
	$CanvasLayer/GameUI/HList/Electricity.text = "Elect: " + str(Player.electricity)
	$CanvasLayer/GameUI/HList/Coins.text = "Coins: " + str(Player.coins)


func _on_zoom_changed(level: int):
	max_zoom_lvl = maxi(max_zoom_lvl, level)


func _process(_delta: float) -> void:
	if BlockManager.current_block != null:
		next_tile_map.clear()
		shadow_tile_map.clear()
		var tile := shadow_tile_map.local_to_map(get_local_mouse_position()) as Vector2
		next_tile_map.set_cells_terrain_connect(BlockManager.current_block.coords, 0, BlockManager.current_block.get_source() - 1, true)
		var shadow_coords = []
		for c in BlockManager.current_block.coords:
			shadow_coords.append(tile + c)
		shadow_tile_map.set_cells_terrain_connect(shadow_coords, 0, BlockManager.current_block.get_source() - 1, true)

	next_tile_map.position = get_local_mouse_position() - (Vector2.ONE * tile_size / 2.0)


func _input(event: InputEvent) -> void:
	if  BlockManager.current_block != null && event.is_action_pressed("ui_accept"):
		place_tile()
	if BlockManager.current_block != null && event.is_action_pressed("clockwise"):
		rotate_clockwise()
	if BlockManager.current_block != null && event.is_action_pressed("counter_clockwise"):
		rotate_counter_clockwise()


func place_tile() -> void:
	var tile := placed_tiles_map.local_to_map(get_local_mouse_position()) as Vector2
	var place_tile_sfx = [AudioManager.sfx_place_pop_01,AudioManager.sfx_place_pop_02,AudioManager.sfx_place_pop_03]
	if !is_tile_connected(tile) || is_tile_overlapping(tile):
		animate_cant_place()
		return
	
	if max_zoom_lvl < 4:
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
	decor_manager.add_decor(new_block, placed_tiles_map)
	update_cells()
	upkeep()
	BlockManager.current_block = null


func update_cells() -> void:
	for block in BlockManager.placed_blocks:
		placed_tiles_map.set_cells_terrain_connect(block.coords, 0, block.get_source() - 1, true)
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
	var food := 0
	var water := 0
	var electricity := 0
	var coins := 0
	for block in BlockManager.placed_blocks:
		food += block.get_food(placed_tiles_map)
		water += block.get_water(placed_tiles_map)
		electricity += block.get_electricity(placed_tiles_map)
		Player.people = block.get_people()
		coins += block.get_coins(placed_tiles_map)
	Player.food += food
	Player.water += water
	Player.electricity += electricity
	Player.coins += coins
		
	Player.food -= Player.people
	Player.water -= Player.people
	Player.electricity -= Player.people
	
	Player.update_score(max_zoom_lvl)
	#Player.people -= 0
	#Player.coins -= 0
	$CanvasLayer/GameUI/HList/Level.text = "Level: " + str(max_zoom_lvl)
	$CanvasLayer/GameUI/HList/Height.text = "Height: " + str(BlockManager.get_height())
	$CanvasLayer/GameUI/HList/Score.text = "Score: " + str(Player.score)
	
	#UI Stat Elements
	$CanvasLayer/GameUI/HList/People.text = "People: " + str(Player.people)
	##Food
	#var food_min_value = Player.food
	#var food_max_value = Player.food
	#$CanvasLayer/GameUI/HList/Food/ProgressBar.min_value = food_min_value
	#$CanvasLayer/GameUI/HList/Food/ProgressBar.max_value = food_max_value
	#$CanvasLayer/GameUI/HList/Food.text =str(food_min_value) + " / " + str(food_max_value)
	##Water
	#var water_min_value = Player.water
	#var water_max_value = Player.water
	#$CanvasLayer/GameUI/HList/Water/ProgressBar.min_value = water_min_value
	#$CanvasLayer/GameUI/HList/Water/ProgressBar.max_value = water_max_value
	#$CanvasLayer/GameUI/HList/Water.text =str(water_min_value) + " / " + str(water_max_value)
	#
	##Electricity
	#var electricity_min_value = Player.electricity
	#var electricity_max_value = Player.electricity
	#$CanvasLayer/GameUI/HList/Electricity/ProgressBar.min_value = Player.electricity
	#$CanvasLayer/GameUI/HList/Electricity/ProgressBar.max_value = Player.electricity
	#$CanvasLayer/GameUI/HList/Electricity.text =str(electricity_min_value) + " / " + str(electricity_max_value)

	$CanvasLayer/GameUI/HList/Food.text = "Food: " + str(Player.food) + " +" + str(food)
	$CanvasLayer/GameUI/HList/Water.text = "Water: " + str(Player.water) + " +" + str(water)
	$CanvasLayer/GameUI/HList/Electricity.text = "Elect: " + str(Player.electricity) + " +" + str(electricity)
	$CanvasLayer/GameUI/HList/Coins.text = "Coins: " + str(Player.coins) + " +" + str(coins)
		

func get_cloud_threshold() -> int:
	match max_zoom_lvl:
		1:
			return -10
		2:
			return -32
		3:
			return -87
		4:
			return -99999999
	return 0


func _on_get_block_button_pressed() -> void:
	if BlockManager.current_block != null:
		print("Stop cheating")
	else:
		BlockManager.select_random_block(max_zoom_lvl)


func _on_get_cloud_buster_pressed() -> void:
	var cloud_buster_cost := 100 * (max_zoom_lvl * max_zoom_lvl) 
	print("Player.coins: ", Player.coins)
	print("cloud_buster_cost: ", cloud_buster_cost)
	if Player.coins >= cloud_buster_cost:
		if BlockManager.get_peak() < get_cloud_threshold()+2:
			if BlockManager.current_block != null:
				print("Stop cheating")
			else:
				Player.coins -= cloud_buster_cost
				BlockManager.select_cloud_buster()
