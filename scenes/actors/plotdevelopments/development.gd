extends Node3D
class_name Development

enum DevelopmentType {
	NONE,
	MAIN,
	TOWER,
	CORRAL,
	CHARGER,
	ZIB_MAKER
}

enum WorkType {
	NONE,
	ORBIT,
	UPGRADE,
	WANDER
}

static var devTypeClassNames: Dictionary[DevelopmentType, GDScript] = {
	DevelopmentType.MAIN: MainDevelopment,
	DevelopmentType.TOWER: EnergyGenDevelopment,
	DevelopmentType.CORRAL: CorralDevelopment,
	DevelopmentType.CHARGER: ChargerDevelopment,
	DevelopmentType.ZIB_MAKER: ZibMakerDevelopment
}

@export var orbitCenter: Node3D
@export var orbitRadius: float
@export var orbitRotateSpeed: float = 90

@export var zibWorkingCapacity: int
@export var workType: WorkType

var assignedZibs: Array[Zib]

func _ready() -> void:
	zibPathsSetup(zibWorkingCapacity)

func zibPathsSetup(capacity: int) -> void:
	if orbitCenter == null: return
	if orbitCenter.get_child_count() != 0:
		for orbitHolder: Node3D in orbitCenter.get_children():
			orbitHolder.queue_free()
	for zibWorkerNumber: int in zibWorkingCapacity:
		var workerPlaceholder: Node3D = Node3D.new()
		workerPlaceholder.position.x = 0*orbitCenter.position.x + orbitRadius * cos(deg_to_rad(360*zibWorkerNumber/zibWorkingCapacity))
		workerPlaceholder.position.z = 0*orbitCenter.position.z + orbitRadius * sin(deg_to_rad(360*zibWorkerNumber/zibWorkingCapacity))
		workerPlaceholder.position.y = -2
		orbitCenter.add_child(workerPlaceholder)

		
func assignZib(zib: Zib) -> void:
	zib.workTarget = null
	zib.workConnect = 0
	if assignedZibs.find(null) != -1:
		assignedZibs[assignedZibs.find(null)] = zib
	elif assignedZibs.size() < zibWorkingCapacity:
		assignedZibs.append(zib)
	else:
		return
	if workType == WorkType.ORBIT or workType == WorkType.UPGRADE:
		var zibId: int = assignedZibs.find(zib)
		print(zibId)
		zib.workTarget = orbitCenter.get_child(zibId)
	if workType == WorkType.WANDER:
		pass
	zib.assignedPlot = get_parent().get_parent()
	pass

func on_zib_work_completed(amount: int, zib: Zib) -> void:
	
	for applyAmount: int in amount:
		apply_calculated_work_value()

func apply_calculated_work_value() -> void:
	pass

func _process(delta: float) -> void:
	if orbitCenter:
		orbitCenter.rotate_y(deg_to_rad(orbitRotateSpeed) * delta)
