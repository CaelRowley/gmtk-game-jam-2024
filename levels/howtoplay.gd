extends Control

var simultaneous_scene = preload("res://levels/mainmenu.tscn").instantiate()

@onready var page_1 = $MarginContainer/Page1
@onready var page_2 = $MarginContainer/Page2
@onready var page_3 = $MarginContainer/Page3
@onready var page_4 = $MarginContainer/Page4
@onready var page_5 = $MarginContainer/Page5
@onready var page_6 = $MarginContainer/Page6
@onready var page_7 = $MarginContainer/Page7
@onready var page_8 = $MarginContainer/Page8
@onready var page_9 = $MarginContainer/Page9

func _on_page_1_return_pressed() -> void:
	page_1.visible = false
	get_tree().root.add_child(simultaneous_scene)


func _on_page_1_forward_pressed() -> void:
	page_1.visible = false
	page_2.visible = true


func _on_page_2_return_pressed() -> void:
	page_2.visible = false
	page_1.visible = true

func _on_page_2_forward_pressed() -> void:
	page_2.visible = false
	page_3.visible = true


func _on_page_3_return_pressed() -> void:
	page_3.visible = false
	page_2.visible = true


func _on_page_3_forward_pressed() -> void:
	page_3.visible = false
	page_4.visible = true


func _on_page_4_return_pressed() -> void:
	page_4.visible = false
	page_3.visible = true


func _on_page_4_forward_pressed() -> void:
	page_4.visible = false
	page_5.visible = true


func _on_page_5_return_pressed() -> void:
	page_5.visible = false
	page_4.visible = true


func _on_page_5_forward_pressed() -> void:
	page_5.visible = false
	page_6.visible = true


func _on_page_6_return_pressed() -> void:
	page_6.visible = false
	page_5.visible = true


func _on_page_6_forward_pressed() -> void:
	page_6.visible = false
	page_7.visible = true


func _on_page_7_return_pressed() -> void:
	page_7.visible = false
	page_6.visible = true


func _on_page_7_forward_pressed() -> void:
	page_7.visible = false
	page_8.visible = true


func _on_page_8_return_pressed() -> void:
	page_8.visible = false
	page_7.visible = true


func _on_page_8_forward_pressed() -> void:
	page_8.visible = false
	page_9.visible = true


func _on_page_9_return_pressed() -> void:
	page_9.visible = false
	page_8.visible = true


func _on_page_9_forward_pressed() -> void:
	page_9.visible = false
	get_tree().root.add_child(simultaneous_scene)
