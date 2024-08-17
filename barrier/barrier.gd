class_name Barrier
extends Sprite2D

@export var is_unbreakable: bool
const width = 480

var barrier_manager

func init(manager: BarrierManager):
	barrier_manager = manager

func get_nearest_edge(camera_y: float):
	if camera_y < global_position.y: return global_position.y - width
	else: return global_position.y + width
