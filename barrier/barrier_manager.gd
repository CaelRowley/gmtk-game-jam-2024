class_name BarrierManager
extends Node2D

var barriers = []

func _ready() -> void:
	for child in get_children():
		if child is Barrier:
			barriers.append(child)
	print("found " + str(barriers.size()) + " configured barriers")
			
func get_nearest_barrier(camera_y: float):
	var nearest_barrier
	var nearest_dis = 2147483647
	for barrier in barriers:
		var dis = abs(barrier.global_position.y - camera_y)
		if dis < nearest_dis:
			nearest_barrier = barrier
			nearest_dis = dis
	
	if nearest_dis > nearest_barrier.width:
		return null		
	print("nearest barrier at a dis of " + str(nearest_dis))
	return nearest_barrier
