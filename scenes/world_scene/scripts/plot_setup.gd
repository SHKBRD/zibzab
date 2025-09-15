extends Node3D
class_name PlotSpace

var rows: int = 17
var cols: int = 17

var focusPlot: Plot = null:
	set(value):
		#if focusPlot and not get_tree().get_nodes_in_group("SelectedZibs").is_empty():
		if focusPlot:
			focusPlot.defocus()
			
		if focusPlot != value:
			focusPlot = value
		else:
			focusPlot = null
		print("Plot: " + str(focusPlot))


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
	centerPlot.develop(Development.DevelopmentType.MAIN)


func _ready() -> void:
	populate_plots()


func on_plot_focused(plot: Plot) -> void:
	# if focusplot is set to the plot it already has, this makes focusPlot null
	focusPlot = plot
	
	if focusPlot != null:
		focusPlot.focus()
