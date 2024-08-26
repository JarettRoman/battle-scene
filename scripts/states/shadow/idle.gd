extends EnemyState

func enter(_previous_state_path: String, _data := {}) -> void:
	enemy.animation_player.play("shadow_idle_anim")
