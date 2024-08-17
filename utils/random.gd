class_name Random
extends Node


static func get_weighted_random(items: Dictionary, use_accumulator := false) -> Variant:
	var total_weight := 0
	for key in items.keys():
		total_weight += items[key].weight
	
	var random_num = randi() % total_weight
	
	var current_weight := 0
	var found_key: Variant
	
	if use_accumulator:
		for key in items.keys():
			current_weight += items[key].weight
			if random_num < current_weight && found_key == null:
				found_key = key
				items[key].weight = min(items[key].weight, items[key].default_weight)
				items[key].weight -= items[key].neg_accumulator
				items[key].weight = max(items[key].weight, 0)
			else:
				items[key].weight += items[key].pos_accumulator
	else:
		for key in items.keys():
			current_weight += items[key].weight
			if random_num < current_weight:
				found_key = key
				break

	return items[found_key].item
