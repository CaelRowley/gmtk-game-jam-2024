class_name Barrier
extends Sprite2D

@export var is_unbreakable: bool
var has_been_broken = false
const _width = 480

var barrier_manager

func init(manager: BarrierManager):
	barrier_manager = manager

func break_barrier():
	has_been_broken = true

func get_overshoot(camera: CameraController) -> float:
	var overshoot = (get_nearest_edge(camera) - camera.camera_y) * 0.01
	print("camera at: " + str(camera.camera_y) + ", nearest edge: " + str(get_nearest_edge(camera)) + ", overshoot pixels = " + str((get_nearest_edge(camera) - camera.camera_y)))
	return overshoot

func get_nearest_edge(camera: CameraController):
	if camera.camera_y < global_position.y: return global_position.y - get_width(camera)
	else: return global_position.y + get_width(camera)

func is_above(other: Node2D) -> bool:
	return other.global_position.y > global_position.y

func get_width(camera: CameraController) -> float:
	return _width * camera.zoom_level
