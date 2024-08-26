extends PlayerState

var target: Battler
var skill: Skill
var tween: Tween

signal hit_confirm(skill_name: String, target: Battler, total_damage: int)

func enter(_previous_state_path: String, data := {}) -> void:
	target = data["target"]
	skill = data["skill"]
	player.animation_player.animation_finished.connect(_on_animation_finished.bind(data))
	player.animation_player.play("run")
	animate()
	tween.tween_property(player.get_node("Sprite2D"), "position", Vector2(150,0), 0.5)
	tween.tween_callback(player.animation_player.play.bind("slash_1"))

func _on_animation_finished(_anim_name: StringName, _data: Dictionary) -> void:
	player.get_node("Sprite2D").flip_h = false
	player.animation_player.play("run")	
	animate()
	tween.tween_property(player.get_node("Sprite2D"), "position", Vector2(0,0), 0.5)
	tween.tween_callback(func():
		player.get_node("Sprite2D").flip_h = true
		finished.emit(IDLE)
	)

func _hit() -> void:
	hit_confirm.emit(skill.skill_name, target, player.stats.strength + skill.base_damage)

func exit() -> void:
	target = null; skill = null
	player.animation_player.animation_finished.disconnect(_on_animation_finished)

func animate() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()