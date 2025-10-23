@tool
extends AudioStreamPlayer
class_name RandomSoundBite

@export_group("Sound Segments")
@export var soundName : String
@export var soundStart : float
@export var soundEnd : float
@export_tool_button("Add Sound", "Callable") var addSoundAction = add_sound
@export var soundSegments : Dictionary[String, SoundBiteResource]
@export_group("Test Actions")
@export_tool_button("Play Random Sound", "Callable") var randomSoundAction = play_sound
@export var selectedSoundName : String
@export_tool_button("Play Select Sound", "Callable") var selectSoundAction = play_selected_sound

var currentSound : SoundBiteResource

func _process(_delta: float) -> void:
	if playing && currentSound:
		var time = get_playback_position() + AudioServer.get_time_since_last_mix()
		if time >= currentSound.end:
			stop()
			currentSound = null
	elif playing:
		#Theoretically shouldn't happen, but hey should do this just in case
		stop()
	elif currentSound:
		currentSound = null

		
func add_sound():
	var newSound = SoundBiteResource.new()
	newSound.name = soundName
	newSound.start = soundStart
	newSound.end = soundEnd

	soundSegments[soundName] = newSound

	soundName = ""
	soundStart = 0.0
	soundEnd = 0.0

func play_selected_sound():
	if soundSegments.has(selectedSoundName):
		currentSound = soundSegments[selectedSoundName]
		play(currentSound.start)

func play_sound():
	currentSound = soundSegments.values().pick_random()
	play(currentSound.start)
