extends Node3D
class_name WorldSpace

static var world: WorldSpace = null
static var buildingAmount: int = 0

static func reject_payment() -> void:
	pass

func _ready() -> void:
	if world != null: assert(false, "ONLY ONE WORLD INSTANCE ALLOWED!")
	world = self

func get_zib_amount_cost_mult() -> float:
	var zibCount: int = WorldSpace.world.get_zib_count()
	return pow(Incrementals.perZibMultCostIncrease, zibCount-1)

func get_zib_count() -> int:
	return %Zibs.get_child_count()

func add_zib(zib: Zib) -> void:
	%Zibs.add_child(zib)

func make_fail_noise() -> void:
	pass

func _process(delta: float) -> void:
	print(Incrementals.zabs)
