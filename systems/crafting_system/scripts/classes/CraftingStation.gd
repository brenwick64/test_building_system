class_name CraftingStation
extends PlaceableFurniture

# TODO: hack to avoid activation on placement (since the click is picked up)
# fix this by splitting up scenes into preview and actual scenes
var is_ready: bool = false

func _ready() -> void:
	super._ready()
	placement_area.mouse_entered.connect(_on_placement_area_mouse_entered)
	placement_area.mouse_exited.connect(_on_placement_area_mouse_exited)
	placement_area.input_event.connect(_on_placement_area_input_event)
	# TODO:
	var timer: Timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.autostart = true
	get_tree().root.add_child(timer)

func _are_hands_empty() -> bool:
	if not is_ready: return false
	var player_inventory: PlayerInventory = get_tree().get_first_node_in_group("player_inventory")
	if not player_inventory: return false
	if player_inventory.selected_item: return false
	return true

## -- signals --
func _on_placement_area_mouse_entered():
	if is_preview: return
	if not _are_hands_empty(): return
	focus()
	print("crafting station entered")

func _on_placement_area_mouse_exited():
	if is_preview: return
	if not _are_hands_empty(): return
	unfocus()
	print("crafting station exited")

func _on_placement_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if is_preview: return
	if not _are_hands_empty(): return
	if event.is_action_released("Action"):
		var crafting_manager: CraftingManager = get_tree().get_first_node_in_group("crafting_manager")
		if not crafting_manager: return
		crafting_manager.toggle_menu()

func _on_timer_timeout() -> void:
	is_ready = true
