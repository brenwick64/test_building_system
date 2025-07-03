class_name ItemManager
extends Node

##TODO:
#@onready var equipped_item: PackedScene = preload("res://scenes/furniture/large_table.tscn")
#
#@export var input_manager: InputManager
#@export var tile_manager: TileManager
#@export var furniture_manager: FurnitureManager
#
#var hovered_furniture: Furniture
#
#func _ready() -> void:
	#input_manager.action_pressed.connect(_on_action_pressed)
	#tile_manager.new_tile_hovered.connect(_on_new_tile_hovered)
	#tile_manager.layer_mouse_out.connect(_on_layer_mouse_out)
#
#func _on_new_tile_hovered(tile_coords: Vector2i) -> void:
	#if not equipped_item: return
	#var furniture: Furniture = furniture_manager.get_furniture_at_coords(tile_coords)
#
#func _on_action_pressed(_event: InputEvent) -> void:
	#if not equipped_item: return
	#pass
#
#func _on_layer_mouse_out() -> void:
	#pass
