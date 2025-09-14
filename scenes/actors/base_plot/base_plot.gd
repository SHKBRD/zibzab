extends Node3D
class_name Plot

signal gotFocused(plot: Plot)

var gridX: int
var gridY: int

var assignedZibs: Array[Zib]

enum Availability {
	SUNK,
	BUYABLE,
	BOUGHT
}
var availabilityState: Availability = Availability.SUNK

var spaceType: Development.DevelopmentType = Development.DevelopmentType.NONE

func _ready() -> void:
	var smallScale: Vector3 = Vector3(0.001, 0.001, 0.001)
	scale = smallScale
	%PurchasePicker.scale = smallScale
	%PlotOutline.scale = smallScale
	
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

func develop(type: Development.DevelopmentType) -> void:
	raise(Plot.Availability.BOUGHT)
	var developmentNode: Development = Instantiate.scene(Development.devTypeClassNames[type])
	%BuildingDevelopment.add_child(developmentNode)

#region focus code
func focus() -> void:
	
	
	if availabilityState == Availability.BUYABLE:
		%PurchasePicker.show()
		var focusTween: Tween = get_tree().create_tween()
		focusTween.tween_property(%PurchasePicker, "scale", Vector3(1, 1, 1), 0.5).set_trans(Tween.TRANS_CUBIC)
	elif availabilityState == Availability.BOUGHT:
		var selectedZibs: Array = get_tree().get_nodes_in_group("SelectedZibs")
		if selectedZibs.is_empty():
			pass
		else:
			get_tree().call_group("SelectedZibs", "move_to_plot", self)
		pass

func defocus() -> void:
	
	
	if availabilityState == Availability.BUYABLE || availabilityState == Availability.BOUGHT:
		var defocusTween: Tween = get_tree().create_tween()
		defocusTween.tween_property(%PurchasePicker, "scale", Vector3(0.001, 0.001, 0.001), 0.5).set_trans(Tween.TRANS_CUBIC)
		defocusTween.finished.connect(func(): %PurchasePicker.hide())
	else: 
		pass
#endregion

func _process(delta: float) -> void:
	pass

func _on_plot_collision_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			gotFocused.emit(self)
			# develop(Development.DevelopmentType.MAIN)
		print("Clicked on: " + name)


func _on_purchase_picker_option_chosen(type: Development.DevelopmentType) -> void:
	develop(type)
	get_parent().focusPlot = null
