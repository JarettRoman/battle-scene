extends Node

class_name Ability

@export var ability_name : String
@export var base_damage : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not ability_name:
		ability_name = name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
