extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animation_player.animation_finished.connect(_on_animation_finished)
	player.animation_player.play("move_forward")
	player.animation_player.queue("slash")
	player.animation_player.queue("move_backward")

func _on_animation_finished(_anim_name: StringName) -> void:
	finished.emit("Idle")

func exit() -> void:
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
