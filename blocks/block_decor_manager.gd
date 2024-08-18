extends Node2D
class_name BlockDecorManager

var demo: Demo
# Dictionary of Block with and Array of BlockDecor
var all_decor = {}

var DOOR_ON = load("res://blocks/decor/door_on.png") as Texture2D
var DOOR_OFF = load("res://blocks/decor/door_off.png") as Texture2D
var WINDOW_ON = load("res://blocks/decor/window_on.png") as Texture2D
var WINDOW_OFF = load("res://blocks/decor/window_off.png") as Texture2D

func init(_demo: Demo):
	demo = _demo

func add_decor(block: Block, tile_map: TileMapLayer):
	var local_coords = []
	for c in block.coords:
		local_coords.append(tile_map.map_to_local(c))
	create_decor(local_coords, block, DOOR_ON, DOOR_OFF)
	create_decor(local_coords, block, WINDOW_ON, WINDOW_OFF)

func create_decor(coords: Array, block: Block, on_sprite: Texture2D, off_sprite: Texture2D):
	if coords.is_empty():
		return
		
	var decor = BlockDecor.new()
	add_child(decor)
	var index = randi() % coords.size()
	decor.init(coords[index], on_sprite, off_sprite)
	coords.remove_at(index)
	
	var block_decor = all_decor[block] if all_decor.has(block) else [] 
	block_decor.append(decor)
	all_decor[block] = block_decor


func update_decor(block: Block, is_producing: bool):
	if all_decor.has(block):
		for decor in all_decor[block]:
			decor.update(is_producing)
