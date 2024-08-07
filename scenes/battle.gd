extends Node2D

@export var command_box : Control
@export var info_box: Label

@onready var player: Node2D = get_node("Player")
@onready var enemy: Node2D = get_node("Enemy")

@onready var player_hp_counter : Label = get_node("UI/PlayerHP")
@onready var enemy_hp_counter : Label = get_node("UI/EnemyHP")


var player_turn : bool = true

var battle_started: bool = false

enum STATES {
	START,
	AWAIT_INPUT,
	EXECUTE,
	END,
}

var current_state : STATES:
	get:
		return current_state
	set(state):
		print("firing ending funcs for: %s" % STATES.keys()[current_state])
		match state:
			STATES.START:
				on_start()
			STATES.AWAIT_INPUT:
				on_await_input()
			STATES.EXECUTE:
				on_execute()
			STATES.END:
				on_end()
		current_state = state
		print("firing beginning actions for state: %s" % STATES.keys()[state])
		# perform beginning actions for new, current_state

var execute_func : Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_hp_counter.text = str(player.stats.health)
	enemy_hp_counter.text = str(enemy.stats.health)
	current_state = STATES.START


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func on_start() -> void:
	if battle_started:
		info_box.text = "It's your turn." if player_turn else "It's the enemy's turn"
	else:
		info_box.text = "Starting battle..."
		battle_started = true
	
	await get_tree().create_timer(2.0).timeout
		
	current_state = STATES.AWAIT_INPUT
		


func on_await_input() -> void:
	if player_turn:
		command_box.visible = true
		info_box.text = "What will you do?"
	else:
		current_state = STATES.EXECUTE


func on_execute() -> void:
	command_box.visible = false
	if not player_turn:
		info_box.text = "The enemy attacks you!"
		player.stats.health -= enemy.stats.strength
	# wait for an animation to play out
	await get_tree().create_timer(3.0).timeout
	player_hp_counter.text = str(player.stats.health)
	enemy_hp_counter.text = str(enemy.stats.health)
	current_state = STATES.END


func on_end() -> void:
	info_box.text = "End of turn."
	await get_tree().create_timer(3.0).timeout
	player_turn = not player_turn
	print(player_turn)
	current_state = STATES.START


func _on_button_button_down() -> void:
	info_box.text = "Player attacks!"
	enemy.stats.health -= player.stats.strength
	current_state = STATES.EXECUTE


func _on_special_button_button_down() -> void:
	info_box.text = "Player performs a special attack!"
	enemy.stats.health -= player.stats.strength + 1
	current_state = STATES.EXECUTE
	
