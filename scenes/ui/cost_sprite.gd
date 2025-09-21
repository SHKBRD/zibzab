extends Sprite3D
class_name CostSprite

func update_cost(energyCost: int, zabCost: int) -> void:
	%CostEnergy.text = str(energyCost) + "[img width='20']res://assets/ui/energyIcon.png[/img]"
	%CostZab.text = str(zabCost) + "[img width='20']res://assets/ui/zabIcon.png[/img]"

func update_title(title: String) -> void:
	%CostTitle.text = title
