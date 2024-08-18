extends Node

@export var abilities : Array[Ability]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(abilities[0].ability_name)
	#print(ability.ability_name)
	#print(abilities[0].abi)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
