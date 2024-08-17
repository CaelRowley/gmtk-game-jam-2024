extends Node

signal block_added(block: Block)


var placed_blocks: Array[Block]
var current_block: Block


func _ready() -> void:
	var new_block := Block.new()
	new_block.init(weighted_block_shapes.IBlock.item.coords, Block.Type.WATER, weighted_block_shapes.IBlock.item.value)
	current_block = new_block


func add_placed_block(new_block: Block) -> void:
	placed_blocks.push_back(new_block)
	block_added.emit(new_block)


func get_random_block_shape() -> Dictionary:
	return Random.get_weighted_random(weighted_block_shapes, true)


func get_random_block_type() -> Block.Type:
	return Random.get_weighted_random(weighted_block_types, true)


func select_random_block():
	var new_block := Block.new()
	var ran_block_shape := get_random_block_shape()
	new_block.init(ran_block_shape.coords, get_random_block_type(), ran_block_shape.value)
	current_block = new_block


var weighted_block_types = {
	Block.Type.FOOD: {
		item = Block.Type.FOOD,
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	Block.Type.WATER: {
		item = Block.Type.WATER,
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	Block.Type.ELECTRICITY: {
		item = Block.Type.ELECTRICITY,
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	Block.Type.RESIDENTIAL: {
		item = Block.Type.RESIDENTIAL,
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	Block.Type.BUSINESS: {
		item = Block.Type.BUSINESS,
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	Block.Type.FRAME: {
		item = Block.Type.FRAME,
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}

var weighted_block_shapes = {
	"Block": {
		item = {
			"coords": [Vector2(0,0)],
			"value": 1,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1)],
			"value": 2,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock": {
		item = {
			"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}
