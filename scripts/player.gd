extends Node2D

@export var stats: Resource

@export var health_component : HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_ability_animation(skill_name : String) -> void:
		$AnimationPlayer.play("move_forward")
		$AnimationPlayer.queue("slash")
		$AnimationPlayer.queue("move_backward")
		$AnimationPlayer.queue("idle")

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	print(anim_name)
	pass # Replace with function body.
