extends Development
class_name ZibMakerDevelopment

@export_category("Zib Maker Settings")
@export var workRequired: float = 20
@export var zibHolderBaseEnergyCost: float = 1000
@export var zibHolderBaseZabCost: float = 10

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
		newZibHolder.query_build_price.connect(attempt_present_zib_holder_price)
		

func get_zib_holder_energy_build_price() -> float:
	var energyCost: float = zibHolderBaseEnergyCost
	energyCost *= WorldSpace.world.get_zib_count()
	
	return energyCost

func get_zib_holder_zab_build_price() -> float:
	var zabCost: float = zibHolderBaseZabCost
	zabCost *= WorldSpace.world.get_zib_amount_cost_mult()
	
	return zabCost

func attempt_present_zib_holder_price(zibHolder: ZibHolder) -> void:
	var energyPrice: float = get_zib_holder_energy_build_price()
	var zabPrice: float = get_zib_holder_zab_build_price()
	zibHolder.display_price(int(ceil(energyPrice)), int(ceil(zabPrice)))

func buy_new_zib_holder(zibHolder: ZibHolder) -> void:
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
