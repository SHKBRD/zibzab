extends Sprite3D
class_name PickerOption

signal chosen(type: Development.DevelopmentType)

@export var developmentType: Development.DevelopmentType

func _ready() -> void:
	chosen.connect((get_parent().get_parent() as DevelopmentPicker).on_development_chosen)


func _on_hitbox_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			chosen.emit(developmentType)

func enable() -> void:
	%PickerCollision.disabled = false

func disable() -> void:
	%PickerCollision.disabled = true
