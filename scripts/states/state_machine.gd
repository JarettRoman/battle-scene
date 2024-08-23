extends Node
class_name StateMachine

@export var initial_state : State = null


@onready var state: State = ( 
	func get_initial_state() -> State: 
	return initial_state if initial_state != null else get_child(0)
	).call()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	await owner.ready
	state.enter("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(
			"%s: Trying to transition to state %s but it does not exist" 
			% [owner.name, target_state_path]
		)

	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
