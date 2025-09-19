extends Sprite3D
class_name CostSprite

func update_cost(energyCost: int, zabCost: int) -> void:
	%CostEnergy.text = str(energyCost)
	%CostZab.text = str(zabCost)
	
