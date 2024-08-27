extends ProgressBar
class_name HealthBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health: int = 0 : set = set_health

func init_health_bar(_health: int, for_enemy: bool = false) -> void:
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health
	damage_bar.fill_mode = ProgressBar.FILL_END_TO_BEGIN if for_enemy else ProgressBar.FILL_BEGIN_TO_END

func set_health(new_health: int) -> void:
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	if health <= 0:
		await get_tree().create_timer(0.5).timeout
		queue_free()
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
