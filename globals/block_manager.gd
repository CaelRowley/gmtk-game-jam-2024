extends Node

signal block_added(block: Block)

const BLOCKS = {
	"Block": [Vector2(0,0)],
	"IBlock": [Vector2(0,0), Vector2(0,-1)],
	"CBlock": [Vector2(0,0), Vector2(1,0), Vector2(0,1)]
}

var placed_blocks: Array[Block]
var current_block: Block


func _ready() -> void:
	var new_block := Block.new()
	new_block.init(BLOCKS.IBlock, Block.Type.WATER)
	current_block = new_block


func add_placed_block(new_block: Block) -> void:
	placed_blocks.push_back(new_block)
	block_added.emit(new_block)
