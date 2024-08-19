extends Camera2D
class_name CameraController

signal zoom_changed(level: int)

const camera_acceleration = 0.3
const camera_drag = 3
const barrier_drag = 12
const camera_shake_strength = 9;
const camera_shake_fade = 6;

var is_mouse_down = false
var prev_mouse_position = Vector2.ZERO;

var zoom_level: int = 1
var camera_y = 0;
var camera_velocity = 0;
var camera_shake = 0.0;
var barrier_break_timer = 0.0;

var barrier_manager: BarrierManager
var broken_barrier: Barrier
var is_broken_barrier_above

var audio_stream_1 := AudioStreamPlayer.new()
var audio_stream_2 := AudioStreamPlayer.new()

func _ready():
	add_child(audio_stream_1)
	add_child(audio_stream_2)
	for sibling in get_parent().get_children():
		if sibling is BarrierManager:
			barrier_manager = sibling
			break;
	for child in get_children():
		if child is BackgroundController:
			child.init(self)
			

func _input(event: InputEvent) -> void:
	# We don't want to listen to input during the barrier break animation
	if broken_barrier != null || event is not InputEventMouseButton:
		return 
	if !event.is_pressed():
		is_mouse_down = false
	elif BlockManager.current_block == null || event.get_button_index() == 2:
		is_mouse_down = true

func _process(delta: float):
	var barrier_overshoot = 0
	var nearest_barrier = null
	
	if broken_barrier != null:
		handle_barrier_transition(delta)
	else:	
		# Check if there's a barrier nearby and how close we are to it's edge
		nearest_barrier = barrier_manager.get_nearest_barrier(self)
		if nearest_barrier != null:
			barrier_overshoot = nearest_barrier.get_overshoot(self)
		handle_mouse_input(delta, barrier_overshoot)
		camera_velocity *= (1 - camera_drag * delta)
	
	# Modify the camera's velocity and set it's position
	camera_y += camera_velocity
	global_position.x = 0
	global_position.y = camera_y
	
	# If there's no nearby barrier, the barrier is unbreakable, or we're not holding Left Click
	# we're done. Otherwise we gotta handle the shaking and breaking behavior
	if nearest_barrier != null && !nearest_barrier.is_unbreakable && is_mouse_down:
		handle_camera_shake(delta, nearest_barrier, barrier_overshoot)
	else:
		set_rumble_sound_enabled(false)

func handle_mouse_input(delta: float, barrier_overshoot: float):	
	var mouse_position = get_local_mouse_position()
	# Handle the dragging of the camera when the mouse is held
	if is_mouse_down:
		var mouse_delta = prev_mouse_position - mouse_position
		mouse_delta *= (1 - min(abs(barrier_overshoot), 1))
		camera_velocity = mouse_delta.y
	elif barrier_overshoot != 0:
		camera_velocity *= (1 - barrier_drag * delta)
		camera_velocity += barrier_overshoot
	prev_mouse_position = mouse_position

func handle_camera_shake(delta: float, barrier: Barrier, barrier_overshoot: float):
	barrier_break_timer = 0.0 if abs(barrier_overshoot) < 0.8 else barrier_break_timer + delta
	if barrier_break_timer > (0.2 if barrier.has_been_broken else 1.0):
		break_barrier(barrier)
	if barrier.has_been_broken:
		return	
	set_rumble_sound_enabled(true)
	if(camera_shake > 1):
		global_position.x += randf_range(-camera_shake, camera_shake)
		global_position.y += randf_range(-camera_shake, camera_shake)
		var fade = pow(camera_shake_fade, 2) * max(1, abs(barrier_overshoot)) * delta
		camera_shake = lerpf(camera_shake, 0.0, fade)
	else:
		camera_shake = pow(abs(barrier_overshoot) * camera_shake_strength, 2)

func handle_barrier_transition(delta: float):
	var barrier_dir = broken_barrier.global_position.y - camera_y
	camera_velocity += barrier_dir * delta * 2.0
	if is_broken_barrier_above && camera_y < broken_barrier.global_position.y:
		broken_barrier = null
	if !is_broken_barrier_above && camera_y > broken_barrier.global_position.y:
		broken_barrier = null

func set_rumble_sound_enabled(flag: bool):
	if flag && !audio_stream_1.playing:
		audio_stream_1.stream = AudioManager.earthquake
		audio_stream_1.play()
		audio_stream_2.stream = AudioManager.rustle
		audio_stream_2.play()
	if !flag && audio_stream_1.stream == AudioManager.earthquake:
		audio_stream_1.stop()
		audio_stream_2.stop()
		

func break_barrier(barrier: Barrier):
	audio_stream_1.stop()
	audio_stream_2.stop()
	audio_stream_1.stream = AudioManager.burst_04 if barrier.has_been_broken else AudioManager.burst_01
	audio_stream_1.play()
	
	barrier.break_barrier()
	broken_barrier = barrier;
	is_broken_barrier_above = barrier.is_above(self)
	zoom_level = zoom_level + 1 if barrier.is_above(self) else zoom_level - 1
	zoom_changed.emit(zoom_level)
	is_mouse_down = false
	barrier_break_timer = 0
	barrier_manager.update_barriers()
	create_tween().tween_property(self, "zoom", Vector2(1.0/zoom_level, 1.0/zoom_level), 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
