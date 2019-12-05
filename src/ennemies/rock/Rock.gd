extends KinematicBody2D

var rotation_speed = rand_range(50, 250)
var movement_speed = 100
var direction = Vector2()
var taille = 1

onready var screen_size = get_viewport().size

# Called when the node enters the scene tree for the first time.
func _ready():
	var starting_pos = randi() % 2
	if starting_pos == 1:
		position.x = rand_range(-48, -24)
		position.y = rand_range(-48, -24)
	else:
		position.x = rand_range(screen_size.x + 24, screen_size.y + 48)
		position.y = rand_range(screen_size.x + 24, screen_size.y + 48)
	
	direction.x = rand_range(0, 1)
	direction.y = rand_range(0 ,1)
	direction = direction.normalized()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = rotation_degrees + rotation_speed * delta
	
	var collision = move_and_collide(direction * movement_speed * delta)
	if collision != null:
		on_collision(collision)
		
	position.x = wrapf(position.x, -24, screen_size.x + 24)
	position.y = wrapf(position.y, -24, screen_size.y + 24)
		
func on_collision(collision):
	if collision.name != "PlayerShip":
		if taille == 1:
			queue_free()
		else:
			queue_free()