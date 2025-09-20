extends VBoxContainer
class_name DisplayTablet

var viewedPage: int = 0

func _ready() -> void:
	update_page()
	adjust_focus_page()

func update_page() -> void:
	for pageInd: int in %TabletContents.get_children().size():
		var focusPage: TabletPage = %TabletContents.get_node("Page"+str(pageInd))
		if pageInd == viewedPage:
			focusPage.show()
		else:
			focusPage.hide()
		

func adjust_focus_page() -> void:
	viewedPage = clamp(viewedPage, 0, %TabletContents.get_child_count()-1)
	if viewedPage == 0:
		%BackButton.hide()
	else:
		%BackButton.show()
	if viewedPage == %TabletContents.get_child_count()-1:
		%NextButton.hide()
	else:
		%NextButton.show()

func _on_back_button_pressed() -> void:
	viewedPage -= 1
	adjust_focus_page()
	update_page()


func _on_next_button_pressed() -> void:
	viewedPage += 1
	adjust_focus_page()
	update_page()


func _on_close_button_pressed() -> void:
	hide()
