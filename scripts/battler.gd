extends Node2D
class_name Battler

@export var stats: Resource

@export var health_component : HealthComponent

@onready var animation_player := $AnimationPlayer

@onready var state_machine := $StateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack(target: Battler, skill: Skill) -> void:
	pass