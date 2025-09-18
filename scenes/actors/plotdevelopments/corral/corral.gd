extends Development
class_name CorralDevelopment

var workDecrease: int = 1

func on_zib_work_completed(amount: int, zib: Zib) -> void:
	for applyAmount: int in amount:
		zib.workCompleted -= (1 + workDecrease)
	zib.workCompleted = clamp(zib.workCompleted, 0, zib.workLimit)
	
	if zib.workCompleted == 0:
		zib.make_zib_untired()

func update_plot_hud_development_specific() -> void:
	pass
