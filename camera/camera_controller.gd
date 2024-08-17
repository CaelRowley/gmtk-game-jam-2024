extends Camera2D

const camera_acceleration = 0.3
const camera_drag = 3
const barrier_drag = 12
const camera_shake_strength = 9;
const camera_shake_fade = 6;

var prev_mouse_position = Vector2.ZERO;
var camera_y = 0;
var camera_velocity = 0;
var camera_shake = 0.0;

var barrier_manager: BarrierManager

func _ready():
	for sibling in get_parent().get_children():
		if sibling is BarrierManager:
			barrier_manager = sibling
			break;
	print("barrier manager = " + str(barrier_manager))

func _process(delta: float):
	var barrier_delta = 0
	var nearest_barrier = barrier_manager.get_nearest_barrier(camera_y)
	if nearest_barrier != null:
		barrier_delta = (nearest_barrier.get_nearest_edge(camera_y) - camera_y) * 0.01

	var mouse_position = get_local_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_delta = prev_mouse_position - mouse_position
		mouse_delta *= (1 - min(abs(barrier_delta), 1))
		camera_velocity = mouse_delta.y
	elif barrier_delta != 0:
		camera_velocity *= (1 - barrier_drag * delta)
		camera_velocity += barrier_delta
	else:
		camera_velocity *= (1 - camera_drag * delta)
	
	camera_y += camera_velocity
	
	global_position.x = 0;
	global_position.y = camera_y
	if(camera_shake > 1):
		global_position.x += randf_range(-camera_shake, camera_shake)
		global_position.y += randf_range(-camera_shake, camera_shake)
		var fade = pow(camera_shake_fade, 2) * max(1, abs(barrier_delta)) * delta
		camera_shake = lerpf(camera_shake, 0.0, fade)
	elif(nearest_barrier != null && !nearest_barrier.is_unbreakable && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		camera_shake = pow(abs(barrier_delta) * camera_shake_strength, 2)

	prev_mouse_position = mouse_position
