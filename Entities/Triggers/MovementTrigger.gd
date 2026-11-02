#UNUSED
extends Trigger

@export var movementCount : int = 10
var timesMoved : int = 0

func performCheck() -> bool:
	return timesMoved >= movementCount

func _on_player_movement():
	timesMoved += 1
