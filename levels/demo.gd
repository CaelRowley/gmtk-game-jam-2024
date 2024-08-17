extends Node2D

const tile_size := 128

@onready var shadow_tile_map := $ShadowTileMap as TileMapLayer
@onready var next_tile_map := $NextTileMap as TileMapLayer
@onready var placed_tiles_map := %PlacedTilesMap as TileMapLayer


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


func place_tile() -> void:
	var tile := placed_tiles_map.local_to_map(get_local_mouse_position()) as Vector2
	var place_tile_sfx = [AudioManager.sfx_place_pop_01,AudioManager.sfx_place_pop_02,AudioManager.sfx_place_pop_03]
	if !is_tile_connected(tile) || is_tile_overlapping(tile):
		animate_cant_place()
		return
	AudioManager.play_sfx(place_tile_sfx.pick_random())
	next_tile_map.clear()
	var coords = []
	for cell in BlockManager.current_block.coords:
		coords.push_back(tile + cell)
	var new_block := Block.new()
	new_block.init(coords, BlockManager.current_block.type, BlockManager.current_block.value)
	BlockManager.add_placed_block(new_block)
	update_cells()
	income()
	upkeep()
	BlockManager.select_random_block()


func update_cells() -> void:
	for block in BlockManager.placed_blocks:
		for coord in block.coords:
			placed_tiles_map.set_cell(coord, block.get_source(), Vector2.ZERO)


func is_tile_connected(tile: Vector2) -> bool:
	for cell in  BlockManager.current_block.coords:
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell + Vector2(0, -1))):
			return true
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell + Vector2(0, 1))):
			return true
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell + Vector2(1, 0))):
			return true
		if is_instance_valid(placed_tiles_map.get_cell_tile_data(tile + cell + Vector2(-1, 0))):
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
		Player.people += block.get_people()
		Player.coins += block.get_coins(placed_tiles_map)
	
	#UI Stat Elements
	$CanvasLayer/GameUI/HList/People.text = "People: " + str(Player.people)
	
	#Food
	var food_min_value = Player.food
	var food_max_value = Player.food
	$CanvasLayer/GameUI/HList/Food/ProgressBar.min_value = food_min_value
	$CanvasLayer/GameUI/HList/Food/ProgressBar.max_value = food_max_value
	$CanvasLayer/GameUI/HList/Food.text =str(food_min_value) + " / " + str(food_max_value)
	#Water
	var water_min_value = Player.water
	var water_max_value = Player.water
	$CanvasLayer/GameUI/HList/Water/ProgressBar.min_value = water_min_value
	$CanvasLayer/GameUI/HList/Water/ProgressBar.max_value = water_max_value
	$CanvasLayer/GameUI/HList/Water.text =str(water_min_value) + " / " + str(water_max_value)
	
	#Electricity
	var electricity_min_value = Player.electricity
	var electricity_max_value = Player.electricity
	$CanvasLayer/GameUI/HList/Electricity/ProgressBar.min_value = Player.electricity
	$CanvasLayer/GameUI/HList/Electricity/ProgressBar.max_value = Player.electricity
	$CanvasLayer/GameUI/HList/Electricity.text =str(electricity_min_value) + " / " + str(electricity_max_value)
	
	$CanvasLayer/GameUI/HList/Coins.text = "Coins: " + str(Player.coins)


func upkeep():
	Player.food -= 2 * Player.people
	Player.water -= 2 * Player.people
	Player.electricity -= Player.people
	#Player.people -= 0
	#Player.coins -= 0
