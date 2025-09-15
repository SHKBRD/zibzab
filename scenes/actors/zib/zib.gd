extends Node3D
class_name Zib

signal selected(zib: Zib)
signal deselected(zib: Zib)

@export var maxFlightSpeed: float = 9
@export var maxWanderSpeed: float = 5

var zibVelocity: Vector3

var assignedPlot: Plot = null

# var targetHeadingPlot: Plot = null
var workTarget: Node3D = null
var workConnect: float = 0
var workConnectDelay: float = 0.05

var zibWorkEffective: float = 0.5
var zibWorkProgress: float = 0

var isSelected: bool = false

enum ZibState {
	IDLE,
	PLOT_HEADING,
	#WORK_HEADING,
	WORKING,
	TIRED
}

var zibState: ZibState = ZibState.IDLE

func _ready() -> void:
	var smallScale: Vector3 = Vector3(0.001, 0.001, 0.001)
	%SelectedSprite.scale = smallScale
	


func move_to_plot(plot: Plot) -> void:
	#workTarget = null
	assignedPlot = plot
	zibState = ZibState.PLOT_HEADING


func work_orbit(delta: float) -> void:
	# var lerpFinal: float = 1-pow(workConnectDelay, delta)
	workConnect += workConnectDelay * delta
	workConnect = clamp(workConnect, 0, 1)
	#print(lerpFinal)
	global_position = global_position.lerp(workTarget.global_position, workConnect)

func work_wander(delta: float) -> void:
	if workTarget == null or workTarget.global_position == global_position:
		if workTarget: workTarget.queue_free()
		workTarget = Node3D.new()
		assignedPlot.add_child(workTarget)
		var randX: float = RandomNumberGenerator.new().randf_range(-6, 6)
		var randZ: float = RandomNumberGenerator.new().randf_range(-6, 6)
		workTarget.global_position = assignedPlot.global_position + Vector3(randX, 0, randZ)
	global_position = global_position.move_toward(workTarget.global_position, maxWanderSpeed*delta)

func process_zib_state(delta: float) -> void:
	match zibState:
		ZibState.PLOT_HEADING:
			global_position = global_position.move_toward(assignedPlot.global_position * Vector3(1, 0, 1) + Vector3(0, 5, 0), maxFlightSpeed * delta)
			var unitDistance: Vector3 = (assignedPlot.global_position - global_position).abs()
			if unitDistance.x < 8 or unitDistance.z < 8:
				zibState = ZibState.WORKING
		#ZibState.WORK_HEADING:
			#if [Development.WorkType.ORBIT, Development.WorkType.UPGRADE].has(assignedPlot.get_development().workType):
				#zibState = ZibState.WORKING
			#global_position = global_position.move_toward(workTarget.global_position, maxFlightSpeed * delta)
		ZibState.WORKING:
			if [Development.WorkType.ORBIT, Development.WorkType.UPGRADE].has(assignedPlot.get_development().workType):
				work_orbit(delta)
			if [Development.WorkType.WANDER].has(assignedPlot.get_development().workType):
				work_wander(delta)
			
		ZibState.TIRED:
			pass
		_:
			pass

func _process(delta: float) -> void:
	process_zib_state(delta)


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


func _on_zib_hitbox_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if isSelected: on_deselected() 
			else: on_selected()
		print(get_tree().get_nodes_in_group("SelectedZibs"))
