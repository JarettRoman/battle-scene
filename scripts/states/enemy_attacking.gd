extends EnemyState

var target: Battler
var skill: Skill

signal hit_confirm(skill_name: String, target: Battler, total_damage: int)

func enter(_previous_state_path: String, data := {}) -> void:
	target = data["target"]
	# skill = data["skill"]
	enemy.animation_player.animation_finished.connect(_on_animation_finished.bind(data))
	# enemy.animation_player.play("move_forward")
	enemy.animation_player.play("attack_slash")
	# enemy.animation_player.queue("move_backward")

func _on_animation_finished(_anim_name: StringName, _data: Dictionary) -> void:
	finished.emit(IDLE)

func _hit() -> void:
	print("Hitting %s with %s for %d" % [target.name, "Katana Slash", enemy.stats.strength])
	hit_confirm.emit("Katana Slash", target, enemy.stats.strength)

func exit() -> void:
	target = null
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
