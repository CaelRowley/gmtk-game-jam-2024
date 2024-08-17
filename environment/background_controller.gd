class_name BackgroundController
extends Sprite2D

const TILING_MULTIPLIER = 0.2;

var main_camera: CameraController
var sky_material: ShaderMaterial

func init(camera: CameraController):
	main_camera = camera
	sky_material = material

func _process(delta: float) -> void:
	var s =  (960 / main_camera.zoom.x) + 512;
	scale = Vector2(s,s)
	
	sky_material.set_shader_parameter("height", abs(main_camera.camera_y) / 10000)
	sky_material.set_shader_parameter("tiling", (1.0 / main_camera.zoom.x) * TILING_MULTIPLIER)
	
	print(scale)
