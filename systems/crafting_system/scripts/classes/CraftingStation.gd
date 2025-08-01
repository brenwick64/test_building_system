class_name CraftingStation
extends PlaceableFurniture

func _ready() -> void:
	super._ready()
	placement_area.mouse_entered.connect(_on_placement_area_mouse_entered)
	placement_area.mouse_exited.connect(_on_placement_area_mouse_exited)

func _on_placement_area_mouse_entered():
	if is_preview: return
	print("crafting entered")

func _on_placement_area_mouse_exited():
	if is_preview: return
	print("crafting exited")
