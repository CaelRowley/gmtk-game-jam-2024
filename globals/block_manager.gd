extends Node

signal block_added(block: Block)

const BLOCKS = {
	"Block": {
		"coords": [Vector2(0,0)],
		"value": 1,
	},
	"IBlock": {
		"coords": [Vector2(0,0), Vector2(0,-1)],
		"value": 2,
	},
	"CBlock": {
		"coords": [Vector2(0,0), Vector2(1,0), Vector2(0,1)],
		"value": 3,
	},
}

var placed_blocks: Array[Block]
var current_block: Block


func _ready() -> void:
	var new_block := Block.new()
	new_block.init(BLOCKS.IBlock.coords, Block.Type.WATER, BLOCKS.IBlock.value)
	current_block = new_block


func add_placed_block(new_block: Block) -> void:
	placed_blocks.push_back(new_block)
	block_added.emit(new_block)
