extends Resource
class_name Skill

@export var skill_name : String = ""
@export var base_damage : int = 0
@export_enum("Melee", "Ranged") var attack_type : String = "Melee"
