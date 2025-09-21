extends Sprite3D
class_name ProgressSprite

func _ready() -> void:
	texture = (get_node("SubViewport") as SubViewport).get_texture()

func update_progress(percent: float) -> void:
	%ProgressBar.value = percent
	if percent == 0 or percent == 1:
		hide()
	else:
		show()
