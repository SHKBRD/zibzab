extends Sprite3D
class_name PickerOption

signal chosen(type: Development.DevelopmentType)
signal mouse_entered(option: PickerOption)
signal mouse_exited(option: PickerOption)

@export var developmentType: Development.DevelopmentType

func _ready() -> void:
	var picker: DevelopmentPicker = get_parent().get_parent()
	chosen.connect(picker.on_development_chosen)
	mouse_entered.connect(picker.reveal_development_price)
	mouse_exited.connect(picker.hide_development_price)


func enable() -> void:
	%PickerCollision.disabled = false

func disable() -> void:
	%PickerCollision.disabled = true


func _on_hitbox_mouse_entered() -> void:
	mouse_entered.emit(self)
	


func _on_hitbox_mouse_exited() -> void:
	mouse_exited.emit(self)


func _on_hitbox_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if Incrementals.can_buy(Incrementals.get_new_building_energy_cost(), Incrementals.get_new_building_zab_cost()):
				chosen.emit(developmentType)
			else:
				WorldSpace.reject_payment()
