@tool
extends Node3D

var rows: int = 17
var cols: int = 17

func populate_plots():
	for row: int in rows:
		for col: int in cols:
			var newPlot: Plot = Instantiate.scene(Plot)
			newPlot.position = Vector3(row * 17 - (rows*17/2 - 8), -0.1, col * 17 - (cols*17/2 - 8))
			newPlot.gridX = col
			newPlot.gridY = row
			newPlot.name = "%d,%d" % [col, row]
			add_child(newPlot)
	var centerPlot: Plot = get_node("%d,%d" % [ceil(cols/2), ceil(rows/2)]) as Plot
	centerPlot.raise(Plot.Availability.BOUGHT)
	

func _ready() -> void:
	populate_plots()
