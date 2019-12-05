extends Node2D

const TURN_SPEED = 180
const MOVE_SPEED = 150

func _process(delta):
	if Input.is_action_pressed("left"):
		rotation_degrees -= TURN_SPEED * delta
	if Input.is_action_pressed("right"):
		rotation_degrees += TURN_SPEED * delta