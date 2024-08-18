extends Sprite2D
class_name BlockDecor

var decor_type: BlockDecorTypes
var is_on: bool

func init(_position: Vector2, _decor_type: BlockDecorTypes):
	global_position = _position
	decor_type = _decor_type
	
func update(is_producing: bool):
	is_on = is_producing
	texture = decor_type.on_sprite if is_producing else decor_type.off_sprite
