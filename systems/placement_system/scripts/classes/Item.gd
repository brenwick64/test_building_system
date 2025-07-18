class_name Item
extends Node2D

@onready var pickup_wrapper: PackedScene = preload("res://systems/item_system/scenes/pickup/pickup.tscn")

@export var sprite_2d: Sprite2D

var item_id: String

## -- methods --
func set_preview() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)

func focus() -> void:
	var shader_material: ShaderMaterial = sprite_2d.material
	shader_material.set_shader_parameter("width", 0.55)  
	shader_material.set_shader_parameter("pattern", 1)
	
func unfocus() -> void:
	var shader_material: ShaderMaterial = sprite_2d.material
	shader_material.set_shader_parameter("width", 0)
	shader_material.set_shader_parameter("pattern", 1)

func remove(item_data: RItemData) -> void:
	_spawn_pickup(item_data)
	queue_free()

# -- helper functions --
func _spawn_pickup(item_data: RItemData) -> void:
	if not item_data:
		push_error("error: cant spawn item. no item found in DB for id: " + name)
		return
	var start_pos: Vector2 = global_position
	var end_pos: Vector2 = global_position + Vector2(25, 25)
	var pickup_ins: Node2D = item_data.new_pickup_scene(pickup_wrapper, start_pos, end_pos)
	get_tree().root.add_child(pickup_ins)
