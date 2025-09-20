extends CenterContainer
class_name ZibStatView

func update_status(zibStatus: String) -> void:
	%ZibStatus.text = "[b][i]" + zibStatus + "[/i][/b]"

func update_tiredness(tiredPercentage: float) -> void:
	var tiredText: String = str(floor(tiredPercentage * 100)) + "% Tired"
	%ZibTiredness.text = "[b]" + tiredText + "[/b]"

func update_energy_rate(energyRate: float) -> void:
	if energyRate == -1:
		%ZibEnergyRate.hide()
	else:
		%ZibEnergyRate.show()
		
		%ZibEnergyRate.text = "%0.2f[img width='20']res://assets/ui/energyIcon.png[/img]/s" % energyRate

func update_zab_rate(zabRate: float) -> void:
	if zabRate == -1:
		%ZibZabRate.hide()
	else:
		%ZibZabRate.show()
		
		%ZibZabRate.text = "%0.2f[img width='20']res://assets/ui/zabIcon.png[/img]/s" % zabRate
