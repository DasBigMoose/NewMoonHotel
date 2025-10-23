extends Node3D
class_name RayCaster

@export var scanDirections : Array[Vector3]
@export var scanMagnitude : float
@export_flags_3d_physics var layers_3d_physics

func _physics_process(_delta: float) -> void:
	for scanDirection in scanDirections:
		var query = PhysicsRayQueryParameters3D.create(global_position, scanDirection * scanMagnitude, layers_3d_physics)
		query.collide_with_areas = true
