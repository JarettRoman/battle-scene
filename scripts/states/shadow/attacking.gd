extends EnemyState

var target: Battler
var skill: Skill
var tween: Tween

signal hit_confirm(skill_name: String, target: Battler, total_damage: int)

func enter(_previous_state_path: String, data := {}) -> void:
	target = data["target"]
	# skill = data["skill"]
	enemy.animation_player.animation_finished.connect(_on_animation_finished.bind(data))
	enemy.animation_player.play("shadow_run_anim")
	animate()
	tween.tween_property(enemy.get_node("Sprite2D"), "position", Vector2(-200,0), 0.5)
	tween.tween_callback(enemy.animation_player.play.bind("shadow_attack_anim"))


	# enemy.animation_player.queue("move_backward")

func _on_animation_finished(_anim_name: StringName, _data: Dictionary) -> void:
	enemy.get_node("Sprite2D").flip_h = true
	enemy.animation_player.play("shadow_run_anim")	
	animate()
	tween.tween_property(enemy.get_node("Sprite2D"), "position", Vector2(0,0), 0.5)
	tween.tween_callback(func():
		enemy.get_node("Sprite2D").flip_h = false
		finished.emit(IDLE)
	)

func _hit() -> void:
	print("Hitting %s with %s for %d" % [target.name, "Scratch", enemy.stats.strength])
	hit_confirm.emit("Scratch", target, enemy.stats.strength)

func exit() -> void:
	target = null
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	SignalBus.attack_finished.emit()

func animate() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()