class_name Barrier
extends Node2D

@export var is_unbreakable: bool
var has_been_broken = false
const _width = 480

var barrier_manager
var particle_emitter: GPUParticles2D
var burst_emitter: GPUParticles2D

func init(manager: BarrierManager):
	barrier_manager = manager
	for child in get_children():
		if child is GPUParticles2D:
			particle_emitter = child
		if child.get_child_count() > 0 && child.get_child(0) is GPUParticles2D:
			burst_emitter = child.get_child(0)

func update_barrier():
	if particle_emitter != null:
		var zoom = barrier_manager.main_camera.zoom_level
		particle_emitter.amount_ratio = zoom * zoom
		particle_emitter.scale = Vector2(zoom, 1)

func break_barrier():
	has_been_broken = true
	if burst_emitter != null:
		print("emitting burst")
		burst_emitter.emitting = true;

func get_overshoot(camera: CameraController) -> float:
	var overshoot = (get_nearest_edge(camera) - camera.camera_y) * 0.01
	return overshoot

func get_nearest_edge(camera: CameraController):
	if camera.camera_y < global_position.y: return global_position.y - get_width(camera)
	else: return global_position.y + get_width(camera)

func is_above(other: Node2D) -> bool:
	return other.global_position.y > global_position.y

func get_width(camera: CameraController) -> float:
	return _width * camera.zoom_level
