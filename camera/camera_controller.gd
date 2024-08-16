extends Camera2D

const camera_acceleration = 0.3
const camera_drag = 0.05
const barrier_drag = 0.2

var prev_mouse_position = Vector2.ZERO;
var camera_y = 0;
var camera_velocity = 0;

func _ready():
	print("Ready!")

func _process(_delta: float):
	var bottom_barrier = 0
	var top_barrier = -1440
	var barrier_delta = 0
	if  camera_y > bottom_barrier:
		barrier_delta = (camera_y - bottom_barrier) * 0.01
	if  camera_y < top_barrier:
		barrier_delta = (top_barrier - camera_y) * 0.01

	var mouse_position = get_local_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_delta = prev_mouse_position - mouse_position
		mouse_delta *= (1 - min(barrier_delta, 1))
		camera_velocity = mouse_delta.y
	elif barrier_delta != 0:
		camera_velocity *= (1 - barrier_drag)
		if  camera_y > bottom_barrier: 
			camera_velocity -= barrier_delta
		if camera_y < top_barrier:
			camera_velocity += barrier_delta
	else:
		camera_velocity *= (1 - camera_drag)
	
	camera_y += camera_velocity
	
	
	global_position.x
	global_position.y = camera_y
	prev_mouse_position = mouse_position
