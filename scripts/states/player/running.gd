extends PlayerStateBase


# Called when the node enters the scene tree for the first time.

func enter(_previous_state_path: String, data := {}) -> void:
	player.animation_player.play("run")
	if _previous_state_path == ATTACKING:
		var tween = create_tween()
		tween.tween_property(player.get_node("Sprite2D"), "position", Vector2.ZERO, 0.5)
	elif _previous_state_path == IDLE:
		var tween = create_tween()
		tween.tween_property(player.get_node("Sprite2D"), "position", Vector2(150,0), 0.5)
	# pass
	# target = data["target"]
	# skill = data["skill"]
	# attack_index = 0
	# # SignalBus.attack_finished.connect(player.attack_finished)
	# player.animation_player.play("run")
	# animate()
	# tween.tween_property(player.get_node("Sprite2D"), "position", Vector2(150,0), 0.5)
	# tween.tween_callback(foo)

func exit() -> void:
	print("exit running")