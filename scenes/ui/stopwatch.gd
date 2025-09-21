extends Control
class_name Stopwatch

var hours: int = 0
var minutes: int = 0
var seconds: int = 0
var secondProgress: float = 0
var timerRunning: bool = false

func _process(delta: float) -> void:
	if timerRunning:
		secondProgress += delta
		while secondProgress >= 1:
			seconds += 1
			secondProgress -= 1
		while seconds >= 60:
			minutes += 1
			seconds -= 60
		while minutes >= 60:
			hours += 1
			minutes -= 1
		update_text()

func update_text() -> void:
	var assembleText: String = ""
	if hours < 10:
		assembleText += "0"
	assembleText += str(hours) + ":"
	if minutes < 10:
		assembleText += "0"
	assembleText += str(minutes) + ":"
	if seconds < 10:
		assembleText += "0"
	assembleText += str(seconds)
	
	%RichTextLabel.text = assembleText
