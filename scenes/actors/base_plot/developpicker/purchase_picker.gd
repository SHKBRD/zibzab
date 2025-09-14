extends Node3D
class_name DevelopmentPicker

signal option_chosen(type: Development.DevelopmentType)

func _ready() -> void:
	pass

func on_development_chosen(type: Development.DevelopmentType) -> void:
	option_chosen.emit(type)
	for option: PickerOption in %DevelopmentOptions.get_children():
		option.get_node("Hitbox/CollisionShape3D").disabled = true
