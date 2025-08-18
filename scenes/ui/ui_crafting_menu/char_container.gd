extends MarginContainer

@export var character: String

@onready var label: Label = $Label

func _ready() -> void:
	label.text = str(character)
