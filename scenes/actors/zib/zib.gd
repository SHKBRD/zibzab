extends Node3D
class_name Zib

signal selected(zib: Zib)
signal deselected(zib: Zib)

@export var maxFlightSpeed: float

var zibVelocity: Vector3

var targetHeadingPlot: Plot = null
var assignedPlot: Plot = null

var isSelected: bool = false

enum ZibState {
	IDLE,
	PLOT_HEADING,
	WORK_HEADING,
	WORKING,
	TIRED
}

var zibState: ZibState = ZibState.IDLE

func _ready() -> void:
	var smallScale: Vector3 = Vector3(0.001, 0.001, 0.001)
	%SelectedSprite.scale = smallScale
	



func _process(delta: float) -> void:
	pass

func move_to_plot(plot: Plot) -> void:
	targetHeadingPlot = plot
	


func on_deselected() -> void:
	deselected.emit(self)
	isSelected = false
	add_to_group("SelectedZibs")
	var selectTween: Tween = get_tree().create_tween()
	selectTween.tween_property(%SelectedSprite, "scale", Vector3(0.001, 0.001, 0.001), 0.25)


func on_selected() -> void:
	selected.emit(self)
	isSelected = true
	remove_from_group("SelectedZibs")
	var selectTween: Tween = get_tree().create_tween()
	selectTween.tween_property(%SelectedSprite, "scale", Vector3(1, 1, 1), 0.25)


func _on_zib_hitbox_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if isSelected: on_deselected() 
			else: on_selected()
