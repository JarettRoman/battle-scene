extends Control

@export var skills : Array[Skill]

var equipped_skills : Array[Skill]

var main_menu : PackedScene = load("res://scenes/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	equipped_skills = GameManager.equipped_skills
	for skill in skills:
		var skill_button = Button.new()
		skill_button.text = skill.skill_name
		skill_button.pressed.connect(self._skill_button_pressed.bind(skill))
		$ScrollContainer/VBoxContainer.add_child(skill_button)
	$ScrollContainer/VBoxContainer.get_child(0).grab_focus()

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameManager.equipped_skills.assign(equipped_skills)
		GameManager.goto_main_menu()
		
func _skill_button_pressed(skill: Skill) -> void:
	print("pressing skill: %s" % skill.skill_name)
	if equipped_skills.has(skill):
		print("Unequipped %s" % skill.skill_name)
		equipped_skills.erase(skill)
	else:
		print("%s is now equipped" % skill.skill_name)
		equipped_skills.append(skill)