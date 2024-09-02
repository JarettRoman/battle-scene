extends Battler
class_name Player

var timed_input_indicator_scene: PackedScene = preload("res://scenes/timed_input_indicator.tscn")
var timed_input_indicator: TimedInputIndicator

func start_timed_input() -> void:
	timed_input_indicator = timed_input_indicator_scene.instantiate()
	timed_input_indicator.timed_input_resolved.connect(_on_timed_input_resolved)
	$Sprite2D.add_child(timed_input_indicator)
	timed_input_indicator.position = Vector2(-88, -88)
	timed_input_indicator.set_time(1.2)
	timed_input_indicator.start_timed_input()
	animation_player.speed_scale = 0

func stop_timed_input(result: bool) -> void:
	if not timed_input_indicator:
		return

	animation_player.speed_scale = 1
	timed_input_indicator.stop_timed_input(result)
	timed_input_indicator.queue_free()

func attack(target: Battler, skill: Skill) -> void:
	state_machine._transition_to_next_state(
		PlayerState.ATTACKING,
		{"target": target, "skill": skill}
	)

func _on_timed_input_resolved(result: bool) -> void:
	if not result:
		animation_player.speed_scale = 1
		get_parent().info_box.text = "You missed!"
		animation_player.stop()
		self.get_node("Sprite2D").position = Vector2.ZERO
		state_machine._transition_to_next_state(PlayerState.IDLE)
