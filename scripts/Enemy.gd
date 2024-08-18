extends Node2D

@export var stats: Resource

@export var health_component: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stats:
		print(stats.health)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
