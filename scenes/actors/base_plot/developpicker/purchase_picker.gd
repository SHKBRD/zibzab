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

func _process(delta: float) -> void:
	var newBuildingEnergyCost: float = ceil(Incrementals.get_new_building_energy_cost())
	var newBuildingZabCost: float = ceil(Incrementals.get_new_building_zab_cost())
	
	%CostSprite.update_cost(newBuildingEnergyCost, newBuildingZabCost)

func reveal_development_price(option: PickerOption) -> void:
	%CostSprite.show()
	%CostSprite.update_title(Development.devTypeNames[option.developmentType] + " Cost:")

func hide_development_price(option: PickerOption) -> void:
	%CostSprite.hide()
