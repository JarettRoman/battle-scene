extends State
class_name EnemyState

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const ATTACKING = "Attacking"

var enemy : Battler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	enemy = owner as Battler
	assert(enemy != null, "The Battler state type must be used only in the enemy scene. It needs the owner to be a Battler node.")
