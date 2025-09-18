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

@export_category("Orbit Values")
@export var orbitCenter: Node3D
@export var orbitRadius: float
@export var orbitRotateSpeed: float = 90

@export_category("Zib Capacity")
@export var zibWorkingCapacity: int
@export var workType: WorkType

@export_category("Incremental Values")
@export var zibCountBaseMultiplier: float = 1.25

@export_category("PlotHUDTexts")
@export var plotHUDTitle: String = "OVERRIDE ME"
@export var plotHUDDescription: String = "OVERRIDE ME"

var assignedZibs: Array[Zib]


func get_energy_bonus() -> float:
	return get_per_zib_zib_count_multiplier()

func _ready() -> void:
	zibPathsSetup(zibWorkingCapacity)
	update_plot_hud()

func update_plot_hud_name_description() -> void:
	var plotHud: PlotStatView = get_parent().get_parent().get_plot_hud()
	plotHud.update_name_description(plotHUDTitle, plotHUDDescription)

func update_plot_hud_development_specific() -> void:
	assert(false, "OVERRIDE THIS METHOD")

func update_plot_hud() -> void:
	update_plot_hud_name_description()
	update_plot_hud_development_specific()

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

# This returns the 
func get_per_zib_zib_count_multiplier() -> float:
	var zibCount: int = 0
	for zib: Zib in assignedZibs:
		if zib != null: zibCount += 1
	if zibCount == 0: return 0
	return pow(zibCountBaseMultiplier, zibCount-1)

func produce_energy_from_work() -> void:
	var initialEnergy = get_per_zib_zib_count_multiplier()
	Incrementals.add_energy(initialEnergy)

func produce_zabs_from_work() -> void:
	pass

func apply_calculated_work_value() -> void:
	assert(false, "Override apply_calculated_work_value!")

func _process(delta: float) -> void:
	if orbitCenter:
		orbitCenter.rotate_y(deg_to_rad(orbitRotateSpeed) * delta)
