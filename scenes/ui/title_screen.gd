extends Control
class_name TitleScreen

signal game_started

func _on_button_pressed() -> void:
	game_started.emit()
