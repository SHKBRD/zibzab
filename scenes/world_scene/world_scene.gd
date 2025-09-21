extends Node3D
class_name WorldSpace

signal music_mute

static var world: WorldSpace = null
static var buildingAmount: int = 0

static func reject_payment() -> void:
	pass

func _ready() -> void:
	if world != null: assert(false, "ONLY ONE WORLD INSTANCE ALLOWED!")
	world = self

func start_game() -> void:
	var transparencyTween: Tween = get_tree().create_tween()
	transparencyTween.tween_property(%MainGameUI, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0)
	
	
	%MainGameUI.start_stopwatch()

func get_zib_count() -> int:
	return %Zibs.get_child_count()

func add_zib(zib: Zib) -> void:
	%Zibs.add_child(zib)

func make_fail_noise() -> void:
	%ErrorAudioStreamPlayer.play()

func _process(delta: float) -> void:
	print(Incrementals.zabs)


func _on_main_game_ui_music_mute() -> void:
	music_mute.emit()
