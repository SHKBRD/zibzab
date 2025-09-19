extends Development
class_name MainDevelopment

func apply_calculated_work_value() -> bool:
	produce_energy_from_work()
	produce_zabs_from_work()
	return true

func update_plot_hud_development_specific() -> void:
	var plotHud: PlotStatView = get_parent().get_parent().get_plot_hud()
	plotHud.add_text_row_element("+")
