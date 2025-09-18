extends Control
class_name PlotStatView

func update_name_description(plotName: String, plotDescription) -> void:
	%PlotName.text = "[b]" + plotName + "[/b]"
	%PlotDescription.text = "[i]" + plotDescription + "[/i]"

func add_text_row_element(text: String) -> void:
	var newRTL: PlotStatText = Instantiate.scene(PlotStatText)
	newRTL.text = text
	%VBox.add_child(newRTL)
