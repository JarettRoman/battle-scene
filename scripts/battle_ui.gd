extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(skills: Array[Skill], player_health: int, enemy_health: int) -> void:
	for skill in skills:
		var skill_button = Button.new()
		skill_button.text = skill.skill_name
		# skill_button.pressed.connect(_on_skill_button_down.bind(skill))
		$UI/CommandBox.add_child(skill_button)

	$PlayerHP.text = str(player_health)
	$EnemyHP.text = str(enemy_health)

# func _on_skill_button_down(skill: Skill) -> void:
# 	$CommandBox.visible = false
# 	$InfoBox.text = "You use %s! Press Up Up Z!" % skill.skill_name
# 	capture_timed_input = true
# 	await get_tree().create_timer(2.0).timeout
# 	if timed_input_successful:
# 		player.play_ability_animation(skill.skill_name)
# 		var total_damage = player.stats.strength + skill.base_damage
# 		enemy.health_component.damage(total_damage)
# 		info_box.text = "You deal %s damage!" % total_damage
# 	else:
# 		info_box.text = "You missed!"
# 	successful_inputs = 0
# 	timed_input_successful = false
# 	current_state = STATES.EXECUTE