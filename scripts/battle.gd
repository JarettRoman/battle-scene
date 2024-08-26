extends Node2D

@export var command_box: Control
@export var info_box: Label

@onready var player: Node2D = get_node("Player")
# @onready var first_enemy: Node2D = get_node("Enemy")

@onready var player_hp_counter: Label = get_node("UI/PlayerHP")
@onready var enemy_hp_counter: Label = get_node("UI/EnemyHP")

var next_enemy: PackedScene = preload("res://scenes/shadow.tscn")

var enemy: Battler = null

var player_turn: bool = true

var battle_started: bool = false

var capture_timed_input: bool = false

var timed_input_successful: bool = false

var attack_inputs: Array[String] = ["ui_up", "ui_up", "ui_accept"]

var successful_inputs: int = 0

var total_wins: int = 0

var skills: Array[Skill]

enum STATES {
	START,
	AWAIT_INPUT,
	EXECUTE,
	END,
	VICTORY,
	DEFEAT
}

var current_state: STATES:
	get:
		return current_state
	set(state):
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skills = GameManager.equipped_skills
	setup_opponent()

	player.state_machine.get_node("Attacking").hit_confirm.connect(_on_hit_confirm)
	for skill in skills:
		var skill_button = Button.new()
		skill_button.text = skill.skill_name
		skill_button.pressed.connect(_on_skill_button_down.bind(skill))
		$UI/CommandBox.add_child(skill_button)

	player_hp_counter.text = str(player.health_component.health)
	enemy_hp_counter.text = str(enemy.health_component.health)
	player.health_component.health_depleted.connect(_on_player_hp_deleted)
	$Player/AnimationPlayer.play("idle")
	current_state = STATES.START


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey and capture_timed_input and successful_inputs < attack_inputs.size() and event.is_action_pressed(attack_inputs[successful_inputs]):
		if event.pressed and not event.is_echo():
			successful_inputs += 1
			if successful_inputs == attack_inputs.size():
				timed_input_successful = true
	elif event is InputEventKey and capture_timed_input and successful_inputs < attack_inputs.size() and not event.is_action_pressed(attack_inputs[successful_inputs]):
		if event.pressed and not event.is_echo():
			successful_inputs = 0


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
		command_box.get_child(0).grab_focus()
		info_box.text = "What will you do?"
	else:
		current_state = STATES.EXECUTE


func on_execute() -> void:
	if not player_turn:
		command_box.visible = false
		info_box.text = "The enemy attacks you!"
		enemy.attack(player, null)
	# wait for an animation to play out
	await get_tree().create_timer(3.0).timeout
	capture_timed_input = false
	player_hp_counter.text = str(clamp(player.health_component.health, 0, 999))
	enemy_hp_counter.text = str(clamp(enemy.health_component.health, 0, 999))
	if enemy.health_component.health <= 0:
		current_state = STATES.VICTORY
		return
	elif player.health_component.health <= 0:
		current_state = STATES.DEFEAT
		return
	current_state = STATES.END


func on_end() -> void:
	info_box.text = "End of turn."
	await get_tree().create_timer(3.0).timeout
	player_turn = not player_turn
	current_state = STATES.START


func on_victory() -> void:
	info_box.text = "You win! Congratulations!"
	total_wins += 1
	battle_started = false
	enemy.queue_free()
	await get_tree().create_timer(2.0).timeout
	# GameManager.goto_main_menu()
	if true:
		setup_opponent()
		current_state = STATES.START
	else:
		info_box.text = "You beat all the enemies! Come back later!"
		await get_tree().create_timer(2.0).timeout
		GameManager.goto_main_menu()

func setup_opponent() -> void:
	enemy = next_enemy.instantiate()
	add_child(enemy)
	enemy.set_global_position(Vector2(400, 215))
	enemy_hp_counter.text = str(clamp(enemy.health_component.health, 0, 999))
	enemy.state_machine.get_node("Attacking").hit_confirm.connect(_on_hit_confirm)

func on_defeat() -> void:
	info_box.text = "You lost! Oh no!"
	await get_tree().create_timer(2.0).timeout
	GameManager.goto_main_menu()


func _on_skill_button_down(skill: Skill) -> void:
	command_box.visible = false
	info_box.text = "You use %s! Press Up Up Z!" % skill.skill_name
	capture_timed_input = true
	await get_tree().create_timer(2.0).timeout
	if timed_input_successful:
		player.attack(enemy, skill)
	else:
		info_box.text = "You missed!"
	successful_inputs = 0
	timed_input_successful = false
	current_state = STATES.EXECUTE

func _on_player_hp_deleted() -> void:
	print("player defeated signal")

func _on_hit_confirm(_skill_name: String, target: Battler, total_damage: int) -> void:
	target.health_component.damage(total_damage)
	info_box.text = "%s takes %d damage!" % [target.name, total_damage]
