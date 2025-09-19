extends Node

var energyGoal: float = 1_000_000_000

var energy: float = 0
var zabs: float = 0

var perZibMultCostIncrease: float = 1.25

var energyMults: Dictionary[String, float] = {
	"baseMult": 1.0
}

func get_applied_zib_energy_mult() -> float:
	var baseMult: float = 1.0
	for key: String in energyMults:
		baseMult *= energyMults[key]
	return baseMult

func add_energy(amount: float) -> void:
	energy += amount * get_applied_zib_energy_mult()
