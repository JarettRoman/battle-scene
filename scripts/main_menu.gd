extends Control

@export var demo : PackedScene
@export var skills_view : PackedScene


func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
	GameManager.goto_scene(demo)

func _on_skills_view_button_pressed() -> void:
	GameManager.goto_scene(skills_view)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
