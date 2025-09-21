extends Node3D
class_name ZibHolder

signal attempt_purchase(holder: ZibHolder)
signal completed(holder: ZibHolder)


@export var heldZib: Zib:
	set(value):
		heldZib = value
@export var holderSpot: Node3D

var highlightOutline: Material = preload("res://shaders/Highlight.tres")
var blueOutline: Material = preload("res://shaders/blue.tres")

var progressMade: float = 0
var progressRequired: float = 40
var fulfilled: bool = false

var bought: bool = false


func _ready() -> void:
	pass

func make_progress() -> void:
	progressMade += 1
	
	if progressMade == progressRequired:
		fulfilled = true
		var parentDevelopment: Development = get_parent().get_parent()
		if parentDevelopment is ZibMakerDevelopment:
			make_zib()
		elif parentDevelopment is ChargerDevelopment:
			charge_zib()
		
	

func make_zib() -> void:
	var newZib: Zib = Instantiate.scene(Zib)
	WorldSpace.world.add_zib(newZib)
	newZib.global_position = %ZibHolderSpot.global_position
	newZib.moving_to_plot.connect(on_zib_leaving_holder)

func charge_zib() -> void:
	(get_parent().get_parent() as ChargerDevelopment).assignedZibs[0].supercharge()

func _process(delta: float) -> void:
	var present: bool = false
	var parentDevelopment: Development = get_parent().get_parent()
	if parentDevelopment is ChargerDevelopment:
		if not parentDevelopment.assignedZibs.is_empty():
			present = true
	else:
		if bought and not fulfilled:
			present = true
	if present:
		%ProgressSprite.show()
		%ProgressSprite.update_progress(progressMade/progressRequired)
	else:
		%ProgressSprite.hide()
	#print("Charge progress: " + str(progressMade))

func reset_progress() -> void:
	fulfilled = false
	progressMade = 0

func on_zib_leaving_holder(plot: Plot, zib: Zib) -> void:
	var parentDevelopment: Development = get_parent().get_parent()
	if parentDevelopment is ZibMakerDevelopment:
		unbought()
	elif parentDevelopment is ChargerDevelopment:
		pass
	zib.moving_to_plot.disconnect(on_zib_leaving_holder)
	reset_progress()
	


func attempt_to_display_price() -> void:
	var energyPrice: float = Incrementals.get_zib_holder_energy_build_price()
	var zabPrice: float = Incrementals.get_zib_holder_zab_build_price()
	display_price(int(ceil(energyPrice)), int(ceil(zabPrice)))

func display_price(energyPrice: int, zabPrice: int) -> void:
	%CostSprite.show()
	%CostSprite.update_cost(energyPrice, zabPrice)

func get_bought() -> void:
	bought = true
	hide_price()
	%ZibHolderAdderAreaCol.disabled = true
	%ZibHolderMain.show()
	%ZibHolderAdder.hide()

func unbought() -> void:
	bought = false
	%ZibHolderAdderAreaCol.disabled = false
	%ZibHolderMain.hide()
	%ZibHolderAdder.show()

func hide_price() -> void:
	%CostSprite.hide()

func _on_zib_holder_adder_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if Incrementals.can_buy(Incrementals.get_zib_holder_energy_build_price(), Incrementals.get_zib_holder_zab_build_price()):			
				attempt_purchase.emit(self)
			else:
				WorldSpace.reject_payment()

func _on_zib_holder_adder_area_mouse_entered() -> void:
	%ZibHolderAdder.set_surface_override_material(2, blueOutline)
	attempt_to_display_price()


func _on_zib_holder_adder_area_mouse_exited() -> void:
	%ZibHolderAdder.set_surface_override_material(2, highlightOutline)
	hide_price()
