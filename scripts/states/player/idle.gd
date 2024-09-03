extends PlayerStateBase

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_player.play("idle")


