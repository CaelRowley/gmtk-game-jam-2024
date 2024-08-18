extends Sprite2D
class_name BlockDecor

var on_sprite
var off_sprite

func init(_position: Vector2, _on_sprite: Texture2D, _off_sprite: Texture2D):
	global_position = _position
	on_sprite = _on_sprite
	off_sprite = _off_sprite
	
func update(is_producing: bool):
	texture = on_sprite if is_producing else off_sprite
