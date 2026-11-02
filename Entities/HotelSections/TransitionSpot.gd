extends Node3D
class_name TransitionSpot

@export var entrance : bool = false
@export var visible_from_entrance : bool = false
@export_range(-360, 360, 0.1, "radians_as_degrees") var exit_rotation = 0.0

var _attached_position : TransitionSpot
var attached_position : TransitionSpot :
	get:
		return _attached_position
	set(value):
		_attached_position = value
		$AutoLoadArea.set_collision_layer_value(3, value == null)

var section : HotelSection :
	get:
		return get_parent().get_parent() as HotelSection

func _ready():
	var System = SectionSystem.System
	if System.debug:
		var scene = null
		if entrance:
			scene = System.entranceDebugScene
		else:
			scene = System.exitDebugScene

		scene = scene.instantiate()

		add_child(scene)
		scene.owner = self

func attachNewSection(count : int = 0) -> bool:
	if attached_position:
		return false

	var System = SectionSystem.System
	var newSection = System.getRandomSection(self)
	System.attachSection(self, newSection, count)

	newSection.on_attached(self, count)

	return true
