extends Node2D
class_name BlockDecorManager

var demo: Demo
# Dictionary of Block with and Array of BlockDecor
var all_decor = {}

func init(_demo: Demo):
	demo = _demo

func add_decor(block: Block, tile_map: TileMapLayer):
	var local_coords = []
	for c in block.coords:
		local_coords.append(tile_map.map_to_local(c))
	for decor_type in BlockDecorTypes.get_decor_of_type(block.type):
		create_decor(local_coords, block,decor_type)

func create_decor(coords: Array, block: Block, decor_type: BlockDecorTypes):
	if coords.is_empty():
		return
		
	var decor = BlockDecor.new()
	demo.placed_tiles_map.add_child(decor)
	var index = randi() % coords.size()
	decor.init(coords[index], decor_type)
	coords.remove_at(index)
	
	var block_decor = all_decor[block] if all_decor.has(block) else [] 
	block_decor.append(decor)
	all_decor[block] = block_decor


func update_decor(block: Block, is_producing: bool):
	if all_decor.has(block):
		for decor in all_decor[block]:
			decor.update(is_producing)
