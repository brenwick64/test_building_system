class_name CraftingStation
extends PlaceableFurniture

@export var interactable: Interactable

func _ready() -> void:
	super._ready()
	interactable.interacted.connect(_on_interactable_interacted)
	#interactable.area_entered.connect(_on_interactable_entered)
	interactable.area_exited.connect(_on_interactable_exited)

func _on_interactable_interacted() -> void:
	var crafting_manager: CraftingManager = get_tree().get_first_node_in_group("crafting_manager")
	if not crafting_manager: return
	crafting_manager.toggle_ui()

#func _on_interactable_entered(_area) -> void:
	#show_outline()
	
func _on_interactable_exited(_areaw) -> void:
	#hide_outline()
	var crafting_manager: CraftingManager = get_tree().get_first_node_in_group("crafting_manager")
	if not crafting_manager: return
	if crafting_manager.crafting_ui.visible == true:
		crafting_manager.toggle_ui()
