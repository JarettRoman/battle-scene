extends PlayerStateBase

var target: Battler
var skill: Skill
var tween: Tween

var attack_animations = ["slash_1", "slash_2", "slash_3"]
var attack_index : int

signal hit_confirm(skill_name: String, target: Battler, total_damage: int)

func enter(_previous_state_path: String, data := {}) -> void:
	target = data["target"]
	skill = data["skill"]
	attack_index = 0
	# SignalBus.attack_finished.connect(player.attack_finished)
	# if melee attack, we run
	# if ranged attack, we shoot
	print(skill.attack_type)
	if skill.attack_type == "Melee":
		player.animation_player.play("run")
		animate()
		tween.tween_property(player.get_node("Sprite2D"), "position", Vector2(150,0), 0.5)
		tween.tween_callback(foo)
	elif skill.attack_type == "Ranged":
		if skill.skill_name == "Thunder":
			player.animation_player.play("sora_magic_1")
		

func foo() -> void:
	player.animation_player.play("slash_1")
	player.animation_player.queue("slash_2")
	player.animation_player.queue("slash_3")

func _on_end_of_attack_animation() -> void:
	attack_index += 1
	if skill.attack_type == "Melee" and attack_index < attack_animations.size():	
		player.animation_player.play(attack_animations[attack_index])
	else:
		if skill.attack_type == "Melee":
			player.get_node("Sprite2D").flip_h = false
			player.animation_player.play("run")	
			animate()
			tween.tween_property(player.get_node("Sprite2D"), "position", Vector2(0,0), 0.5)
			tween.tween_callback(func():
				player.get_node("Sprite2D").flip_h = true
				finished.emit(IDLE)
			)
		elif skill.attack_type == "Ranged":
			# await get_tree().create_timer(0.5).timeout
			finished.emit(IDLE)

func _hit() -> void:
	hit_confirm.emit(skill.skill_name, target, player.stats.strength + skill.base_damage)

func exit() -> void:
	target = null; skill = null
	SignalBus.attack_finished.emit()


func animate() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
