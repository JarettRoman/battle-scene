extends Node
class_name HealthComponent

signal health_depleted

@export var max_health : int

@onready var health : int = max_health:
	set = set_health

func _ready() -> void:
	health = max_health
	
func set_max_health(val:int) -> void:
	max_health = val
	
func set_health(val:int) -> void:
	health = max(0, val)
	if health == 0:
		health_depleted.emit()

func damage(damage : int) -> void:
	health = health - damage
