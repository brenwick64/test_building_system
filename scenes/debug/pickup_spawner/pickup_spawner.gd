extends Node2D

@export var disabled: bool = false
@export var items: Array[RItemData]
@export var spawn_radius: int = 10

func _ready() -> void:
	if disabled: return
	for item in items:
		for i in range(randi_range(1, 5)):
			var random_x: int = randi_range(-spawn_radius, spawn_radius)
			var random_y: int = randi_range(-spawn_radius, spawn_radius)
			var start_pos = global_position
			var end_pos = global_position + Vector2(random_x, random_y)
			var pickup_ins = item.pickup.new_pickup_scene(start_pos, end_pos)
			get_tree().root.call_deferred("add_child", pickup_ins)
			await get_tree().create_timer(0.25).timeout
