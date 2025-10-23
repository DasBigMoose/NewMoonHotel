@tool
extends Resource
class_name SectionResource

@export var sectionScene : PackedScene
@export var ID : int :
	get: return id
@export_tool_button("Generate ID's", "Callable") var generate_ids_action = generate_ids

var id : int

func instantiate(parent : Node3D) -> HotelSection:
	var section = sectionScene.instantiate()

	parent.add_child(section)
	section.owner = parent
	section.resource = self

	return section

func generate_ids():
	var current_id = 1
	var tld = "res://Entities/HotelSections/Sections/"
	var sectionsDirectory = DirAccess.open(tld)
	if sectionsDirectory:
		sectionsDirectory.list_dir_begin()
		var fileName = sectionsDirectory.get_next()
		while fileName != "":
			if sectionsDirectory.current_is_dir():
				var currentSectionDirectory = DirAccess.open(tld + fileName)
				currentSectionDirectory.list_dir_begin()
				var currentSectionFile = currentSectionDirectory.get_next()
				while currentSectionFile != "":
					#This is a resource, now let's see if it can load as a SectionResource
					if currentSectionFile.contains("tres"):
						var resourceFileName = "%s%s/%s" % [tld, fileName, currentSectionFile]
						var resource = ResourceLoader.load(resourceFileName)
						if resource is SectionResource:
							resource.id = current_id
							ResourceSaver.save(resource, resourceFileName)
							current_id += 1
					currentSectionFile = currentSectionDirectory.get_next()
			fileName = sectionsDirectory.get_next()
