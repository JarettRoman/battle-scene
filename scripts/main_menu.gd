extends Control

@export var demo : PackedScene
@export var skills_view : PackedScene


func _ready() -> void:
	print(GameManager.equipped_skills)
	$VBoxContainer/StartButton.grab_focus()
	if OS.has_feature("web"):
		$VBoxContainer/QuitButton.hide()

func _on_start_button_pressed() -> void:
	print(GameManager.equipped_skills)
	GameManager.goto_combat_scene()

func _on_skills_view_button_pressed() -> void:
	GameManager.goto_skills_view()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
