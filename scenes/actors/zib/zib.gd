extends Node3D
class_name Zib

signal selected(zib: Zib)
signal deselected(zib: Zib)
signal work_completed(amount: int)
signal moving_to_plot(plot: Plot, zib: Zib)

@export var maxFlightSpeed: float = 9
@export var maxWanderSpeed: float = 2.5

var zibFaceMat: Material = preload("res://scenes/actors/zib/material/zibface.tres")
var zibFaceTiredMat: Material = preload("res://scenes/actors/zib/material/zibfacetired.tres")

var zibVelocity: Vector3

var assignedPlot: Plot = null

# var targetHeadingPlot: Plot = null
var workTarget: Node3D = null:
	set(value):
		#print(value)
		workTarget = value
var workConnect: float = 0
var workConnectDelay: float = 0.05

# work per second
var zibWorkEffective: float = 0.5
var normalZibWork: float = 0.5
var chargedZibWork: float = 5.0

var zibWorkProgress: float = 0
var workCompleted: int = 0

var workLimit: int = 30
var chargedWorkLimit: int = 400
var normalworkLimit: int = 30

var isZibTired: bool = false


var isSelected: bool = false
var supercharged: bool = false

enum ZibState {
	IDLE,
	PLOT_HEADING,
	#WORK_HEADING,
	WORKING,
}

var stateToString: Dictionary[ZibState, String] = {
	ZibState.IDLE: "Idle",
	ZibState.PLOT_HEADING: "Moving",
	ZibState.WORKING: "Working",
}

var zibState: ZibState = ZibState.IDLE

func get_energy_per_second() -> float:
	if not assignedPlot or assignedPlot.get_development().workType != Development.WorkType.ORBIT: return 0
	return assignedPlot.get_energy_per_second() * zibWorkEffective

func get_zabs_per_second() -> float:
	if not assignedPlot or assignedPlot.get_development().workType != Development.WorkType.ORBIT: return 0
	return assignedPlot.get_zabs_per_second() * zibWorkEffective

func _ready() -> void:
	var smallScale: Vector3 = Vector3(0.001, 0.001, 0.001)
	%SelectedSprite.scale = smallScale
	


func move_to_plot(plot: Plot) -> void:
	assignedPlot = plot
	zibState = ZibState.PLOT_HEADING
	moving_to_plot.emit(plot, self)
	if plot.get_development() is ChargerDevelopment:
		plot.get_development().link_zib_to_charger(self)


#region Zib Work
func plot_move(delta: float) -> void:
	if [Development.WorkType.ORBIT, Development.WorkType.UPGRADE].has(assignedPlot.get_development().workType):
		work_orbit(delta)
	if [Development.WorkType.WANDER].has(assignedPlot.get_development().workType):
		work_wander(delta)

func work_orbit(delta: float) -> void:
	# var lerpFinal: float = 1-pow(workConnectDelay, delta)
	workConnect += workConnectDelay * delta
	workConnect = clamp(workConnect, 0, 1)
	#print(lerpFinal)
	global_position = global_position.lerp(workTarget.global_position, workConnect)

func work_wander(delta: float) -> void:
	var unitDistance: Vector3 = (assignedPlot.global_position - global_position).abs()
	if workTarget == null or workTarget.global_position == global_position or (unitDistance.x > 6 or unitDistance.z > 6):
		if workTarget: workTarget.queue_free()
		
		# wander location generation
		workTarget = Node3D.new()
		assignedPlot.add_child(workTarget)
		var randX: float = RandomNumberGenerator.new().randf_range(-6, 6)
		var randZ: float = RandomNumberGenerator.new().randf_range(-6, 6)
		
		workTarget.global_position = assignedPlot.global_position + Vector3(randX, 0, randZ)
	global_position = global_position.move_toward(workTarget.global_position, maxWanderSpeed*delta)


func make_zib_untired() -> void:
	isZibTired = false
	%ZibBody.set_surface_override_material(0, zibFaceMat)

func make_zib_tired() -> void:
	isZibTired = true
	%ZibBody.set_surface_override_material(0, zibFaceTiredMat)
	if supercharged:
		unsupercharge()

func make_work(delta: float) -> void:
	zibWorkProgress += zibWorkEffective * delta
	
	var workAchieved: int = floor(zibWorkProgress)
	var tireZib: bool = assignedPlot.get_development().on_zib_work_completed(workAchieved, self)
	
	for workTime: int in workAchieved:
		if not isZibTired:
			zibWorkProgress -= 1
			if tireZib and assignedPlot.get_development().workType != Development.WorkType.WANDER:
				workCompleted += 1
			if workCompleted == workLimit:
				make_zib_tired()
#endregion

func supercharge() -> void:
	supercharged = true
	%ZibBodyBlueOutline.show()
	%ZibBodyOutline.hide()
	zibWorkEffective = chargedZibWork
	workLimit = chargedWorkLimit

func unsupercharge() -> void:
	supercharged = false
	%ZibBodyBlueOutline.hide()
	%ZibBodyOutline.show()
	zibWorkEffective = normalZibWork
	workLimit = chargedWorkLimit

func process_zib_state(delta: float) -> void:
	match zibState:
		ZibState.PLOT_HEADING:
			# heading to plot
			global_position = global_position.move_toward(assignedPlot.global_position * Vector3(1, 0, 1) + Vector3(0, 5, 0), maxFlightSpeed * delta)
			
			# transitioning to work based on proximty to plot
			var unitDistance: Vector3 = (assignedPlot.global_position - global_position).abs()
			if unitDistance.x < 8 and unitDistance.z < 8:
				zibState = ZibState.WORKING
		ZibState.WORKING:
			plot_move(delta)
			if not isZibTired or (isZibTired and assignedPlot.get_development() is CorralDevelopment):
				make_work(delta)
		_:
			pass

func turn_towards_position(effective_direction: Vector3, strength: float) -> void:
	var forward_vector: Vector3 = %ZibBody.basis.x
	forward_vector *= Vector3(1, 0, 1)
	effective_direction *= Vector3(1, 0, 1)
	var angleDistance: float = forward_vector.angle_to(effective_direction)
	%ZibBody.rotate_y(angleDistance * strength)

func _process(delta: float) -> void:
	var old_position: Vector3 = position
	process_zib_state(delta)
	turn_towards_position(position-old_position, 0.2)
	
	update_info_sprite()


func on_deselected() -> void:
	deselected.emit(self)
	isSelected = false
	remove_from_group("SelectedZibs")
	var selectTween: Tween = get_tree().create_tween()
	selectTween.tween_property(%SelectedSprite, "scale", Vector3(0.001, 0.001, 0.001), 0.25)


func on_selected() -> void:
	PlotSpace.focusPlot = null
	selected.emit(self)
	isSelected = true
	add_to_group("SelectedZibs")
	
	var selectTween: Tween = get_tree().create_tween()
	selectTween.tween_property(%SelectedSprite, "scale", Vector3(1, 1, 1), 0.25)
	%InfoSprite.hide()


func _on_zib_hitbox_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if isSelected: on_deselected() 
			else: on_selected()
		print(get_tree().get_nodes_in_group("SelectedZibs"))

func update_info_sprite() -> void:
	var statusString: String
	if isZibTired:
		statusString = "Tired"
	else:
		statusString = stateToString[zibState]
	%ZibStatView.update_status(statusString)
	
	%ZibStatView.update_energy_rate(get_energy_per_second())
	%ZibStatView.update_zab_rate(get_zabs_per_second())
	%ZibStatView.update_tiredness(workCompleted/float(workLimit))
	pass

func _on_zib_hitbox_mouse_entered() -> void:
	%InfoSprite.show()


func _on_zib_hitbox_mouse_exited() -> void:
	%InfoSprite.hide()
