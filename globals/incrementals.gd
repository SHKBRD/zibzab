extends Node

signal goal_reached()

var energyGoal: float = 500_000
var goalReached: bool = false

var energy: float = 0
var zabs: float = 0

var perZibMultCostIncrease: float = 1.5
var perBuildingMultCostIncrease: float = 1.5

var baseBuildingEnergyCost: float = 5000
var baseBuildingZabCost: float = 250
var zibHolderBaseEnergyCost: float = 1000
var zibHolderBaseZabCost: float = 50

var energyMults: Dictionary[String, float] = {
	"baseMult": 1.0
}

var zabMults: Dictionary[String, float] = {
	"baseMult": 1.0
}

func can_buy(energyCost: float, zabCost: float) -> bool:
	return energyCost < energy and zabCost < zabs

func spend(energySpent: float, zabsSpent: float) -> void:
	energy -= energySpent
	zabs -= zabsSpent

func get_applied_zib_energy_mult() -> float:
	var baseMult: float = 1.0
	for key: String in energyMults:
		baseMult *= energyMults[key]
	return baseMult

func get_applied_zib_zab_mult() -> float:
	var baseMult: float = 1.0
	for key: String in zabMults:
		baseMult *= zabMults[key]
	return baseMult

func get_bought_building_mult() -> float:
	return pow(perBuildingMultCostIncrease, WorldSpace.buildingAmount-3)

func get_new_building_energy_cost() -> float:
	return baseBuildingEnergyCost * get_bought_building_mult()

func get_new_building_zab_cost() -> float:
	return baseBuildingZabCost * lerpf(1, get_applied_zib_zab_mult(), 1.5)

func get_zib_holder_energy_build_price() -> float:
	var energyCost: float = zibHolderBaseEnergyCost
	energyCost *= WorldSpace.world.get_zib_count() / float(2)
	
	return energyCost

func get_zib_holder_zab_build_price() -> float:
	var zabCost: float = zibHolderBaseZabCost
	zabCost *= WorldSpace.world.get_zib_count() / float(4)
	
	return zabCost

func add_energy(amount: float) -> void:
	energy += amount * get_applied_zib_energy_mult()
	if energy >= energyGoal and not goalReached:
		goal_reached.emit()
		goalReached = true

func add_zabs(amount: float) -> void:
	zabs += amount * get_applied_zib_zab_mult()
