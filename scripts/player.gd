extends Node2D
class_name Player

@export var stats: Resource

@export var health_component : HealthComponent

@onready var animation_player := $AnimationPlayer

@onready var state_machine := $StateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack() -> void:
	state_machine._transition_to_next_state("Attack")

func play_ability_animation(skill_name : String) -> void:
		animation_player.play("move_forward")
		animation_player.queue("slash")
		animation_player.queue("move_backward")
		animation_player.queue("idle")

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	pass # Replace with function body.
