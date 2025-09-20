extends Node3D
class_name WorldSpace

static var world: WorldSpace = null

func _ready() -> void:
	if world != null: assert(false, "ONLY ONE WORLD INSTANCE ALLOWED!")
	world = self

func get_zib_amount_cost_mult() -> float:
	var zibCount: int = %Zibs.get_child_count()
	return pow(Incrementals.perZibMultCostIncrease, zibCount-1)

func get_zib_count() -> int:
	return %Zibs.get_child_count()

func add_zib(zib: Zib) -> void:
	%Zibs.add_child(zib)
