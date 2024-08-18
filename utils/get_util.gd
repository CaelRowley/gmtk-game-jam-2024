extends Node
class_name GetUtil

static func get_all_children(parent: Node, include_internal: bool = false) -> Array:
	var nodes = []
	for node in parent.get_children(include_internal):
		nodes.append(node)
		if node.get_child_count() > 0:
			nodes.append_array(get_all_children(node, include_internal))
	return nodes
