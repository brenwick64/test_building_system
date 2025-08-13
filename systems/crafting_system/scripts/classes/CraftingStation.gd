class_name CraftingStation
extends PlaceableFurniture

@onready var shimmer_shader: Shader = preload("res://shaders/shimmer.gdshader")

@export var crafting_area: Area2D 

# TODO: hack to avoid activation on placement (since the click is picked up)
# fix this by splitting up scenes into preview and actual scenes
var placement_cooldown_flag: bool = false

func _ready() -> void:
	super._ready()
	crafting_area.mouse_entered.connect(_on_crafting_area_mouse_entered)
	crafting_area.mouse_exited.connect(_on_crafting_area_mouse_exited)
	crafting_area.input_event.connect(_on_crafting_area_input_event)
	# TODO:
	var timer: Timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.autostart = true
	get_tree().root.add_child(timer)

## -- helper functions --
func _are_hands_empty() -> bool:
	if not placement_cooldown_flag: return false
	var player_inventory: PlayerInventory = get_tree().get_first_node_in_group("player_inventory")
	if not player_inventory: return false
	if player_inventory.selected_item: return false
	return true

## -- signals --
func _on_crafting_area_mouse_entered():
	if not placement_cooldown_flag: return
	if not _are_hands_empty(): return
	show_outline()

func _on_crafting_area_mouse_exited():
	if not placement_cooldown_flag: return
	if not _are_hands_empty(): return
	hide_outline()

func _on_crafting_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not _are_hands_empty(): return
	if event.is_action_released("Action"):
		var crafting_manager: CraftingManager = get_tree().get_first_node_in_group("crafting_manager")
		if not crafting_manager: return
		crafting_manager.toggle_menu()

func _on_timer_timeout() -> void:
	placement_cooldown_flag = true
