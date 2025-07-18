class_name Item
extends Node2D

var item_id: String

@export var sprite_2d: Sprite2D

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

func remove() -> void:
	_spawn_pickup()
	queue_free()

# -- helper functions --
func _spawn_pickup() -> void:
	pass
	#var item_data: RItemData = ItemDb.get_item(item_id)
	#if not item_data:
		#push_error("error: cant spawn item. no item found in DB for id: " + name)
		#return
	#var start_pos: Vector2 = global_position
	#var end_pos: Vector2 = global_position + Vector2(25, 25)
	#var pickup_ins: Node2D = item_data.new_pickup(start_pos, end_pos)
	#get_tree().root.add_child(pickup_ins)
