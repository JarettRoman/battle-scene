extends Node2D

@export var command_box: Control
@export var info_box: Label
@export var health_bar_scene: PackedScene

@onready var player: Node2D = get_node("Player")
@onready var player_health_bar: HealthBar = $UI/PlayerHealthBar

var enemy_health_bar: HealthBar
var enemy: Battler = null
var next_enemy: PackedScene = preload("res://scenes/shadow.tscn")

var player_turn: bool = true
var battle_started: bool = false
var capture_timed_input: bool = false
var timed_input_successful: bool = false
var attack_inputs: Array[String] = ["ui_up", "ui_up", "ui_accept"]
var successful_inputs: int = 0
var total_wins: int = 0
var skills: Array[Skill]
var acting_skill: Skill

enum STATES { START, AWAIT_INPUT, EXECUTE, END, VICTORY, DEFEAT }

var current_state: STATES = STATES.START:
    get: return current_state
    set(new_state):
        if current_state != new_state:
            _on_state_exit(current_state)
            _on_state_enter(new_state)
            current_state = new_state

func _ready() -> void:
    skills = GameManager.equipped_skills
    setup_opponent()
    player.state_machine.get_node("Attacking").hit_confirm.connect(_on_hit_confirm)
    
    for skill in skills:
        var skill_button = Button.new()
        skill_button.text = skill.skill_name
        skill_button.pressed.connect(_on_skill_button_down.bind(skill))
        $UI/CommandBox.add_child(skill_button)

    player_health_bar.init_health_bar(player.health_component.health)
    enemy_health_bar.init_health_bar(enemy.health_component.health, true)
    player.health_component.health_depleted.connect(_on_player_hp_deleted)
    $Player/AnimationPlayer.play("idle")
    _on_state_enter(STATES.START)

func _input(event: InputEvent) -> void:
    if not (event is InputEventKey and capture_timed_input):
        return
    if event.is_echo() or not event.pressed:
        return
    var result = event.is_action_pressed("ui_accept")
    player.stop_timed_input(result)

func on_start() -> void:
    if battle_started:
        current_state = STATES.AWAIT_INPUT
        return
    
    var adjectives = ["ferocious", "dangerous", "savage", "fierce", "formidable", "terrifying", "scary"]
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
    command_box.visible = false
    var attacker: Battler
    var defender: Battler
    var skill: Skill

    if player_turn:
        attacker = player
        defender = enemy
        skill = acting_skill
        info_box.text = "You use %s!" % skill.skill_name
    else:
        attacker = enemy
        defender = player
        skill = null
        info_box.text = "The enemy attacks you!"

    attacker.attack(defender, skill)
    await SignalBus.attack_finished
    
    capture_timed_input = false
    
    if defender.health_component.health <= 0:
        current_state = STATES.VICTORY if player_turn else STATES.DEFEAT
    else:
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

func on_defeat() -> void:
    info_box.text = "You lost! Oh no!"
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

func _on_skill_button_down(skill: Skill) -> void:
    command_box.visible = false
    capture_timed_input = true
    acting_skill = skill
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

func _on_state_exit(old_state: STATES) -> void:
    match old_state:
        STATES.START: pass
        STATES.AWAIT_INPUT: pass
        STATES.EXECUTE: pass
        STATES.END: pass
        STATES.VICTORY: pass
        STATES.DEFEAT: pass

func _on_state_enter(new_state: STATES) -> void:
    match new_state:
        STATES.START: on_start()
        STATES.AWAIT_INPUT: on_await_input()
        STATES.EXECUTE: on_execute()
        STATES.END: on_end()
        STATES.VICTORY: on_victory()
        STATES.DEFEAT: on_defeat()
