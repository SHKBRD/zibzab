extends Node3D
class_name DevelopmentPicker

signal option_chosen(type: Development.DevelopmentType)

func _ready() -> void:
	pass

func on_development_chosen(type: Development.DevelopmentType) -> void:
	if get_tree().get_nodes_in_group("Selected Zibs").size() != 0: return 
	option_chosen.emit(type)
	disable_options()
		
func disable_options() -> void:
	for option: PickerOption in %DevelopmentOptions.get_children():
		option.disable()

func enable_options() -> void:
	for option: PickerOption in %DevelopmentOptions.get_children():
		option.enable()
