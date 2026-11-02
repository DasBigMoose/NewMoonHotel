extends Node3D
class_name Player


static var player : Player
@export var movement_speed : float = .25
@export var travel_distance : int = 1

@onready var left_rotation : float = deg_to_rad(90)
@onready var right_rotation : float = deg_to_rad(-90)
@onready var foot_step_sounds : RandomSoundBite = $FootStepSounds
@export var step_sound_spacing : float = 1.0

@onready var time_since_last_step_sound : float = step_sound_spacing

var movement_tween : Tween
var rotation_tween : Tween

var movement_enabled : bool = true

var left_collissions : Dictionary[int, bool]
var right_collissions : Dictionary[int, bool]
var forward_collissions : Dictionary[int, bool]
var backward_collissions : Dictionary[int, bool]

var current_target_position : Vector3

var move_vector



const MOVE_LEFT = "move_left"
const MOVE_RIGHT = "move_right"
const MOVE_FORWARD = "move_forward"
const MOVE_BACKWARD = "move_backward"

const movement_actions : Array[String] = [
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_FORWARD,
	MOVE_BACKWARD
	]

const ROTATE_LEFT = "rotate_left"
const ROTATE_RIGHT = "rotate_right"

const move_vectors : Dictionary[String, Vector3] = {
	"move_left" = Vector3.LEFT,
	"move_right" = Vector3.RIGHT,
	"move_forward" = Vector3.FORWARD,
	"move_backward" = Vector3.BACK,
	}

func _ready() -> void:
	player = self

func _physics_process(_delta: float) -> void:
	var sightRays : Array[RayCast3D] = [
		$RightRay,
		$LeftRay,
		$ForwardRay,
		$BackwardRay
	]

	# This is for checking if any un-attached transition spots are potentially visible to the player. 
	# This is to prevent any black voids that could occurr from either the cull process or a series of long hallways
	for sightRay in sightRays:
		if sightRay.is_colliding():
			var collider = sightRay.get_collider()
			if collider and collider.get_collision_layer_value(3):
				var point = collider.get_parent() as TransitionSpot

				if !point.attached_position:
					point.attachNewSection()


			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_last_step_sound += delta
	for action in movement_actions:
		process_movement(action)

	#Make this fluid
	if Input.is_action_pressed(ROTATE_LEFT):
		process_rotation(left_rotation)
	if Input.is_action_pressed(ROTATE_RIGHT):
		process_rotation(right_rotation)
	
	if move_vector:
		if can_tween():
			movement_tween = get_tree().create_tween()
			movement_tween.tween_property(self, "position", position+(move_vector * travel_distance), movement_speed)
			move_vector = null
			if time_since_last_step_sound >= step_sound_spacing:
				foot_step_sounds.play_sound()
				time_since_last_step_sound = 0.0

func process_rotation(angle):
	if can_tween():
		rotation_tween = get_tree().create_tween()
		rotation_tween.tween_property(self, "rotation", rotation+ Vector3(0.0, angle, 0.0), .25)

func process_movement(action):
	if Input.is_action_pressed(action):
		var valid_movements = get_valid_movements()

		if valid_movements.get(action, false) and can_tween():
			move_vector = move_vectors.get(action, Vector3.ZERO).rotated(Vector3(0.0, 1.0, 0.0), rotation.y)

#Overlapping tweens can cause undefined behavior, make sure all tweens have finished before allowing another to start
func can_tween() -> bool:
	return movement_enabled && (!movement_tween or !movement_tween.is_valid()) and (!rotation_tween or !rotation_tween.is_valid())

# Checks the validity of all potential movements. In hindsigh this should have been a switch case based on
# an action string passed into the function.
func get_valid_movements() -> Dictionary:
	return {
		"move_left": left_collissions.is_empty(),
		"move_right": right_collissions.is_empty(),
		"move_forward": forward_collissions.is_empty(),
		"move_backward": backward_collissions.is_empty(),
		}

# These could have been condensed
func _on_forward_area_entered(area : Area3D):
	forward_collissions[area.get_instance_id()] = true

func _on_forward_area_exited(area : Area3D):
	forward_collissions.erase(area.get_instance_id())

func _on_backward_area_entered(area : Area3D):
	backward_collissions[area.get_instance_id()] = true

func _on_backward_area_exited(area : Area3D):
	backward_collissions.erase(area.get_instance_id())

func _on_left_area_entered(area : Area3D):
	left_collissions[area.get_instance_id()] = true

func _on_left_area_exited(area : Area3D):
	left_collissions.erase(area.get_instance_id())
	
func _on_right_area_entered(area : Area3D):
	right_collissions[area.get_instance_id()] = true

func _on_right_area_exited(area : Area3D):
	right_collissions.erase(area.get_instance_id())

func _on_forward_body_entered(body : Node3D):
	forward_collissions[body.get_instance_id()] = true

func _on_forward_body_exited(body : Node3D):
	forward_collissions.erase(body.get_instance_id())

func _on_backward_body_entered(body : Node3D):
	backward_collissions[body.get_instance_id()] = true

func _on_backward_body_exited(body : Node3D):
	backward_collissions.erase(body.get_instance_id())

func _on_left_body_entered(body : Node3D):
	left_collissions[body.get_instance_id()] = true

func _on_left_body_exited(body : Node3D):
	left_collissions.erase(body.get_instance_id())
	
func _on_right_body_entered(body : Node3D):
	right_collissions[body.get_instance_id()] = true

func _on_right_body_exited(body : Node3D):
	right_collissions.erase(body.get_instance_id())
