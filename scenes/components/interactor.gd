class_name Interactor
extends Area2D

signal interactables_updated(interactables: Array[Interactable])

var nearby_interactables: Array[Interactable]

## -- methods --
func interact() -> void:
	if nearby_interactables.size() > 0:
		nearby_interactables[0].interact()

## -- signals --
func _on_area_entered(area: Area2D) -> void:
	if area is not Interactable: return
	if area not in nearby_interactables:
		nearby_interactables.append(area)
	interactables_updated.emit(nearby_interactables)

func _on_area_exited(area: Area2D) -> void:
	if area is not Interactable: return
	if area in nearby_interactables:
		area.get_parent().hide_outline()
		nearby_interactables = nearby_interactables.filter(func(i: Interactable): return i != area)
	interactables_updated.emit(nearby_interactables)

## -- helper functions --
func _get_player_distance_to_area(area: Area2D) -> float:
	var player_gp: Vector2 = get_parent().global_position
	var shape_node: CollisionShape2D = area.get_node("CollisionShape2D")
	return player_gp.distance_to(shape_node.global_position)

func _get_closest_interactable() -> Interactable:
	if nearby_interactables.size() == 0: return null
	var closest: Interactable = nearby_interactables[0]
	for interactable: Interactable in nearby_interactables:
		var closest_distance: float = _get_player_distance_to_area(closest)
		var new_distance: float = _get_player_distance_to_area(interactable)
		if new_distance < closest_distance:
			closest = interactable
	return closest

func _on_player_player_moved() -> void:
	var closest_interactable: Interactable = _get_closest_interactable()
	if not closest_interactable: return
	for interactable: Interactable in nearby_interactables:
		if interactable == closest_interactable:
			interactable.get_parent().show_outline()
		else:
			interactable.get_parent().hide_outline()
