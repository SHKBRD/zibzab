extends Node3D
class_name Plot

var gridX: int
var gridY: int

enum Availability {
	SUNK,
	BUYABLE,
	BOUGHT
}
var availabilityState: Availability = Availability.SUNK

enum SpaceType {
	NONE,
	MAIN,
	TOWER,
	CORRAL,
	ENERGY
}
var spaceType: SpaceType = SpaceType.NONE


func _ready() -> void:
	scale = Vector3(0.001, 0.001, 0.001)
	hide()
	

func raise(type: Availability) -> void:
	availabilityState = type
	
	if type == Availability.BUYABLE or type == Availability.BOUGHT:
		var buyableTween: Tween = get_tree().create_tween()
		buyableTween.tween_property(self, "scale", Vector3(1, 1, 1), 0.5).set_trans(Tween.TRANS_CUBIC)
		show()
	if type == Availability.BOUGHT:
		var boughtTween: Tween = get_tree().create_tween()
		boughtTween.tween_property(self, "position", Vector3(position.x, 1, position.z), 0.5).set_trans(Tween.TRANS_CUBIC)
		# raise surrounding plots
		for yOff: int in range(-1, 2):
			for xOff: int in range(-1, 2):
				if abs(yOff + xOff) % 2 == 1:
					var focusPlot: Plot = get_parent().get_node("%d,%d" % [gridX+xOff, gridY+yOff])
					if focusPlot != null and focusPlot.availabilityState == Plot.Availability.SUNK:
						focusPlot.raise(Plot.Availability.BUYABLE)

func develop(type: SpaceType):
	pass

func _process(delta: float) -> void:
	pass


func _on_plot_collision_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			raise(Plot.Availability.BOUGHT)
		print("Clicked on: " + name)
