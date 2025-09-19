extends Node3D
class_name ZibHolder

signal attempt_purchase(holder: ZibHolder)
signal query_build_price(holder: ZibHolder)

@export var heldZib: Zib
@export var holderSpot: Node3D

var highlightOutline: Material = preload("res://shaders/Highlight.tres")
var blueOutline: Material = preload("res://shaders/blue.tres")

var progressMade: float = 0
var progressRequired: float = 100

var bought: bool = false


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_zib_holder_adder_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			attempt_purchase.emit(self)

func attempt_to_display_price() -> void:
	query_build_price.emit(self)

func display_price(energyPrice: int, zabPrice: int) -> void:
	%CostSprite.show()
	%CostSprite.update_cost(energyPrice, zabPrice)

func get_bought() -> void:
	bought = true
	hide_price()
	%ZibHolderAdderAreaCol.disabled = true
	%ZibHolderMain.show()
	%ZibHolderAdder.hide()
	

func hide_price() -> void:
	%CostSprite.hide()

func _on_zib_holder_adder_area_mouse_entered() -> void:
	%ZibHolderAdder.set_surface_override_material(2, blueOutline)
	attempt_to_display_price()


func _on_zib_holder_adder_area_mouse_exited() -> void:
	%ZibHolderAdder.set_surface_override_material(2, highlightOutline)
	hide_price()
