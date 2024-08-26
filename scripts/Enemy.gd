extends Battler
class_name Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func attack(target: Battler, skill: Skill) -> void:
	# an actual skill isn't needed for now since this is an enemy doing basic attacks
	state_machine._transition_to_next_state(
	EnemyState.ATTACKING,
	{"target": target, "skill": skill}
)
