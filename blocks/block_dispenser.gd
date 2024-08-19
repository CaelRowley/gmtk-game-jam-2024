extends Button
class_name BlockDispenser

var demo: Demo
var upcoming_block: Block
var preview_anchor: Control

func init(_demo: Demo) -> void:
	demo = _demo
	print(demo)
	for child in GetUtil.get_all_children(get_parent(), true):
		print("checkign child: "+ str(child.name))
		if child.name == "PreviewAnchor":
			preview_anchor = child
			print("found it!")
			break
	progress_upcoming_block()

func _pressed() -> void:
	print("pressed")
	if BlockManager.current_block != null: print("Stop cheating")
	else: progress_held_block()
		
func _process(_delta: float) -> void:
	if demo == null:
		return
	if BlockManager.current_block != null:
		update_held_tile_map(BlockManager.current_block)
		demo.next_tile_map.position = demo.get_local_mouse_position() - (Vector2.ONE * demo.tile_size / 2.0)

func progress_upcoming_block():
	upcoming_block = BlockManager.get_random_block(Player.lvl)
	demo.next_tile_map.reparent(preview_anchor, true)
	var block_size = 1 + upcoming_block.get_peak()
	demo.next_tile_map.position = Vector2(-64 * block_size, 16 * block_size)
	demo.next_tile_map.scale = Vector2.ONE / (3 + block_size)
	demo.next_tile_map.rotation = 5
	update_held_tile_map(upcoming_block)

func progress_held_block():
	print("anchor pos: " + str(preview_anchor.global_position))
	
	demo.next_tile_map.reparent(demo, true)
	demo.next_tile_map.position = demo.get_local_mouse_position() - (Vector2.ONE * demo.tile_size / 2.0)
	demo.next_tile_map.scale = Vector2.ONE
	demo.next_tile_map.rotation = 0
	
	#create_tween().tween_property(demo.next_tile_map, "position", Vector2.ZERO, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	#create_tween().tween_property(demo.next_tile_map, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	#create_tween().tween_property(demo.next_tile_map, "rotation", 0, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	BlockManager.set_current_block(upcoming_block)
	update_held_tile_map(BlockManager.current_block)

func update_held_tile_map(block: Block):
	#print("update held tile map :D")
	demo.next_tile_map.clear()
	demo.shadow_tile_map.clear()
	if block == null:
		return
	var tile := demo.shadow_tile_map.local_to_map(demo.get_local_mouse_position()) as Vector2
	var terrain_id := block.get_source() - 1
	if terrain_id >= 6:
		terrain_id = 2
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
	
	var cloud_buster_cost := 0 * (Player.lvl * Player.lvl) 
	if Player.coins >= cloud_buster_cost:
		if BlockManager.get_peak() < get_cloud_threshold()+2:
			if BlockManager.current_block != null and BlockManager.current_block.type == Block.Type.CLOUD_BUSTER:
				print("Stop cheating")
			else:
				Player.coins -= cloud_buster_cost
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
			return -31
		3:
			return -86
		4:
			return -99999999
	return 0
