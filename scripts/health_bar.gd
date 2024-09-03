extends ProgressBar
class_name HealthBar

@onready var timer: Timer = $Timer
@onready var damage_bar: ProgressBar = $DamageBar

var health: int = 0 : set = _set_health
var tween: Tween

func init_health_bar(initial_health: int, for_enemy: bool = false) -> void:
    max_value = initial_health
    health = initial_health
    damage_bar.max_value = initial_health
    damage_bar.value = initial_health
    damage_bar.fill_mode = ProgressBar.FILL_END_TO_BEGIN if for_enemy else ProgressBar.FILL_BEGIN_TO_END

func _set_health(new_health: int) -> void:
    var prev_health = health
    health = clamp(new_health, 0, max_value)
    value = health

    if health < prev_health:
        _animate_damage_bar()
    else:
        damage_bar.value = health

    if health <= 0:
        _queue_free_after_delay()

func _animate_damage_bar() -> void:
    if tween:
        tween.kill()
    tween = create_tween()
    tween.tween_property(damage_bar, "value", health, 0.5)

func _queue_free_after_delay() -> void:
    await get_tree().create_timer(0.5).timeout
    queue_free()
