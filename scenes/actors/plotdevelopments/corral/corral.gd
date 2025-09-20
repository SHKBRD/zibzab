extends Development
class_name CorralDevelopment

var workDecrease: int = 1

func on_zib_work_completed(amount: int, zib: Zib) -> bool:
	print("Amount: " + str(amount) + "zibWorkProg: " + str(zib.zibWorkProgress))
	for applyAmount: int in amount:
		zib.workCompleted -= (workDecrease)
		zib.zibWorkProgress -= 1
	zib.workCompleted = clamp(zib.workCompleted, 0, zib.workLimit)
	
	if zib.workCompleted == 0:
		zib.make_zib_untired()
	return false

func update_plot_hud_development_specific() -> void:
	pass
