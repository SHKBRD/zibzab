extends Node3D
class_name Development

enum DevelopmentType {
	NONE,
	MAIN,
	TOWER,
	CORRAL,
	CHARGER,
	ZIB_MAKER
}

static var devTypeClassNames: Dictionary[DevelopmentType, GDScript] = {
	DevelopmentType.MAIN: MainDevelopment,
	DevelopmentType.TOWER: EnergyGenDevelopment,
	DevelopmentType.CORRAL: CorralDevelopment,
	DevelopmentType.CHARGER: ChargerDevelopment,
	DevelopmentType.ZIB_MAKER: ZibMakerDevelopment
}

@export var orbitCenter: Node3D
@export var orbitRadius: float

@export var zibWorkingCapacity: int
