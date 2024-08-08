extends Node2D

@export var command_box : Control
@export var info_box: Label

@onready var player: Node2D = get_node("Player")
@onready var enemy: Node2D = get_node("Enemy")

@onready var player_hp_counter : Label = get_node("UI/PlayerHP")
@onready var enemy_hp_counter : Label = get_node("UI/EnemyHP")


var player_turn: bool = true

var battle_started: bool = false

var capture_timed_input: bool = false

var timed_input_successful: bool = false

enum STATES {
	START,
	AWAIT_INPUT,
	EXECUTE,
	END,
	VICTORY,
	DEFEAT
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
			STATES.VICTORY:
				on_victory()
			STATES.DEFEAT:
				on_defeat()
		current_state = state
		print("firing beginning actions for state: %s" % STATES.keys()[state])


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_hp_counter.text = str(player.stats.health)
	enemy_hp_counter.text = str(enemy.stats.health)
	current_state = STATES.START


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and capture_timed_input:
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		print(keycode)
		print(OS.get_keycode_string(keycode))
		if keycode == 70:
			print("success")
			timed_input_successful = true
		else:
			print("fail")
			timed_input_successful = false
		capture_timed_input = false

func on_start() -> void:
	if battle_started:
		current_state = STATES.AWAIT_INPUT
		return
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
	if not player_turn:
		command_box.visible = false
		info_box.text = "The enemy attacks you!"
		player.stats.health -= enemy.stats.strength
	# wait for an animation to play out
	await get_tree().create_timer(3.0).timeout
	#capture_timed_input = false
	player_hp_counter.text = str(clamp(player.stats.health, 0, 999))
	enemy_hp_counter.text = str(clamp(enemy.stats.health, 0, 999))
	if enemy.stats.health <= 0:
		current_state = STATES.VICTORY
		return
	elif player.stats.health <= 0:
		current_state = STATES.DEFEAT
		return
	current_state = STATES.END


func on_end() -> void:
	info_box.text = "End of turn."
	await get_tree().create_timer(3.0).timeout
	player_turn = not player_turn
	print(player_turn)
	current_state = STATES.START


func on_victory() -> void:
	info_box.text = "You win! Congratulations!"


func on_defeat() -> void:
	info_box.text = "You lost! Oh no!"


func _on_button_button_down() -> void:
	command_box.visible = false
	info_box.text = "Player attacks! Press F!"
	capture_timed_input = true
	await get_tree().create_timer(2.0).timeout
	enemy.stats.health -= player.stats.strength if timed_input_successful else 0
	timed_input_successful = false
	current_state = STATES.EXECUTE


func _on_special_button_button_down() -> void:
	command_box.visible = false
	info_box.text = "Player performs a special attack! Press F!"
	capture_timed_input = true
	await get_tree().create_timer(2.0).timeout
	enemy.stats.health -= player.stats.strength + 1 if timed_input_successful else 0
	timed_input_successful = false
	current_state = STATES.EXECUTE
	
