extends Control
class_name PlotStatView

func add_text_row_element(str: String) -> void:
	var newRTL: PlotStatText = Instantiate.scene(PlotStatText)
	newRTL.text = str
	%VBox.add_child(newRTL)
