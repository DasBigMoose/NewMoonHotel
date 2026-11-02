extends Node3D
class_name HotelSection

@export var transition_spots : Array[TransitionSpot] = []
@export var spawnPosition : Node3D
@export var gridArea : Area3D
@export var gameDoors : Array[GameDoor]

var resource : SectionResource

var entrance : TransitionSpot
var exit_points : Array[TransitionSpot]

var spawn_time : int = 0

const PLAYER_LAYER = 2
const SPAWN_COLLISION_LAYER = 4

var all_points: 
	get: 
		return	([entrance] + exit_points)

var grid : GridMap

func _ready() -> void:
	grid = $GridMap
	for spot in transition_spots:
		if spot.entrance:
			entrance = spot
		else:
			exit_points.append(spot)
	spawn_time = Time.get_ticks_msec()
	if has_node("%GameDoors"):
		var doors = %GameDoors.get_children()
		for door in doors:
			gameDoors.append(door)
	else:
		gameDoors = []

func delete():
	#Disconnect all connected sections
	for point in all_points:
		if point.attached_position:
			point.attached_position.attached_position = null

	# Delete self
	queue_free()


func align(attachSpot : TransitionSpot, rotAngle):
	grid.position -= attachSpot.position
	rotate_y(rotAngle)

func on_attached(_attachedSpot : TransitionSpot, count : int = 0):
	if count < SectionSystem.System.recursionLimit:
		count += 1
		for spot in transition_spots:
			# This ensures that when a new section is attached, then any transition points visible from that entrance gets a section attached.
			# This stops the player from seeing the black void essentially.
			if spot.visible_from_entrance:
				spot.attachNewSection(count)

func load_attached_sections(count : int = 0):
	count += 1
	for spot in transition_spots:
		spot.attachNewSection(count)


func _on_section_entered(area: Area3D) -> void:
	# Both these sections should have been their own function and this listener should have been renamed.
	if area.get_collision_layer_value(SPAWN_COLLISION_LAYER):
		var otherSection = area.get_parent().get_parent()
		if otherSection is HotelSection:
			if otherSection.spawn_time < spawn_time:
				otherSection.delete()

	if area.get_collision_layer_value(PLAYER_LAYER):
		load_attached_sections()
		SectionSystem.System.cull_sections(self.entrance)
