extends AnimatedSprite2D
class_name NPC

const MAX_DISTANCE = 512 * 512;

var npc_manager: NPCManager
var my_door: BlockDecor
var my_target: BlockDecor

func init(manager: NPCManager, door: BlockDecor, target: BlockDecor):
	npc_manager = manager
	my_door = door
	my_target = target;
	scale = Vector2.ZERO
	global_position = my_door.global_position;
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(move_to_target)
	
func move_to_target():
	var tween = create_tween()
	tween.tween_property(self, "global_position", my_target.global_position, get_move_speed()).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(work_on_target)

func work_on_target():
	self.play("salamug_work")
	await get_tree().create_timer(randf_range(1, 3)).timeout
	self.play("salamug_fly")
	move_back_home()

func move_back_home():
	var tween = create_tween()
	tween.tween_property(self, "global_position", my_door.global_position, get_move_speed()).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(despawn)
	
func get_move_speed():
	var dis = my_door.global_position.distance_squared_to(my_target.global_position)
	return randf_range(2, 5) * (dis / MAX_DISTANCE);

func despawn():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(func(): npc_manager.despawn_npc(self))

static func is_valid_target_block(block: Block) -> bool:
	return !(block.type == Block.Type.RESIDENTIAL || block.type == Block.Type.FRAME || block.type == Block.Type.CLOUD_BUSTER)

static func is_valid_target(door: BlockDecor, target: BlockDecor) -> bool:
	return door.global_position.distance_squared_to(target.global_position) < MAX_DISTANCE
