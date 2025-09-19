extends Control
class_name PlotStatView

func update_name_description(plotName: String, plotDescription) -> void:
	%PlotName.text = "[b]" + plotName + "[/b]"
	%PlotDescription.text = "[i]" + plotDescription + "[/i]"

func update_assigned_zibs(assignedZibAmount: int, zibLimit: int) -> void:
	%PlotAssignedZibs.text = "[i]Assigned Zibs: " + str(assignedZibAmount) + "/" + str(zibLimit) + "[/i]"

func add_text_row_element(text: String) -> void:
	var newRTL: PlotStatText = Instantiate.scene(PlotStatText)
	newRTL.text = text
	%VBox.add_child(newRTL)


func _on_button_pressed() -> void:
	print("Fucked.")
