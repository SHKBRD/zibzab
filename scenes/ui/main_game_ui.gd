extends Control
class_name MainGameUI

func _ready() -> void:
	Incrementals.goal_reached.connect(goal_reached)
	Incrementals.goal_reached.connect(display_finish_game_button)
	%Stopwatch.timerRunning = true

func update_energy() -> void:
	var energyText: RichTextLabel = $VBoxContainer/EnergyControl/Container/Panel
	energyText.text = "%s/%s%s" % [NumberFormat.format_number_with_commas(Incrementals.energy), NumberFormat.format_number_with_commas(Incrementals.energyGoal), "[img width='30']res://assets/ui/energyIcon.png[/img]"]

func update_zabs() -> void:
	var zabText: RichTextLabel = $VBoxContainer/ZabControl/Container/Panel
	zabText.text = "%s%s" % [NumberFormat.format_number_with_commas(Incrementals.zabs), "[img width='30']res://assets/ui/zabIcon.png[/img]"]

func display_finish_game_button() -> void:
	pass

func _process(delta: float) -> void:
	update_energy()
	update_zabs()


func goal_reached() -> void:
	pass

func display_end_screen() -> void:
	pass

func _on_how_to_play_button_pressed() -> void:
	%DisplayTablet.show()


func _on_finish_game_button_pressed() -> void:
	display_end_screen()
