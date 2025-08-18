extends Panel

@onready var recipes_rg: ResourceGroup = preload("res://resource_groups/recipes.tres")
@onready var recipe_ui_scene: PackedScene = preload("res://scenes/ui/ui_crafting_menu/crafting_recipe.tscn")

@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer

var recipes_arr: Array[RRecipe]

func _compare_input_item_count(a: RRecipe, b:RRecipe) -> int:
	var count_a: int = a.input_items.size()
	var count_b: int = b.input_items.size()
	
	if count_a > count_a: return 1      # a is larger
	elif count_a < count_b: return -1   # b is larger
	else: return 0                      # equal

func _ready() -> void:
	recipes_rg.load_all_into(recipes_arr)
	recipes_arr.sort_custom(_compare_input_item_count)
	for recipe: RRecipe in recipes_arr:
		var recipe_ui: Control = recipe_ui_scene.instantiate()
		recipe_ui.recipe = recipe
		v_box_container.add_child(recipe_ui)
