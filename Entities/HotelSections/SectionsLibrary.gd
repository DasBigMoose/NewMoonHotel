extends Resource
class_name SectionsLibrary

@export var hotelSections : Array[SectionResource]

func getRandomSection(requester : TransitionSpot) -> SectionResource:
	var requestingSection = requester.section
	var viableSections = []

	for curSection in hotelSections:
		if requestingSection.resource.id != curSection.id:
			viableSections.append(curSection)

	return viableSections.pick_random()
