class_name CraftingStation
extends PlaceableFurniture

@export var progress_bar: ProgressBar
@export var craft_timer: Timer
@export var interactable: Interactable

var is_crafting: bool = false

func _ready() -> void:
	super._ready()
	interactable.interacted.connect(_on_interactable_interacted)
	interactable.area_exited.connect(_on_interactable_exited)

## -- methods --
func craft(recipe: RRecipe) -> void:
	is_crafting = true
	_play_craft_animation(recipe)

## -- helper functions --
func _play_craft_animation(recipe: RRecipe) -> void:
	# initialize progress bar and timer
	craft_timer.wait_time = recipe.base_craft_time_seconds
	progress_bar.visible = true
	progress_bar.value = 0
	# configure tween 
	var tween: Tween = create_tween()
	tween.tween_property(progress_bar, "value", progress_bar.max_value,craft_timer.wait_time)
	# disconnect any old connections
	if craft_timer.timeout.is_connected(_on_craft_timer_timeout):
		craft_timer.timeout.disconnect(_on_craft_timer_timeout)
	# bind recipe as parameter and start timer
	craft_timer.timeout.connect(_on_craft_timer_timeout.bind(recipe))
	craft_timer.start()

func _spawn_craft_outputs(recipe: RRecipe) -> void:
	for inv_item: RInventoryItem in recipe.output_items:
		# TODO: use tile manager?
		var player: Player = get_tree().get_first_node_in_group("player")
		var item_pickup: Pickup = inv_item.item.pickup.new_pickup_scene(global_position, player.global_position)
		get_tree().root.add_child(item_pickup)

## -- signals --
func _on_craft_timer_timeout(recipe: RRecipe) -> void:
	_spawn_craft_outputs(recipe)
	progress_bar.visible = false
	is_crafting = false

func _on_interactable_interacted() -> void:
	if is_crafting: return
	var crafting_manager: CraftingManager = get_tree().get_first_node_in_group("crafting_manager")
	if not crafting_manager: return
	crafting_manager.toggle_ui(self)
	
func _on_interactable_exited(_area) -> void:
	var crafting_manager: CraftingManager = get_tree().get_first_node_in_group("crafting_manager")
	if not crafting_manager: return
	if crafting_manager.crafting_ui.visible == true:
		crafting_manager.toggle_ui(self)
