extends AnimatedSprite2D
class_name NPC

var my_door: BlockDecor

func init(door: BlockDecor, target: BlockDecor):
	my_door = door
	var tween = create_tween()
	tween.tween_property(self, "global_position", target.global_position, 2.0)
	tween.tween_property(self, "global_position", my_door.global_position, 2.0)
	tween.tween_callback(despawn)

func despawn():
	queue_free()
