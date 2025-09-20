extends Development
class_name ChargerDevelopment

@export_category("Supercharger Settings")


func _ready() -> void:
	super()
	%ZibHolder.get_bought()

func update_plot_hud_development_specific() -> void:
	pass

func on_zib_work_completed(amount: int, zib: Zib) -> bool:
	for timesWorkApplied: int in amount:
		%ZibHolder.make_progress()
	return false
