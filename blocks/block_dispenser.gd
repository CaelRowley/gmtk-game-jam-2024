extends Button
class_name BlockDispenser

@export var cloud_buster_cost := 50
@export var food_cost := 10
@export var food_cost_increase := 10
@export var food_cost_max := 100
@export var water_cost := 10
@export var water_cost_increase := 10
@export var water_cost_max := 100
@export var electricity_cost := 10
@export var electricity_cost_increase := 10
@export var electricity_cost_max := 100
@export var business_cost := 50
@export var business_cost_increase := 50
@export var business_cost_max := 500

var demo
var preview_anchor: Control
var upcoming_block: Block
var preview_tween: Tween

@onready var cloud_buster_button: Button = $GridContainer/CloudBusterButton
@onready var cloud_buster_label: Label = $GridContainer/CloudBusterButton/Label
@onready var food_button: Button = $GridContainer/FoodButton
@onready var food_label: Label = $GridContainer/FoodButton/Label
@onready var water_button: Button = $GridContainer/WaterButton
@onready var water_label: Label = $GridContainer/WaterButton/Label
@onready var electric_button: Button = $GridContainer/ElectricityButton
@onready var electric_label: Label = $GridContainer/ElectricityButton/Label
@onready var business_button: Button = $GridContainer/BusinessButton
@onready var business_label: Label = $GridContainer/BusinessButton/Label

func _ready() -> void:
	cloud_buster_label.text = str(cloud_buster_cost)
	food_label.text = str(food_cost)
	water_label.text = str(water_cost)
	electric_label.text = str(electricity_cost)
	business_label.text = str(business_cost)
	cloud_buster_button.set_disabled(true) 
	food_button.set_disabled(true) 
	water_button.set_disabled(true) 
	electric_button.set_disabled(true) 
	business_button.set_disabled(true) 

func init(_demo) -> void:
	demo = _demo
	print(demo)
	for child in GetUtil.get_all_children(get_parent(), true):
		print("checkign child: "+ str(child.name))
		if child.name == "PreviewAnchor":
			preview_anchor = child
			print("found it!")
			break
	progress_upcoming_block(null)
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)

func _input(event: InputEvent) -> void:
	if  BlockManager.current_block != null && event.is_action_pressed("ui_cancel"):
		return_block(BlockManager.current_block)
	
func _mouse_enter() -> void:
	if(upcoming_block != null):
		var offset = get_preview_block_offset(1 + upcoming_block.get_peak()) + Vector2(-64, 32)
		preview_tween = create_tween()
		preview_tween.tween_property(demo.next_tile_map, "position", offset, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _mouse_exit() -> void:
	if(upcoming_block != null):
		var offset = get_preview_block_offset(1 + upcoming_block.get_peak())
		preview_tween = create_tween()
		preview_tween.tween_property(demo.next_tile_map, "position", offset, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _pressed() -> void:
	preview_tween.stop()
	if BlockManager.current_block != null: return_block(BlockManager.current_block)
	else: progress_held_block()
		
func _process(_delta: float) -> void:
	if demo == null:
		return
	if BlockManager.current_block != null:
		update_held_tile_map(BlockManager.current_block)
		demo.next_tile_map.position = demo.get_local_mouse_position() - (Vector2.ONE * demo.tile_size / 2.0)

func progress_upcoming_block(type):
	if BlockManager.get_peak() < get_cloud_threshold() + 2:
		cloud_buster_button.set_disabled(false)
	if Player.lvl > 1:
		food_button.set_disabled(false)
		water_button.set_disabled(false)
		electric_button.set_disabled(false)
	if Player.lvl > 2:
		business_button.set_disabled(false)
		
	upcoming_block = BlockManager.get_random_block(Player.lvl)
	if type != null:
		upcoming_block.type = type
	update_dispenser_preview()

func get_preview_block_offset(block_size: float) -> Vector2:
	return Vector2(-48 * block_size, 16 * block_size)

func return_block(block):
	BlockManager.current_block = null
	upcoming_block = block
	update_dispenser_preview()

func update_dispenser_preview():
	demo.next_tile_map.reparent(preview_anchor, true)
	var block_size = 1 + upcoming_block.get_peak()
	demo.next_tile_map.position = get_preview_block_offset(block_size)
	demo.next_tile_map.scale = Vector2.ONE / (3 + block_size)
	demo.next_tile_map.rotation = 5
	update_held_tile_map(upcoming_block)
	demo.shadow_tile_map.clear()

func progress_held_block():
	demo.next_tile_map.reparent(demo, true)
	demo.next_tile_map.position = demo.get_local_mouse_position() - (Vector2.ONE * demo.tile_size / 2.0)
	demo.next_tile_map.scale = Vector2.ONE
	demo.next_tile_map.rotation = 0

	BlockManager.set_current_block(upcoming_block)
	update_held_tile_map(BlockManager.current_block)
	upcoming_block = null


func progress_current_block():
	demo.next_tile_map.reparent(demo, true)
	demo.next_tile_map.position = demo.get_local_mouse_position() - (Vector2.ONE * demo.tile_size / 2.0)
	demo.next_tile_map.scale = Vector2.ONE
	demo.next_tile_map.rotation = 0
	update_held_tile_map(BlockManager.current_block)
	upcoming_block = null


func update_held_tile_map(block: Block):
	demo.next_tile_map.clear()
	demo.shadow_tile_map.clear()
	if block == null:
		return
	var tile := demo.shadow_tile_map.local_to_map(demo.get_local_mouse_position()) as Vector2
	var terrain_id := block.get_source() - 1
	demo.next_tile_map.set_cells_terrain_connect(block.coords, 0, terrain_id, true)
	var shadow_coords = []
	for c in block.coords:
		shadow_coords.append(tile + c)
	demo.shadow_tile_map.set_cells_terrain_connect(shadow_coords, 0, terrain_id, true)

func find_demo() -> Demo:
	var i = 0
	var parent = get_parent()
	while demo == null:
		if parent == null:
			break;
		if parent is Demo:
			return parent
		parent = parent.get_parent()
		i += 1
		if i > 32:
			break
	if demo == null:
		print("Block Dispenser can't find the Demo script!")
	return null


func _on_cloud_buster_button_pressed() -> void:
	#create_tween().tween_property(demo.next_tile_map, "position", Vector2.ZERO, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	#create_tween().tween_property(demo.next_tile_map, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	#create_tween().tween_property(demo.next_tile_map, "rotation", 0, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	
	var cost := cloud_buster_cost * (Player.lvl * Player.lvl) 
	if Player.coins >= cost:
		if BlockManager.get_peak() < get_cloud_threshold()+2:
			if BlockManager.current_block != null and BlockManager.current_block.type == Block.Type.CLOUD_BUSTER:
				print("Stop cheating")
			else:
				cloud_buster_label.text = str(cloud_buster_cost * ((Player.lvl+1) * (Player.lvl+1)))
				Player.coins -= cost
				demo.next_tile_map.reparent(demo, true)
				demo.next_tile_map.position = demo.get_local_mouse_position() - (Vector2.ONE * demo.tile_size / 2.0)
				demo.next_tile_map.scale = Vector2.ONE
				demo.next_tile_map.rotation = 0
				BlockManager.select_cloud_buster()
				update_held_tile_map(BlockManager.current_block)


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


func _on_food_button_pressed() -> void:
	if BlockManager.current_block == null and purchase(food_cost):
		food_cost = mini(food_cost_max, food_cost+food_cost_increase)
		progress_upcoming_block(Block.Type.FOOD)
		update_food_label()
		
func _on_water_button_pressed() -> void:
	if BlockManager.current_block == null and purchase(water_cost):
		water_cost = mini(water_cost_max, water_cost+water_cost_increase)
		progress_upcoming_block(Block.Type.WATER)
		update_water_label()

func _on_electricity_button_pressed() -> void:
	if BlockManager.current_block == null and purchase(electricity_cost):
		electricity_cost = mini(electricity_cost_max, electricity_cost+electricity_cost_increase)
		progress_upcoming_block(Block.Type.ELECTRICITY)
		update_electric_label()

func _on_business_button_pressed() -> void:
	if BlockManager.current_block == null and purchase(business_cost):
		business_cost = mini(business_cost_max, business_cost+business_cost_increase)
		progress_upcoming_block(Block.Type.BUSINESS)
		update_business_label()

# Returns if the purchase was succesful
func purchase(cost: int) -> bool:
	if Player.coins < cost:
		return false
	Player.update_coins(Player.coins-cost)
	AudioManager.play_sfx(AudioManager.coin_drop)
	disable_all_buttons()
	return true

func update_food_label():
	food_label.text = str(food_cost)
	food_label.modulate = Color.RED if Player.coins < food_cost else Color.WHITE
	print("color = " + str(food_label.modulate))
	
func update_water_label():
	water_label.text = str(water_cost)
	water_label.modulate = Color.RED if Player.coins < water_cost else Color.WHITE

func update_electric_label():
	electric_label.text = str(electricity_cost)
	electric_label.modulate = Color.RED if Player.coins < electricity_cost else Color.WHITE

func update_business_label():
	business_label.text = str(business_label)
	business_label.modulate = Color.RED if (Player.coins < business_cost) else Color.WHITE

func update_cloud_buster_label():
	cloud_buster_label.text = str(cloud_buster_cost)
	cloud_buster_label.modulate = Color.RED if Player.coins < cloud_buster_cost else Color.WHITE
	
func disable_all_buttons():
	for button in [ food_button, water_button, electric_button, business_button ]:
		button.set_disabled(true)
	
	
