extends KinematicBody2D

const TURN_SPEED = 180
const MOVE_SPEED = 150
var velocity = Vector2(0,0)
var applied_forces = Vector2()
const ACC = 0.05
const DEC = 0.01
onready var screen_size = get_viewport().size

func _process(delta):
	if Input.is_action_pressed("left"):
		rotation_degrees -= TURN_SPEED * delta
	if Input.is_action_pressed("right"):
		rotation_degrees += TURN_SPEED * delta
		
	var movedir = Vector2(1,0).rotated(rotation)
	if Input.is_action_pressed("up"):
		velocity = velocity.linear_interpolate(movedir, ACC)
	else:
		velocity = velocity.linear_interpolate(Vector2(0,0), DEC)

	move_and_collide(((velocity * MOVE_SPEED) + applied_forces) * delta)
	applied_forces = Vector2(0, 0)
	position.x = wrapf(position.x, -8, screen_size.x + 8)
	position.y = wrapf(position.y, -8, screen_size.y + 8)
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		$Weapon.shot(position)