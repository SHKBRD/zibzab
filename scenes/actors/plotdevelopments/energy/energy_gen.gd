extends Development
class_name EnergyGenDevelopment

enum GenerationType {
	NONE,
	ENERGY,
	ZAB
}

var generationType: GenerationType = GenerationType.ENERGY

func _ready() -> void:
	super()
	update_monitor_visual()

func apply_calculated_work_value() -> bool:
	if generationType == GenerationType.ENERGY:
		produce_energy_from_work()
	elif generationType == GenerationType.ZAB:
		produce_zabs_from_work()
	else:
		assert(false, "WORK ISN'T WORKING IN THIS ENERGY/ZAB THING")
	return true

func get_energy_bonus() -> float:
	if generationType == GenerationType.ENERGY:
		return get_per_zib_zib_count_multiplier() * baseEnergyGen
	else:
		return 0

func get_zab_bonus() -> float:
	if generationType == GenerationType.ZAB:
		return get_per_zib_zib_count_multiplier() * baseZabGen
	else:
		return 0

func update_plot_hud_development_specific() -> void:
	pass

func update_monitor_visual() -> void:
	if generationType == GenerationType.ENERGY:
		%Energy.show()
		%Zab.hide()
	else:
		%Energy.hide()
		%Zab.show()

func update_switch_visual() -> void:
	# 35 degree alt
	if generationType == GenerationType.ENERGY:
		var energyToggleTween: Tween = get_tree().create_tween()
		energyToggleTween.tween_property(%Switch, "rotation", Vector3(0, deg_to_rad(-180), 0), 0.25).set_trans(Tween.TRANS_CUBIC)
	elif generationType == GenerationType.ZAB:
		var zabToggleTween: Tween = get_tree().create_tween()
		zabToggleTween.tween_property(%Switch, "rotation", Vector3(0, deg_to_rad(-180), deg_to_rad(-35)), 0.25).set_trans(Tween.TRANS_CUBIC)
		

func toggle_energy_type() -> void:
	if generationType == GenerationType.ENERGY:
		generationType = GenerationType.ZAB
	else:
		generationType = GenerationType.ENERGY
	update_monitor_visual()
	update_switch_visual()


func _on_switch_area_mouse_entered() -> void:
	pass # Replace with function body.


func _on_switch_area_mouse_exited() -> void:
	pass # Replace with function body.


func _on_switch_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			toggle_energy_type()
