extends Node

signal block_added(block: Block)


var placed_blocks: Array[Block]
var current_block: Block


func _ready() -> void:
	reset()


func reset() -> void:
	for i in [-4,-3,-2,-1,0,1,2,3]:
		var new_block := Block.new()
		new_block.init([Vector2(i, 2)], Block.Type.CLOUD_BUSTER, 0, true)
		BlockManager.add_placed_block(new_block)
	
	var ran_1_count := 1
	var ran_2_count := randi_range(2, 3)
	var ran_3_count := randi_range(3, 5)
	var ran_4_count := randi_range(15, 20)

	for i in ran_1_count:
		var new_block := Block.new()
		new_block.init([Vector2(randi_range(-4, 3), randi_range(-18, -30))], [Block.Type.FOOD, Block.Type.WATER, Block.Type.ELECTRICITY].pick_random(), 1)
		BlockManager.add_placed_block(new_block)
	
	for i in ran_2_count:
		var new_block := Block.new()
		var ran_block_shape := get_random_block_shape(1)
		var ran_offset := Vector2(randi_range(-6, 4), randi_range(-45, -85))
		var coords = []
		for cell in ran_block_shape.coords:
			coords.push_back(ran_offset + cell)
		new_block.init(coords, [Block.Type.FOOD, Block.Type.WATER, Block.Type.ELECTRICITY].pick_random(), 1)
		BlockManager.add_placed_block(new_block)

	for i in ran_3_count:
		var new_block := Block.new()
		var ran_block_shape := get_random_block_shape(1)
		var ran_offset := Vector2(randi_range(-8, 7), randi_range(-96, -150))
		var coords = []
		for cell in ran_block_shape.coords:
			coords.push_back(ran_offset + cell)
		new_block.init(coords, [Block.Type.FOOD, Block.Type.WATER, Block.Type.ELECTRICITY].pick_random(), 1)
		BlockManager.add_placed_block(new_block)
	
	for i in ran_4_count:
		var new_block := Block.new()
		var ran_block_shape := get_random_block_shape(2)
		var ran_offset := Vector2(randi_range(-8, 7), randi_range(-150, -600))
		var coords = []
		for cell in ran_block_shape.coords:
			coords.push_back(ran_offset + cell)
		new_block.init(coords, [Block.Type.FOOD, Block.Type.WATER, Block.Type.ELECTRICITY].pick_random(), 1)
		BlockManager.add_placed_block(new_block)


func add_placed_block(new_block: Block) -> void:
	placed_blocks.push_back(new_block)
	block_added.emit(new_block)


func get_random_block_shape(lvl := 1) -> Dictionary:
	match lvl:
		1:
			return Random.get_weighted_random(weighted_block_shapes_lvl1, true)
		2:
			return Random.get_weighted_random(weighted_block_shapes_lvl2, true)
		3:
			return Random.get_weighted_random(weighted_block_shapes_lvl3, true)
		4:
			return Random.get_weighted_random(weighted_block_shapes_lvl4, true)
	return Random.get_weighted_random(weighted_block_shapes_lvl4, true)


func get_random_block_type() -> Block.Type:
	return Random.get_weighted_random(weighted_block_types, true)


func get_random_block(lvl := 1) -> Block:
	var new_block := Block.new()
	var type := get_random_block_type()
	if type == Block.Type.FRAME:
		lvl = max(1, lvl-1)
	var ran_block_shape := get_random_block_shape(lvl)
	new_block.init(ran_block_shape.coords, type, ran_block_shape.value)
	return new_block


func set_block(type: Block.Type, shape) -> void:
	var new_block := Block.new()
	new_block.init(shape.coords, type, shape.value)
	set_current_block(new_block)


func select_random_block(lvl := 1):
	set_current_block(get_random_block(lvl))


func set_current_block(block: Block):
	current_block = block


func get_peak() -> int:
	var peak := 1000
	for block in placed_blocks:
		if block.is_placed_by_player:
			for coord in block.coords:
				if coord.y < peak:
					peak = coord.y
	return peak


func get_height() -> int:
	var peak := get_peak()
	var bot := peak
	for block in placed_blocks:
		if block.is_placed_by_player:
			for coord in block.coords:
				if coord.y > bot:
					bot = coord.y
	return bot - peak


func get_block_count() -> int:
	var count := 0
	for block in placed_blocks:
		if block.is_placed_by_player:
			count += block.coords.size()
	return count


func get_filled_rows_count() -> int:
	var count := 0
	var peak := get_peak()
	var current_height := 1
	while current_height > peak:
		var row := [Vector2(-2, current_height),Vector2(-1, current_height),Vector2(0, current_height),Vector2(1, current_height)]
		if current_height < -11:
			row = [Vector2(-4, current_height), Vector2(-3, current_height), Vector2(-2, current_height),Vector2(-1, current_height),Vector2(0, current_height),Vector2(1, current_height), Vector2(2, current_height), Vector2(3, current_height)]
		if current_height < -34:
			row = [Vector2(-6, current_height), Vector2(-5, current_height), Vector2(-4, current_height), Vector2(-3, current_height), Vector2(-2, current_height),Vector2(-1, current_height),Vector2(0, current_height),Vector2(1, current_height), Vector2(2, current_height), Vector2(3, current_height), Vector2(4, current_height), Vector2(5, current_height)]
		if current_height < -88:
			row = [Vector2(-8, current_height), Vector2(-7, current_height), Vector2(-6, current_height), Vector2(-5, current_height), Vector2(-4, current_height), Vector2(-3, current_height), Vector2(-2, current_height),Vector2(-1, current_height),Vector2(0, current_height),Vector2(1, current_height), Vector2(2, current_height), Vector2(3, current_height), Vector2(4, current_height), Vector2(5, current_height), Vector2(6, current_height), Vector2(7, current_height)]
		for block in placed_blocks:
			for coord in block.coords:
				row.erase(coord)
				if row.size() <= 0:
					count+=1
					break
			if row.size() <= 0:
				break
		current_height -= 1
	return count


func select_cloud_buster():
	var new_block := Block.new()
	new_block.init(cloud_buster_block, Block.Type.CLOUD_BUSTER, 0)
	current_block = new_block


var cloud_buster_block := [Vector2(0,0), Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,-3), Vector2(0,-4), Vector2(0,-5), Vector2(0,-6), Vector2(0,-7)]

var weighted_block_types = {
	Block.Type.FOOD: {
		item = Block.Type.FOOD,
		weight = 100,
		default_weight = 100,
		neg_accumulator = 0,
		pos_accumulator = 25,
	},
	Block.Type.WATER: {
		item = Block.Type.WATER,
		weight = 110,
		default_weight = 110,
		neg_accumulator = 0,
		pos_accumulator = 50,
	},
	Block.Type.ELECTRICITY: {
		item = Block.Type.ELECTRICITY,
		weight = 100,
		default_weight = 100,
		neg_accumulator = 0,
		pos_accumulator = 25,
	},
	Block.Type.RESIDENTIAL: {
		item = Block.Type.RESIDENTIAL,
		weight = 150,
		default_weight = 150,
		neg_accumulator = 75,
		pos_accumulator = 200,
	},
	Block.Type.BUSINESS: {
		item = Block.Type.BUSINESS,
		weight = 110,
		default_weight = 110,
		neg_accumulator = 0,
		pos_accumulator = 75,
	},
	Block.Type.FRAME: {
		item = Block.Type.FRAME,
		weight = 100,
		default_weight = 100,
		neg_accumulator = 100,
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
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}

var weighted_block_shapes_lvl2 = {
	"Block2": {
		item = {
			"coords": [Vector2(0,0)],
			"value": 1,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1)],
			"value": 2,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
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
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"StairBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1),  Vector2(-1,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"HBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigCBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(1,0), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,-2), Vector2(1,-2)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}

var weighted_block_shapes_lvl3 = {
	"Block2": {
		item = {
			"coords": [Vector2(0,0)],
			"value": 1,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1)],
			"value": 2,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,0)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"LBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock3": {
		item = {
			"coords": [Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"RecBlock3": {
		item = {
			"coords": [Vector2(-1,0),Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigLBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(0,-2), Vector2(1,0), Vector2(2,0)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigTBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(1,-1), Vector2(-1, -1), Vector2(0, 1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(1,0), Vector2(-1,0), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1), Vector2(0,1),Vector2(1,1), Vector2(-1,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"StairBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1),  Vector2(-1,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"HBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigCBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(1,0), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,-2), Vector2(1,-2)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
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
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SlantBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0), Vector2(-1,1), Vector2(-1,2), Vector2(-2,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock4": {
		item = {
			"coords": [Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(-1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}

var weighted_block_shapes_lvl4 = {
	"Block2": {
		item = {
			"coords": [Vector2(0,0)],
			"value": 1,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1)],
			"value": 2,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock2": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,0)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"LBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,1), Vector2(0,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock3": {
		item = {
			"coords": [Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"RecBlock3": {
		item = {
			"coords": [Vector2(-1,0),Vector2(-1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,0),Vector2(0,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigLBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(0,-2), Vector2(1,0), Vector2(2,0)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigTBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(0,-1), Vector2(1,-1), Vector2(-1, -1), Vector2(0, 1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock3": {
		item = {
			"coords": [Vector2(0,0),Vector2(1,0), Vector2(-1,0), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1), Vector2(0,1),Vector2(1,1), Vector2(-1,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"StairBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1),Vector2(1,-1), Vector2(-1,-1),  Vector2(-1,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"HBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"BigCBlock3": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(1,0), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,-2), Vector2(1,-2)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"IBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"CBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1), Vector2(1,-2), Vector2(1,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(1,0), Vector2(2,0), Vector2(1,1), Vector2(2,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"RecBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(1,0), Vector2(2,0), Vector2(1,-1), Vector2(2,-1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"AppleBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(-1,-1), Vector2(-1,0), Vector2(1,0), Vector2(-1,1), Vector2(1,-1), Vector2(0,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SqBlock4": {
		item = {
			"coords": [Vector2(-1,0), Vector2(-1,-1), Vector2(-1,1), Vector2(-1,2), Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(0,2), Vector2(1,0), Vector2(1,-1), Vector2(1,1), Vector2(1,2), Vector2(2, 0), Vector2(2,-1), Vector2(2,1), Vector2(2,2)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SlantBlock4": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0), Vector2(-1,1), Vector2(-1,2), Vector2(-2,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"TBlock4": {
		item = {
			"coords": [Vector2(0,-1), Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(-1,0), Vector2(1,1)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
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
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SQBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(0,-1), Vector2(0,-2), Vector2(0,1), Vector2(0,2), Vector2(-1,0), Vector2(-1,-1), Vector2(-1,-2), Vector2(-1,1), Vector2(-1,2), Vector2(-2,0), Vector2(-2,-1), Vector2(-2,-2), Vector2(-2,1), Vector2(-2,2), Vector2(1,0), Vector2(1,-1), Vector2(1,-2), Vector2(1,1), Vector2(1,2), Vector2(2,0), Vector2(2,-1), Vector2(2,-2), Vector2(2,1), Vector2(2,2)],
			"value": 3,
		},
		weight = 75,
		default_weight = 75,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
	"SpiralBlock5": {
		item = {
			"coords": [Vector2(0,0), Vector2(-1,0), Vector2(-2,0), Vector2(-2,1), Vector2(-2,2), Vector2(-2,3), Vector2(-1,3), Vector2(0,3), Vector2(1,3), Vector2(2,3), Vector2(2,2), Vector2(2,1), Vector2(2,0), Vector2(2,-1)],
			"value": 3,
		},
		weight = 50,
		default_weight = 50,
		neg_accumulator = 35,
		pos_accumulator = 25,
	},
}
