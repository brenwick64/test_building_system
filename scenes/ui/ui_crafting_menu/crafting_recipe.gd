extends HBoxContainer

@export var recipe: RRecipe

@onready var char_container_scene: PackedScene = preload("res://scenes/ui/ui_crafting_menu/char_container.tscn")
@onready var recipe_input_scene: PackedScene = preload("res://scenes/ui/ui_crafting_menu/recipe_input_item.tscn")
@onready var recipe_output_scene: PackedScene = preload("res://scenes/ui/ui_crafting_menu/recipe_output_item.tscn")

@onready var h_box_left: HBoxContainer = $HBoxLeft
@onready var h_box_right: HBoxContainer = $HBoxRight

func _get_char_container(character: String) -> Control:
	var char_container: Control = char_container_scene.instantiate()
	char_container.character = character
	return char_container

func _render_input_items(input_items: Array[RInventoryItem]) -> void:
	for i: int in input_items.size():
		var input_item: RInventoryItem = input_items[i]
		if i > 0: # add a "+" between items
			var char_container: Control = _get_char_container("+")
			h_box_left.add_child(char_container)
		var recipe_input: Control = recipe_input_scene.instantiate()
		recipe_input.texture = input_item.item.icon.texture
		recipe_input.amount = input_item.count
		h_box_left.add_child(recipe_input)

func _render_output_items(output_items: Array[RInventoryItem]) -> void:
	for output_item: RInventoryItem in output_items:
		var recipe_output: Control = recipe_output_scene.instantiate()
		recipe_output.texture = output_item.item.icon.texture
		h_box_right.add_child(recipe_output)

func _ready() -> void:
	_render_input_items(recipe.input_items)
	_render_output_items(recipe.output_items)
