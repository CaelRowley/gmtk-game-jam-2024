extends Node

@export var food := 0
@export var water := 0
@export var electricity := 0
@export var people := 0
@export var coins := 0

var score := 0


func update_score(max_zoom_lvl := 1) -> void:
	var height := BlockManager.get_height()
	var block_count := BlockManager.get_block_count()
	var filled_rows := BlockManager.get_filled_rows_count()
	print("filled_rows")
	print(BlockManager.get_filled_rows_count())
	score = (block_count + food + water + electricity + people + coins) * (height + (max_zoom_lvl * (1+filled_rows)))
