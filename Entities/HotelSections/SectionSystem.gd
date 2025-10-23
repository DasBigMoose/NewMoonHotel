extends Node3D
class_name SectionSystem

static var System : SectionSystem

@export_group("Set up")
@export var section_library : SectionsLibrary
@export var starting_room : SectionResource
@export var player_scene : PackedScene
@export var recursionLimit : int = 5
@export var min_cull_depth : int = 4
@export var games_library : Array[GameResource]
@export_group("Debug")
@export var debug : bool = false
@export var exitDebugScene : PackedScene
@export var entranceDebugScene : PackedScene


var num_sections : int = 0
var currentGameIndex : int = 0

func _ready():
	System = self

	starting_room.generate_ids()
	var starting_section = starting_room.instantiate(self) as HotelSection

	hydrateSectionDoors(starting_section)
	starting_section.load_attached_sections()

	var player = player_scene.instantiate()

	add_child(player)
	player.owner = self
	var spawnPos = starting_section.spawnPosition.global_position
	player.global_position = spawnPos

func getRandomSection(requester : TransitionSpot) -> HotelSection:
	var sectionResource = section_library.getRandomSection(requester)
	return sectionResource.instantiate(self)

func cull_sections(current_point : TransitionSpot, previous_point : TransitionSpot = null, depth : int = 0):
	var current_section = current_point.section
	if depth >= min_cull_depth:
		current_section.queue_free()
		previous_point.attached_position = null

	for point in current_section.all_points:
		if depth > 0 && point == current_point:
			continue

		if point.attached_position:
			cull_sections(point.attached_position, point, depth + 1)

func attachSection(attachPoint : TransitionSpot, section : HotelSection, _count : int = 0):
	num_sections += 1

	# add_child(section)
	# section.owner = self

	var sectionPoint = section.entrance if !attachPoint.entrance else section.exit_points.pick_random()
	var rotAngle = attachPoint.exit_rotation if !attachPoint.entrance else -sectionPoint.exit_rotation 

	section.position = attachPoint.global_position
	section.align(sectionPoint, rotAngle + attachPoint.section.rotation.y)

	sectionPoint.attached_position = attachPoint
	attachPoint.attached_position = sectionPoint
	hydrateSectionDoors(section)

func hydrateSectionDoors(section : HotelSection):
	for door in section.gameDoors:
		print(currentGameIndex)
		door.setGame(games_library[currentGameIndex])
		currentGameIndex += 1
		if currentGameIndex >= games_library.size():
			currentGameIndex = 0
