extends Control
class_name MainGameUI

signal music_mute
var musicMuted: bool = false

func _ready() -> void:
	Incrementals.goal_reached.connect(goal_reached)
	Incrementals.goal_reached.connect(display_finish_game_button)
	%MusicButton.text = "Music: ON"

func start_stopwatch() -> void:
	%Stopwatch.timerRunning = true

func update_energy() -> void:
	var energyText: RichTextLabel = $VBoxContainer/EnergyControl/Container/Panel
	energyText.text = "%s/%s%s" % [NumberFormat.format_number_with_commas(Incrementals.energy), NumberFormat.format_number_with_commas(Incrementals.energyGoal), "[img width='30']res://assets/ui/energyIcon.png[/img]"]

func update_zabs() -> void:
	var zabText: RichTextLabel = $VBoxContainer/ZabControl/Container/Panel
	zabText.text = "%s%s" % [NumberFormat.format_number_with_commas(Incrementals.zabs), "[img width='30']res://assets/ui/zabIcon.png[/img]"]

func display_finish_game_button() -> void:
	%FinishGameButton.show()

func _process(delta: float) -> void:
	update_energy()
	update_zabs()


func goal_reached() -> void:
	pass

func display_end_screen() -> void:
	%WinScreen.show()

func _on_how_to_play_button_pressed() -> void:
	if %DisplayTablet.visible:
		%DisplayTablet.hide()
	else:
		%DisplayTablet.show()


func _on_finish_game_button_pressed() -> void:
	%Stopwatch.timerRunning = false
	if %WinScreen.visible:
		%WinScreen.hide()
	else:
		display_end_screen()


func _on_music_button_pressed() -> void:
	music_mute.emit()
	musicMuted = not musicMuted
	if musicMuted:
		%MusicButton.text = "Music: OFF"
	else:
		%MusicButton.text = "Music: ON"
