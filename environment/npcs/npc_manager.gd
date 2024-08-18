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
	var target_decor = []
	for key in demo.decor_manager.all_decor.keys().filter(func(b): return NPC.is_valid_target_block(b)):
		target_decor.append_array(demo.decor_manager.get_decor(key))
	
	for block in BlockManager.placed_blocks.filter(func(b): return b.type == Block.Type.RESIDENTIAL):
		if randf() < 0.8:
			continue
		# filter this block's decor on DOOR and grab the first one
		var doors = demo.decor_manager.get_decor(block).filter(func(e): return e.decor_type == BlockDecorTypes.DOOR)
		if !doors.is_empty() && !npcs.any(func(e): return e.my_door == doors[0]):
			spawn_npc(doors[0], choose_target_decor(doors[0], target_decor))

func spawn_npc(door: BlockDecor, target: BlockDecor):
	if target == null:
		return
	var salamug = SALAMUG_SCENE.instantiate() as NPC
	demo.add_child(salamug)
	salamug.init(self, door, target)
	npcs.append(salamug)
	
func despawn_npc(npc: NPC):
	npcs.remove_at(npcs.find(npc))
	npc.queue_free()

func choose_target_decor(door: BlockDecor, all_decor: Array) -> BlockDecor:
	if !all_decor.is_empty():
		var decor = all_decor.filter(func(e): return NPC.is_valid_target(door, e))
		return null if decor.is_empty() else decor[randi() % decor.size()]
	return null
	
