@tool
extends Light3D

@export_group("Energy Flicker")
@export var energy_flicker_enabled : bool = false
@export var energy_flicker_frequency : float = .25
@export var energy_flicker_variance : float = .15
@export var energy_flicker_magnitude : float = .5
@export var base_energy_level : float = 0.0


var energy_flicker_timer : float = 0.0
var current_energy_flicker_target : float = 0.0

func _ready():
	restart_energy_flicker()

func _process(delta: float) -> void:
	if energy_flicker_enabled:
		energy_flicker_timer += delta
		
		if energy_flicker_timer >= current_energy_flicker_target:
			light_energy = maxf(0.0, base_energy_level + randf_range(-energy_flicker_magnitude, energy_flicker_magnitude))
			restart_energy_flicker()
	
func restart_energy_flicker():
	current_energy_flicker_target = energy_flicker_frequency + randf_range(0.0, energy_flicker_variance)
	energy_flicker_timer = 0.0
