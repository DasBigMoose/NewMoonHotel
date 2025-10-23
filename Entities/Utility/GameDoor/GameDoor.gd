extends Area3D
class_name GameDoor

var gameResource : GameResource
var plaque : Node3D

var enabled : bool = false

func _process(_delta: float) -> void:
	if enabled && Input.is_action_just_released("interact"):
		open_door()

func open_door():
	$DoorOpenSound.play()
	Player.player.movement_enabled = false

func run_game():
	print("Hi!")
	# OS.execute(gameResource.command, [])
	Player.player.movement_enabled = true

func setGame(game : GameResource):
	gameResource = game
	spawnLabel()

func spawnLabel():
	$PlaquePosition/GamePlaquePlaceHolder.queue_free()
	if plaque:
		plaque.queue_free()
		plaque = null
	plaque = gameResource.plaqueScene.instantiate()
	$PlaquePosition.add_child(plaque)

func _on_door_area_entered(_area : Area3D):
	enabled = true

func _on_door_area_exited(_area : Area3D):
	enabled = false

func _on_door_sound_finished():
	run_game()
