extends Node

var current_scene = null

var equipped_skills : Array[Skill]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var skill = load("res://data/omegaslash.tres")
	equipped_skills.append(skill)
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)



func goto_main_menu() -> void:
	var main_scene = load("res://scenes/main_menu.tscn")
	goto_scene(main_scene)
	
func goto_skills_view() -> void:
	var skill_view = load("res://scenes/skills_view.tscn")
	goto_scene(skill_view)
	
func goto_combat_scene() -> void:
	var combat_scene = load("res://scenes/battle.tscn")
	goto_scene(combat_scene)

func goto_scene(scene : PackedScene) -> void:
	call_deferred("_deferred_goto_scene", scene)

func _deferred_goto_scene(scene):
	if current_scene:
		current_scene.free()
	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
