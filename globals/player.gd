extends Node

signal coins_changed()

@export var food := 0
@export var water := 0
@export var electricity := 0
@export var people := 0
@export var coins := 0

var lvl := 1
var score := 0


func update_coins(new_coins: int) -> void:
	coins = new_coins
	coins_changed.emit()


func update_score() -> void:
	var height := BlockManager.get_height()
	var block_count := BlockManager.get_block_count()
	var filled_rows := BlockManager.get_filled_rows_count()
	score = max(score, (block_count + people + coins) * (height + (lvl * (1+filled_rows))))
