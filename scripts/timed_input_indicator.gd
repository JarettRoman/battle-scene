extends Control
class_name TimedInputIndicator

@onready var progress_bar = $TextureProgressBar
@onready var button_icon = $ButtonIcon
@onready var timer = $Timer

@export var time: float = 1.0

signal timed_input_resolved(result: bool)

func _process(_delta: float) -> void:
	if timer.is_stopped():
		return

	var progress = progress_bar.value - _delta / time * 100
	set_progress_bar_value(progress)
		
	if progress_bar.value <= 25:
		progress_bar.tint_progress = Color.RED
	else:
		progress_bar.tint_progress = Color.ORANGE

func set_time(_time: float) -> void:
	time = _time

func set_progress_bar_value(_value: float) -> void:
	progress_bar.value = _value

func set_button_icon(_icon: Texture) -> void:
	button_icon.texture = _icon

func start_timed_input() -> void:
	set_progress_bar_value(100)
	timer.start(time)

func stop_timed_input(result: bool) -> void:
	timer.stop()
	timed_input_resolved.emit(result)

func _on_timer_timeout() -> void:
	timed_input_resolved.emit(false)
	queue_free()
