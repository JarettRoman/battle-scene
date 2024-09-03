extends Node2D

@export var command_box: Control
@export var info_box: Label

@onready var player: Node2D = get_node("Player")
# @onready var first_enemy: Node2D = get_node("Enemy")

@onready var player_health_bar: HealthBar = $UI/PlayerHealthBar
@export var health_bar_scene: PackedScene

var enemy_health_bar: HealthBar

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
	SignalBus.attack_finished.connect(_on_attack_finished)
	for skill in skills:
		var skill_button = Button.new()
		skill_button.text = skill.skill_name
		skill_button.pressed.connect(_on_skill_button_down.bind(skill))
		$UI/CommandBox.add_child(skill_button)

	player_health_bar.init_health_bar(player.health_component.health)
	enemy_health_bar.init_health_bar(enemy.health_component.health, true)
	player.health_component.health_depleted.connect(_on_player_hp_deleted)
	$Player/AnimationPlayer.play("idle")
	current_state = STATES.START


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and capture_timed_input):
		return

	if event.is_echo() or not event.pressed:
		return

	var result = event.is_action_pressed("ui_accept")

	player.stop_timed_input(result)


func on_start() -> void:
	var adjectives = ["untamed", "ferocious", "dangerous", "savage", "fierce", "formidable", "terrifying", "scary", "scary-ass"]
	if battle_started:
		current_state = STATES.AWAIT_INPUT
		return
	else:
		info_box.text = "You've encountered a %s %s!" % [adjectives[randi_range(0, adjectives.size() - 1)], enemy.name]
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
	await get_tree().create_timer(1.0).timeout
	capture_timed_input = false
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
	if true:
		setup_opponent()
		current_state = STATES.START
	else:
		info_box.text = "You beat all the enemies! Come back later!"
		await get_tree().create_timer(2.0).timeout
		GameManager.goto_main_menu()

func setup_opponent() -> void:
	if is_instance_valid(enemy):
		enemy.queue_free()
	if is_instance_valid(enemy_health_bar):
		enemy_health_bar.queue_free()
	enemy = next_enemy.instantiate()
	add_child(enemy)
	enemy.set_global_position(Vector2(400, 215))
	enemy.state_machine.get_node("Attacking").hit_confirm.connect(_on_hit_confirm)
	enemy_health_bar = health_bar_scene.instantiate()
	$UI.add_child(enemy_health_bar)
	enemy_health_bar.set_global_position(Vector2(384, 56))
	enemy_health_bar.set_size(Vector2(168, 8))
	enemy_health_bar.init_health_bar(enemy.health_component.health, true)

func on_defeat() -> void:
	info_box.text = "You lost! Oh no!"
	await get_tree().create_timer(2.0).timeout
	GameManager.goto_main_menu()


func _on_skill_button_down(skill: Skill) -> void:
	command_box.visible = false
	info_box.text = "You use %s!" % skill.skill_name
	capture_timed_input = true
	player.attack(enemy, skill)


func _on_attack_finished() -> void:
	current_state = STATES.EXECUTE

func _on_player_hp_deleted() -> void:
	print("player defeated signal")

func _on_hit_confirm(_skill_name: String, target: Battler, total_damage: int) -> void:
	target.health_component.damage(total_damage)
	target._spawn_damage_number(total_damage)
	if target == player:
		player_health_bar.health = player.health_component.health
	else:
		enemy.take_damage()
		if is_instance_valid(enemy_health_bar):
			enemy_health_bar.health = enemy.health_component.health
