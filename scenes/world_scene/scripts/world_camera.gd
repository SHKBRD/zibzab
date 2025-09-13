extends Camera3D
class_name WorldCamera

@export var camera_acceleration: float = 300
@export var camera_vel_cap: float = 30.0
@export var camera_move_friction: float = 0.001


var camVelocity: Vector2 = Vector2(0, 0)
var camInputDirection: Vector2 = Vector2()

func _ready() -> void:
	pass

func camera_input(delta: float) -> void:
	camInputDirection = Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	camVelocity += camInputDirection*camera_acceleration * delta

func process_camera_movement(delta: float) -> void:
	#  -= Vector2(camera_move_friction, camera_move_friction) * delta
	var camFriction: float = (camera_move_friction)
	if not camInputDirection:
		camFriction = lerp(0.0, camFriction, 0.2)
	#camVelocity -= camVelocity.normalized() * camFriction
	camVelocity = lerp(camVelocity, Vector2(), 1-(pow(camFriction, delta/2)))
	camVelocity = camVelocity.clamp(Vector2(-camera_vel_cap, -camera_vel_cap), Vector2(camera_vel_cap, camera_vel_cap))
	
	if not camInputDirection and camVelocity.abs().length() < 0.2:
		camVelocity = Vector2()
	
	position += Vector3(camVelocity.x, 0, camVelocity.y) * delta

func _process(delta: float) -> void:
	camera_input(delta)
	process_camera_movement(delta)
	# print(camVelocity)
