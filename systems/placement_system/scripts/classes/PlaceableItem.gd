class_name PlaceableItem
extends Node2D

@onready var pickup_wrapper: PackedScene = preload("res://systems/item_system/scenes/pickup/pickup.tscn")

@export var sprite_2d: Sprite2D

var is_preview: bool = false
var item_id: String

## -- methods --
func set_preview() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)
	is_preview = true

func show_outline() -> void:
	var shader_material: ShaderMaterial = sprite_2d.material
	shader_material.set_shader_parameter("width", 0.55)  
	shader_material.set_shader_parameter("pattern", 1)
	
func hide_outline() -> void:
	var shader_material: ShaderMaterial = sprite_2d.material
	shader_material.set_shader_parameter("width", 0)
	shader_material.set_shader_parameter("pattern", 1)

func remove() -> void:
	_spawn_pickup()
	queue_free()

# -- helper functions --
func _spawn_pickup() -> void:
	var end_pos: Vector2
	var item_data: RItemData = ItemsDB.get_item_data(item_id)
	if not item_data:
		push_error("error: cant spawn item. no item found in DB for id: " + name)
		return
	end_pos = global_position + Vector2(25, 25)
	var start_pos: Vector2 = global_position
	var pickup_ins: Node2D = item_data.pickup.new_pickup_scene(start_pos, end_pos)
	get_tree().root.add_child(pickup_ins)
