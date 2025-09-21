extends Node3D
class_name Plot

signal gotFocused(plot: Plot)

var plotBlackOutline: Material = preload("res://shaders/outlineshader.tres")
var plotHighlightOutline: Material = preload("res://shaders/Highlight.tres")

var gridX: int
var gridY: int

enum Availability {
	SUNK,
	BUYABLE,
	BOUGHT
}
var availabilityState: Availability = Availability.SUNK

var spaceType: Development.DevelopmentType = Development.DevelopmentType.NONE

func get_development() -> Development:
	return %BuildingDevelopment.get_child(0)
	
func get_plot_hud() -> PlotStatView:
	return %PlotStatView

func get_energy_per_second() -> float:
	var developmentMultBonus: float = get_development().get_energy_bonus()
	return Incrementals.get_applied_zib_energy_mult() * developmentMultBonus

func get_zabs_per_second() -> float:
	var developmentMultBonus: float = get_development().get_zab_bonus()
	return Incrementals.get_applied_zib_zab_mult() * developmentMultBonus

func _ready() -> void:
	var smallScale: Vector3 = Vector3(0.001, 0.001, 0.001)
	scale = smallScale
	%PurchasePicker.scale = smallScale
	#%PlotOutline.scale = smallScale
	
	hide()
	

#region plot upgrades
func raise(type: Availability) -> void:
	availabilityState = type
	if type == Availability.BUYABLE:
		%Sprite3DMoney.show()
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
	%Sprite3DMoney.hide()
	WorldSpace.buildingAmount += 1
	var developmentNode: Development = Instantiate.scene(Development.devTypeClassNames[type])
	spaceType = type
	%BuildingDevelopment.add_child(developmentNode)
#endregion

func attempt_transfer_zib_to_this_plot(zib: Zib) -> bool:
	if zib.assignedPlot == self: 
		zib.on_deselected()
		return false
	
	if zib.assignedPlot:
		var plotZibList: Array = zib.assignedPlot.get_development().assignedZibs
		plotZibList[plotZibList.find(zib)] = null
	get_development().assignZib(zib)
	zib.move_to_plot(self)
	zib.on_deselected()
	return true

func plot_stat_view_update() -> void:
	var development: Development = get_development()
	var assignedZibCount: int = development.get_no_null_assigned_zib_list().size()
	
	%PlotStatView.update_assigned_zibs(assignedZibCount, development.zibWorkingCapacity)

#region focus code
func focus() -> void:
	
	if availabilityState == Availability.BUYABLE:
		%PurchasePicker.show()
		%Sprite3DMoney.hide()
		var focusTween: Tween = get_tree().create_tween()
		focusTween.tween_property(%PurchasePicker, "scale", Vector3(1, 1, 1), 0.25).set_trans(Tween.TRANS_CUBIC)
		%PurchasePicker.enable_options()
	elif availabilityState == Availability.BOUGHT:
		PlotSpace.focusPlot = self
		show_plot_outline()
		%PlotStatView.show()
		plot_stat_view_update()
		%PlotOutline.set_surface_override_material(0, plotBlackOutline)
		
		var selectedZibs: Array = get_tree().get_nodes_in_group("SelectedZibs")
		
		var plotZibCount: int = 0
		for existingZib: Zib in %BuildingDevelopment.get_child(0).assignedZibs:
			if existingZib != null: plotZibCount += 1
		if selectedZibs.is_empty():
			pass
		elif (%BuildingDevelopment.get_child(0).zibWorkingCapacity - plotZibCount) - selectedZibs.size() < 0:
			
			WorldSpace.world.make_fail_noise()
		else:
			print("Zib Assignment")
			for zib: Zib in selectedZibs:
				attempt_transfer_zib_to_this_plot(zib)
			defocus()
			#get_tree().call_group("SelectedZibs", "move_to_plot", self)
		pass
	

func defocus() -> void:
	hide_plot_outline()
	%PlotStatView.hide()
	if availabilityState == Availability.BUYABLE:
		%Sprite3DMoney.show()
	elif availabilityState == Availability.BOUGHT:
		%Sprite3DMoney.hide()
	if availabilityState == Availability.BUYABLE || availabilityState == Availability.BOUGHT:
		var defocusTween: Tween = get_tree().create_tween()
		defocusTween.tween_property(%PurchasePicker, "scale", Vector3(0.001, 0.001, 0.001), 0.25).set_trans(Tween.TRANS_CUBIC)
		defocusTween.finished.connect(func(): if %PurchasePicker.get_parent() != PlotSpace.focusPlot : %PurchasePicker.hide())
		%PurchasePicker.disable_options()
	else: 
		pass
	PlotSpace.focusPlot = null
#endregion

func show_plot_outline() -> void:
	#var focusTween: Tween = get_tree().create_tween()
	%PlotOutline.show()
	
	
	#focusTween.tween_property(%PlotOutline, "scale", Vector3(1, 1, 1), 0.5).set_trans(Tween.TRANS_CUBIC)

func hide_plot_outline() -> void:
	#var defocusTween: Tween = get_tree().create_tween()
	#
	#defocusTween.tween_property(%PlotOutline, "scale", Vector3(0.935, 0.935, 0.935), 0.5).set_trans(Tween.TRANS_CUBIC)
	##defocusTween.finished.connect(func(): if self != PlotSpace.focusPlot: %PlotOutline.hide())
	%PlotOutline.hide()
	#%PlotOutline.set_surface_override_material(0, plotHighlightOutline)
	
	
	
func _process(delta: float) -> void:
	pass

func _on_plot_collision_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			gotFocused.emit(self)
			# develop(Development.DevelopmentType.MAIN)
		print("Clicked on: " + name)
		print(get_tree().get_nodes_in_group("SelectedZibs"))



func _on_purchase_picker_option_chosen(type: Development.DevelopmentType) -> void:
	Incrementals.spend(Incrementals.get_new_building_energy_cost(), Incrementals.get_new_building_zab_cost())
	develop(type)
	PlotSpace.focusPlot.defocus()


func _on_plot_collision_mouse_entered() -> void:
	if availabilityState != Availability.BOUGHT: return
	show_plot_outline()
	if self != PlotSpace.focusPlot:
		%PlotOutline.set_surface_override_material(0, plotHighlightOutline)
	

func _on_plot_collision_mouse_exited() -> void:
	if self == PlotSpace.focusPlot or availabilityState != Availability.BOUGHT: return
	hide_plot_outline()
	
