class_name CraftingStation
extends PlaceableFurniture

@export var ui_scene: PackedScene
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
		var target_pos: Vector2
		# check required systems / nodes
		var tile_manager: TileManager = get_tree().get_first_node_in_group("tile_manager") 
		if not tile_manager:
			push_error("crafting station " + str(name) + " error: no tile manager found")
			return
		var player: Player = get_tree().get_first_node_in_group("player")
		if not player:
			push_error("crafting station " + str(name) + " error: no player node found")
			return
			
		var available_tiles: Array[Vector2i] = tile_manager.get_navigatable_neighboring_tiles(occupied_tiles)
		if not available_tiles:
			target_pos = global_position
		else:
			var closest_tiles: Array[Vector2i] = tile_manager.sort_closest_tiles(available_tiles, player.global_position)
			target_pos = tile_manager.get_global_pos_from_tile(closest_tiles[0])
			
		var item_pickup: Pickup = inv_item.item.pickup.new_pickup_scene(global_position, target_pos)
		get_tree().root.add_child(item_pickup)

## -- signals --
func _on_craft_timer_timeout(recipe: RRecipe) -> void:
	_spawn_craft_outputs(recipe)
	progress_bar.visible = false
	is_crafting = false

func _on_interactable_interacted() -> void:
	var crafting_manager: CraftingManager = get_tree().get_first_node_in_group("crafting_manager")
	if not crafting_manager: return
	crafting_manager.toggle_ui(self)
	
func _on_interactable_exited(_area) -> void:
	var crafting_manager: CraftingManager = get_tree().get_first_node_in_group("crafting_manager")
	if not crafting_manager: return
	if crafting_manager.current_crafting_ui and crafting_manager.current_crafting_ui.visible == true:
		crafting_manager.remove_ui(self)
	 
