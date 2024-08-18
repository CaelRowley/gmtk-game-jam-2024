extends Node2D
class_name NPCManager

static var SALAMUG_SCENE: PackedScene = load("res://environment/npcs/npc_salamug.tscn") as PackedScene

var demo: Demo
var timer = 0
var npcs = []

func init(_demo: Demo):
	demo = _demo
	
func _process(delta: float) -> void:
	timer += delta
	if timer >= 1:
		on_every_second()
		timer = 0
		
func on_every_second():
	for block in BlockManager.placed_blocks.filter(func(b): return b.type == Block.Type.RESIDENTIAL):
		if randf() < 0.8:
			continue
		# filter this block's decor on DOOR and grab the first one
		var doors = demo.decor_manager.get_decor(block).filter(func(e): return e.decor_type == BlockDecorTypes.DOOR)
		if !doors.is_empty() && !npcs.any(func(e): return e.my_door == doors[0]):
			print("chosen door: " + str(doors[0]) + " and block: " + str(block))
			spawn_npc(doors[0], choose_target_decor(doors[0]))

func spawn_npc(door: BlockDecor, target: BlockDecor):
	if target == null:
		return
	print("spawning crature")
	var salamug = SALAMUG_SCENE.instantiate() as NPC
	demo.add_child(salamug)
	salamug.init(door, target)

func choose_target_decor(_door: BlockDecor) -> BlockDecor:
	var workable_blocks = BlockManager.placed_blocks.filter(func(b): return is_workable_block(b))
	if !workable_blocks.is_empty():
		var decor = demo.decor_manager.get_decor(workable_blocks[randi() % workable_blocks.size()])
		print("found decor: " + str(decor))
		return null if decor.is_empty() else decor[randi() % decor.size()]
	return null
	
func is_workable_block(block: Block):
	return !(block.type == Block.Type.RESIDENTIAL || block.type == Block.Type.FRAME || block.type == Block.Type.CLOUD_BUSTER)
