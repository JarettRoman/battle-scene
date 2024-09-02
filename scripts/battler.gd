extends Node2D
class_name Battler

@export var stats: Resource

@export var health_component : HealthComponent

@onready var animation_player := $AnimationPlayer

@onready var state_machine := $StateMachine

@onready var sprite := $Sprite2D

var damage_number := preload("res://scenes/damage_number.tscn")

func _spawn_damage_number(damage: int) -> void:
	var number = damage_number.instantiate()
	number.text = str(damage)
	number.position = sprite.position
	add_child(number)

# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack(target: Battler, skill: Skill) -> void:
	pass