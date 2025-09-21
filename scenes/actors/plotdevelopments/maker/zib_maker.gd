extends Development
class_name ZibMakerDevelopment

@export_category("Zib Maker Settings")
@export var workRequired: float = 20


var makerWorkProgress: float = 0

var zibHolders: Array[ZibHolder] = []

func _ready() -> void:
	super()
	initialize_zib_holders()

func initialize_zib_holders() -> void:
	for zibIndex: int in range(1, 4):
		var newZibHolder: ZibHolder = Instantiate.scene(ZibHolder)
		var zibHolderHolder: Node3D = get_node("ZibHolderSpot" + str(zibIndex))
		zibHolderHolder.add_child(newZibHolder)
		zibHolders.append(newZibHolder)
		newZibHolder.attempt_purchase.connect(buy_new_zib_holder)
		

func buy_new_zib_holder(zibHolder: ZibHolder) -> void:
	Incrementals.spend(Incrementals.get_zib_holder_energy_build_price(), Incrementals.get_zib_holder_zab_build_price())
	zibHolder.get_bought()

func update_plot_hud_development_specific() -> void:
	pass

func produce_zib_maker_progress() -> bool:
	var firstHolder: ZibHolder = null
	for zibHolder: ZibHolder in zibHolders:
		if zibHolder != null and firstHolder == null and zibHolder.bought and not zibHolder.fulfilled:
			firstHolder = zibHolder
			
	if firstHolder:
		firstHolder.make_progress()
		return true
	else:
		return false

func apply_calculated_work_value() -> bool:
	var result: bool = produce_zib_maker_progress()
	return result
