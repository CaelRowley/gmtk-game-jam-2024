extends Node
class_name BlockDecorTypes

static var registered_decor_types = {}

static var DOOR = create(Block.Type.RESIDENTIAL, "door_on", "door_off")
static var WINDOW = create(Block.Type.RESIDENTIAL, "window_on", "window_off")
static var BUSINESS_DOOR = create(Block.Type.BUSINESS, "business_door_on", "business_door_off")
static var BUSINESS_WINDOW = create(Block.Type.BUSINESS, "business_window_on", "business_window_off")
static var ELECTRIC_PANEL = create(Block.Type.ELECTRICITY, "electric_panel_on", "electric_panel_off")
static var LADDER = create(Block.Type.WATER, "ladder_off", "ladder_on")
static var VALVE = create(Block.Type.WATER, "valve_off", "valve_on")
static var FLOWER = create(Block.Type.FOOD, "plant_flower_off", "plant_flower_on")
static var BERRIES = create(Block.Type.FOOD, "plant_berries_off", "plant_berries_on")

static var CLOUD_BUSTER_ICON = create(Block.Type.CLOUD_BUSTER, "cloud_buster_icon", "cloud_buster_icon")
static var DANGER_ICON = create(Block.Type.CLOUD_BUSTER, "danger_icon", "danger_icon")
static var COGS = create(Block.Type.CLOUD_BUSTER, "cogs", "cogs")

var on_sprite
var off_sprite

static func create(type: Block.Type, on_sprite: String, off_sprite: String) -> BlockDecorTypes:
	var new_decor_type = BlockDecorTypes.new()
	new_decor_type.on_sprite = load("res://blocks/decor/" + on_sprite + ".png")
	new_decor_type.off_sprite = load("res://blocks/decor/" + off_sprite + ".png")	
	
	# Add the new decor type to the dictionary under the specefied type for later use
	var decor_types = registered_decor_types[type] if registered_decor_types.has(type) else []
	decor_types.append(new_decor_type)
	registered_decor_types[type] = decor_types
	return new_decor_type
	
static func get_decor_of_type(type: Block.Type) -> Array:
	if registered_decor_types.has(type):
		return registered_decor_types[type].duplicate()
	return []
