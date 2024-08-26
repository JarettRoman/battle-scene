extends Battler
class_name Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func attack(target: Battler, skill: Skill) -> void:
	state_machine._transition_to_next_state(
		PlayerState.ATTACKING,
		{"target": target, "skill": skill}
	)
