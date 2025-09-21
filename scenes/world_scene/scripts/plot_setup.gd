extends Node3D
class_name PlotSpace

var rows: int = 17
var cols: int = 17

static var focusPlot: Plot = null
	


func populate_plots():
	for row: int in rows:
		for col: int in cols:
			var newPlot: Plot = Instantiate.scene(Plot)
			newPlot.position = Vector3(row * 17 - (rows*17/2 - 8), -0.1, col * 17 - (cols*17/2 - 8))
			newPlot.gridX = col
			newPlot.gridY = row
			newPlot.name = "%d,%d" % [col, row]
			newPlot.gotFocused.connect(on_plot_focused)
			add_child(newPlot)
	var centerPlot: Plot = get_node("%d,%d" % [ceil(cols/2), ceil(rows/2)]) as Plot
	var leftPlot: Plot = get_node("%d,%d" % [ceil(cols/2), ceil(rows/2)-1]) as Plot
	var rightPlot: Plot = get_node("%d,%d" % [ceil(cols/2), ceil(rows/2)+1]) as Plot
	centerPlot.develop(Development.DevelopmentType.MAIN)
	leftPlot.develop(Development.DevelopmentType.CORRAL)
	rightPlot.develop(Development.DevelopmentType.CORRAL)
	
	for zibInt: int in %Zibs.get_child_count():
		if zibInt < 6:
			leftPlot.attempt_transfer_zib_to_this_plot(%Zibs.get_child(zibInt))
		else:
			rightPlot.attempt_transfer_zib_to_this_plot(%Zibs.get_child(zibInt))


func _ready() -> void:
	populate_plots()


func on_plot_focused(plot: Plot) -> void:
	# if focusplot is set to the plot it already has, this makes focusPlot null
	var initFocusPlot: Plot = focusPlot
	if focusPlot:
		focusPlot.defocus()
		

		
	if initFocusPlot != plot:
		focusPlot = plot
		focusPlot.focus()
	else:
		focusPlot = null
	#print("Plot: " + str(focusPlot))
