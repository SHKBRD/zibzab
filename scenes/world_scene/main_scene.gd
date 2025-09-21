extends Node
class_name MainScene

func _ready() -> void:
	get_tree().paused = true
	

func _on_title_screen_game_started() -> void:
	get_tree().paused = false
	%World.start_game()
	%TitleScreen.mouse_filter = Control.MOUSE_FILTER_STOP
	move_title_screen_out()

func move_title_screen_out() -> void:
	var titleMoveTween: Tween = get_tree().create_tween()
	titleMoveTween.tween_property(%TitleScreen, "position", Vector2(-10000, 0), 1.5)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		%ClickAudioStreamPlayer.play()


func _on_song_audio_stream_player_finished() -> void:
	%SongAudioStreamPlayer.play()


func _on_world_music_mute() -> void:
	%SongAudioStreamPlayer.stream_paused = not %SongAudioStreamPlayer.stream_paused
