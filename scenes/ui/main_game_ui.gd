extends Control
class_name MainGameUI

func _ready() -> void:
	pass

func update_energy() -> void:
	var energyText: RichTextLabel = $VBoxContainer/EnergyControl/Container/Panel
	energyText.text = "%s/%s%s" % [NumberFormat.format_number_with_commas(Incrementals.energy), NumberFormat.format_number_with_commas(Incrementals.energyGoal), "[img width='30']res://assets/ui/energyIcon.png[/img]"]

func _process(delta: float) -> void:
	update_energy()
