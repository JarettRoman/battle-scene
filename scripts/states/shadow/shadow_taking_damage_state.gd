extends EnemyState

func enter(_previous_state_path: String, _data := {}) -> void:
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	enemy.animation_player.play("shadow_damaged_anim")

func _on_animation_finished(_anim_name: StringName) -> void:
	finished.emit(IDLE)

func _freeze_frame_impact() -> void:
		get_tree().paused = true
		await get_tree().create_timer(0.175).timeout
		get_tree().paused = false

func exit() -> void:
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)