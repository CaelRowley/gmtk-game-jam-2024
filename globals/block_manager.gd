extends Node

signal block_added(block: Block)


var placed_blocks: Array[Block]
var current_block: Block


func _ready() -> void:
	pass
	var new_block := Block.new()
	new_block.init(weighted_block_shapes_lvl1.IBlock2.item.coords, Block.Type.WATER, weighted_block_shapes_lvl1.IBlock2.item.value)
	current_block = new_block


func add_placed_block(new_block: Block) -> void:
	placed_blocks.push_back(new_block)
	block_added.emit(new_block)


func get_random_block_shape() -> Dictionary:
	return Random.get_weighted_random(weighted_block_shapes_lvl1, true)


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

var weighted_block_shapes_lvl1 = {
	"Block2": {
		item = {
			"coords": [Vector2(0,0)],
			"value": 1,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1)],
			"value": 2,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}

var weighted_block_shapes_lvl_2 = {
	"Block2": {
		item = {
			"coords": [Vector2(0,0)],
			"value": 1,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1)],
			"value": 2,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,0)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"LBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock3": {
		item = {
			"coords": [Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"RecBlock3": {
		item = {
			"coords": [Vector2(-1,0),Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigLBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(0,-2), Vector2(1,0), Vector2(2,0)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigTBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(1,-1), Vector2(-1, -1), Vector2(0, 1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(1,0), Vector2(-1,0), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1), Vector2(0,1),Vector2(1,1), Vector2(-1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"StairBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1),  Vector2(-1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"HBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigCBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(1,0), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,-2), Vector2(1,-2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}

var weighted_block_shapes_lvl_3 = {
	"Block2": {
		item = {
			"coords": [Vector2(0,0)],
			"value": 1,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1)],
			"value": 2,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,0)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"LBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock3": {
		item = {
			"coords": [Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"RecBlock3": {
		item = {
			"coords": [Vector2(-1,0),Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigLBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(0,-2), Vector2(1,0), Vector2(2,0)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigTBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(1,-1), Vector2(-1, -1), Vector2(0, 1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(1,0), Vector2(-1,0), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1), Vector2(0,1),Vector2(1,1), Vector2(-1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"StairBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1),  Vector2(-1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"HBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigCBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(1,0), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,-2), Vector2(1,-2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1), Vector2(1,-2), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(1,0), Vector2(2,0), Vector2(1,1), Vector2(2,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"RecBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(1,0), Vector2(2,0), Vector2(1,-1), Vector2(2,-1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"AppleBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(1,0), Vector2(-1,1), Vector2(1,-1), Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock4": {
		item = {
			"coords": [Vector2(-1,0), Vector2(-1,-1), Vector2(-1,1), Vector2(-1,2), Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(0,2), Vector2(1,0), Vector2(1,-1), Vector2(1,1), Vector2(1,2), Vector2(2, 0), Vector2(2,-1), Vector2(2,1), Vector2(2,2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SlantBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0), Vector2(-1,1), Vector2(-1,2), Vector2(-2,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock4": {
		item = {
			"coords": [Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(-1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}

var weighted_block_shapes_lvl_4 = {
	"Block2": {
		item = {
			"coords": [Vector2(0,0)],
			"value": 1,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1)],
			"value": 2,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,0)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"LBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock3": {
		item = {
			"coords": [Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"RecBlock3": {
		item = {
			"coords": [Vector2(-1,0),Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigLBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(0,-2), Vector2(1,0), Vector2(2,0)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigTBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(1,-1), Vector2(-1, -1), Vector2(0, 1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(1,0), Vector2(-1,0), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1), Vector2(0,1),Vector2(1,1), Vector2(-1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"StairBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1),  Vector2(-1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"HBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigCBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(1,0), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,-2), Vector2(1,-2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1), Vector2(1,-2), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(1,0), Vector2(2,0), Vector2(1,1), Vector2(2,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"RecBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(1,0), Vector2(2,0), Vector2(1,-1), Vector2(2,-1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"AppleBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(1,0), Vector2(-1,1), Vector2(1,-1), Vector2(0,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock4": {
		item = {
			"coords": [Vector2(-1,0), Vector2(-1,-1), Vector2(-1,1), Vector2(-1,2), Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(0,2), Vector2(1,0), Vector2(1,-1), Vector2(1,1), Vector2(1,2), Vector2(2, 0), Vector2(2,-1), Vector2(2,1), Vector2(2,2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SlantBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0), Vector2(-1,1), Vector2(-1,2), Vector2(-2,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock4": {
		item = {
			"coords": [Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(-1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1), Vector2(0,2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"LBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1), Vector2(2,0), Vector2(2,1), Vector2(-1,0), Vector2(-1,1), Vector2(-2,0), Vector2(-2,1), Vector2(-2,-1), Vector2(-1,-1), Vector2(-2,-2), Vector2(-1,-2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"JBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(1,0), Vector2(1,-1), Vector2(2,0), Vector2(2,-1), Vector2(-1,0), Vector2(-1,-1), Vector2(-2,0), Vector2(-2,-1), Vector2(1,-1), Vector2(2,-1), Vector2(-1,-2), Vector2(-2,-2), Vector2(-1,-3), Vector2(-2,-3), Vector2(1,-2), Vector2(2,-2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(0,-2), Vector2(0,-3), Vector2(1,0), Vector2(1,1), Vector2(1,-1), Vector2(1,-2), Vector2(1,-3), Vector2(-1,0), Vector2(-2,0),  Vector2(-1,1), Vector2(-2,1), Vector2(2,0), Vector2(2,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"UBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(0,-2), Vector2(0,-3), Vector2(1,0), Vector2(1,1), Vector2(1,-1), Vector2(1,-2), Vector2(1,-3), Vector2(-3,0), Vector2(-3,1), Vector2(-3,-1), Vector2(-3,-2), Vector2(-3,-3), Vector2(-1,1), Vector2(-2,1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"ChonkBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1), Vector2(0,2), Vector2(-1,0), Vector2(-1,-1), Vector2(-1,1), Vector2(-1,2), Vector2(-2,0), Vector2(-2,-1), Vector2(-2,1), Vector2(-2,2), Vector2(1,2), Vector2(2,2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SQBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1), Vector2(0,2), Vector2(-1,0), Vector2(-1,-1), Vector2(-1,-2), Vector2(-1,1), Vector2(-1,2), Vector2(-2,0), Vector2(-2,-1), Vector2(-2,-2), Vector2(-2,1), Vector2(-2,2), Vector2(1,0), Vector2(1,-1), Vector2(1,-2), Vector2(1,1), Vector2(1,2), Vector2(2,0), Vector2(2,-1), Vector2(2,-2), Vector2(2,1), Vector2(2,2)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SpiralBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(-2,0), Vector2(-2,1), Vector2(-2,2), Vector2(-2,3), Vector2(-1,3), Vector2(0,3), Vector2(1,3), Vector2(2,3), Vector2(2,2), Vector2(2,1), Vector2(2,0), Vector2(2,-1)],
			"value": 3,
		},
		weight = 100,
		default_weight = 100,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}
